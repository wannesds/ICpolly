import type { ActorSubclass } from '@dfinity/agent';
import type { _SERVICE } from 'src/declarations/backend/backend.did';

//to declare all type structures

//Backend based
export enum AuthState {
	LoggedOut,
	LoggedIn,
	Registered
}
export type BackendActor = ActorSubclass<_SERVICE>;
//Frontend based
export enum RegiState {
	Username,
	Profile,
	Finished
}
export enum RootState {
	Login,
	Register,
	App
}
export enum AppState {
	Home,
	Profile,
	Create,
	Token,
	Polls,
	Report
}
