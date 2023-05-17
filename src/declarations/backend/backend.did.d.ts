import type { ActorMethod } from '@dfinity/agent';
import type { Principal } from '@dfinity/principal';

export interface Profile {
	contact: string;
	about: string;
	username: string;
}
export type Result = { ok: null } | { err: string };
export type Result_1 = { ok: UserProfile } | { err: string };
export interface UserProfile {
	created: bigint;
	contact: string;
	about: string;
	username: string;
}
export interface _SERVICE {
	createUser: ActorMethod<[string], Result>;
	getUser: ActorMethod<[], Result_1>;
	updateProfile: ActorMethod<[Profile], Result>;
	whoami: ActorMethod<[], Principal>;
}
