import type { ActorMethod } from '@dfinity/agent';
import type { Principal } from '@dfinity/principal';

export interface Answer {
	principal: Principal;
	answer: AnswerType;
	pollId: bigint;
}
export type AnswerType = { YesNo: boolean } | { MultiChoice: string };
export interface Poll {
	id: bigint;
	created: bigint;
	creator: Principal;
	voteCount: bigint;
	question: string;
	fund: bigint;
	questionType: QuestionType;
}
export interface PollWithYesNoStats {
	poll: Poll__1;
	yesNoStats: [bigint, bigint];
}
export interface Poll__1 {
	id: bigint;
	created: bigint;
	creator: Principal;
	voteCount: bigint;
	question: string;
	fund: bigint;
	questionType: QuestionType;
}
export interface Profile {
	img: Uint8Array | number[];
	contact: string;
	about: string;
	username: string;
}
export type QuestionType = { YesNo: null } | { MultiChoice: Array<string> };
export type Result = { ok: null } | { err: string };
export type Result_1 = { ok: UserProfile } | { err: string };
export type Result_2 = { ok: Poll } | { err: string };
export type Result_3 = { ok: Array<[PollWithYesNoStats, boolean]> } | { err: string };
export type Result_4 = { ok: bigint } | { err: string };
export interface UserProfile {
	img: Uint8Array | number[];
	created: bigint;
	contact: string;
	about: string;
	username: string;
}
export interface _SERVICE {
	answerPoll: ActorMethod<[bigint, boolean], Result>;
	createPoll: ActorMethod<[string], Result_4>;
	createUser: ActorMethod<[string], Result>;
	deletePoll: ActorMethod<[bigint], Result>;
	depositCycles: ActorMethod<[], undefined>;
	getAllAnswers: ActorMethod<[], Array<Answer>>;
	getAllPolls: ActorMethod<[], Array<Poll>>;
	getAllPollsWithYesNoAnswers: ActorMethod<[], Result_3>;
	getPoll: ActorMethod<[bigint], Result_2>;
	getPollAnswerScore: ActorMethod<[bigint], [bigint, bigint]>;
	getUser: ActorMethod<[], Result_1>;
	updateProfile: ActorMethod<[Profile], Result>;
	whoami: ActorMethod<[], Principal>;
}
