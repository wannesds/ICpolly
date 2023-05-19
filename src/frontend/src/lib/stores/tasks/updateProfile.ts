import { actor, syncAuth } from '$lib/stores';
import type { Profile } from 'src/declarations/backend/backend.did';
import { get } from 'svelte/store';

export async function updateProfile(newProfile: Profile) {
	const localActor = get(actor);
	console.log('newUserToSend', newProfile);
	await localActor.updateProfile(newProfile).then(async (res) => {
		console.log('res from updateProfile', res);
		await syncAuth();
	});
}
