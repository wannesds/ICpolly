export const idlFactory = ({ IDL }) => {
	const Result = IDL.Variant({ ok: IDL.Null, err: IDL.Text });
	const Result_4 = IDL.Variant({ ok: IDL.Nat, err: IDL.Text });
	const AnswerType = IDL.Variant({
		YesNo: IDL.Bool,
		MultiChoice: IDL.Text
	});
	const Answer = IDL.Record({
		principal: IDL.Principal,
		answer: AnswerType,
		pollId: IDL.Nat
	});
	const QuestionType = IDL.Variant({
		YesNo: IDL.Null,
		MultiChoice: IDL.Vec(IDL.Text)
	});
	const Poll = IDL.Record({
		id: IDL.Nat,
		created: IDL.Int,
		creator: IDL.Principal,
		voteCount: IDL.Nat,
		question: IDL.Text,
		fund: IDL.Nat,
		questionType: QuestionType
	});
	const Poll__1 = IDL.Record({
		id: IDL.Nat,
		created: IDL.Int,
		creator: IDL.Principal,
		voteCount: IDL.Nat,
		question: IDL.Text,
		fund: IDL.Nat,
		questionType: QuestionType
	});
	const PollWithYesNoStats = IDL.Record({
		poll: Poll__1,
		yesNoStats: IDL.Tuple(IDL.Nat, IDL.Nat)
	});
	const Result_3 = IDL.Variant({
		ok: IDL.Vec(IDL.Tuple(PollWithYesNoStats, IDL.Bool)),
		err: IDL.Text
	});
	const Result_2 = IDL.Variant({ ok: Poll, err: IDL.Text });
	const UserProfile = IDL.Record({
		img: IDL.Vec(IDL.Nat8),
		created: IDL.Int,
		contact: IDL.Text,
		about: IDL.Text,
		username: IDL.Text
	});
	const Result_1 = IDL.Variant({ ok: UserProfile, err: IDL.Text });
	const Profile = IDL.Record({
		img: IDL.Vec(IDL.Nat8),
		contact: IDL.Text,
		about: IDL.Text,
		username: IDL.Text
	});
	return IDL.Service({
		answerPoll: IDL.Func([IDL.Nat, IDL.Bool], [Result], []),
		createPoll: IDL.Func([IDL.Text], [Result_4], []),
		createUser: IDL.Func([IDL.Text], [Result], []),
		deletePoll: IDL.Func([IDL.Nat], [Result], []),
		depositCycles: IDL.Func([], [], []),
		getAllAnswers: IDL.Func([], [IDL.Vec(Answer)], ['query']),
		getAllPolls: IDL.Func([], [IDL.Vec(Poll)], ['query']),
		getAllPollsWithYesNoAnswers: IDL.Func([], [Result_3], ['query']),
		getPoll: IDL.Func([IDL.Nat], [Result_2], ['query']),
		getPollAnswerScore: IDL.Func([IDL.Nat], [IDL.Nat, IDL.Nat], ['query']),
		getUser: IDL.Func([], [Result_1], ['query']),
		updateProfile: IDL.Func([Profile], [Result], []),
		whoami: IDL.Func([], [IDL.Principal], ['query'])
	});
};
export const init = ({ IDL }) => {
	return [];
};
