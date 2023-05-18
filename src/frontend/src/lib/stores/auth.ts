import { Actor, HttpAgent, type Identity } from '@dfinity/agent';
import { AuthClient } from '@dfinity/auth-client';
import type { Principal } from '@dfinity/principal';
import { get, writable } from 'svelte/store';
import { idlFactory } from '../../../../declarations/backend';
//import type { UserProfile } from '../../../../declarations/backend/backend.did';
import type { UserProfile } from 'src/declarations/backend/backend.did';
import { AuthState, type BackendActor } from './types';

export const authStore = writable<AuthState>();
export let actor = writable<BackendActor>();
export let user = writable<UserProfile>(); //named let user instead of userProfile for ease
export let caller = writable<Principal>();
let authClient: AuthClient;

export async function start() {
	authClient = await AuthClient.create();
	console.log('Auth: authClient created');

	if (await authClient.isAuthenticated()) {
		await checkRegistration();
	} else {
		console.log('Auth: logging out!');
		authStore.set(AuthState.LoggedOut);
	}
}

start();

async function createActor() {
	const isAuthenticated = await authClient.isAuthenticated();

	if (!isAuthenticated) {
		actor = writable<BackendActor>();
		return;
	}

	const identity: Identity = authClient.getIdentity();

	const agent = new HttpAgent({
		identity,
		host: import.meta.env.VITE_HOST
	});

	// Fetch root key for certificate validation during development
	if (import.meta.env.VITE_DFX_NETWORK !== 'ic') {
		agent.fetchRootKey().catch((err) => {
			console.warn(
				'AuthERR: Unable to fetch root key. Check to ensure that your local replica is running'
			);
			console.error(err);
		});
	}

	const localActor: BackendActor = Actor.createActor(idlFactory, {
		agent,
		canisterId: import.meta.env.VITE_BACKEND_CANISTER_ID
	});

	actor.set(localActor);
}

async function checkRegistration(): Promise<void> {
	await createActor();
	const localActor = get(actor);
	let p = await localActor.whoami();
	let result = await localActor.getUser();
	if (result.hasOwnProperty('ok')) {
		user.set(result.ok);
		console.log('Auth: user set ->', get(user));
		authStore.set(AuthState.Registered);
		caller.set(p);
	} else if (result.hasOwnProperty('err')) {
		console.log('AuthERR: could not check registration');
		user = writable<UserProfile>();
		authStore.set(AuthState.LoggedIn);
	} else {
		console.error(result);
	}
}

export async function syncAuth() {
	const isAuthenticated = await authClient.isAuthenticated();
	isAuthenticated ? await checkRegistration() : authStore.set(AuthState.LoggedOut);
}

export async function login() {
	await authClient.login({
		identityProvider:
			import.meta.env.VITE_DFX_NETWORK === 'ic' //internet identity
				? 'https://identity.ic0.app/' //II live
				: 'http://qhbym-qaaaa-aaaaa-aaafq-cai.localhost:8080/', //II local
		onSuccess: async () => await checkRegistration()
	});
}

export async function logout() {
	await authClient.logout();
	authStore.set(AuthState.LoggedOut);
}
