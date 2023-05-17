export const idlFactory = ({ IDL }) => {
	const Result = IDL.Variant({ ok: IDL.Null, err: IDL.Text });
	const UserProfile = IDL.Record({
		created: IDL.Int,
		contact: IDL.Text,
		about: IDL.Text,
		username: IDL.Text
	});
	const Result_1 = IDL.Variant({ ok: UserProfile, err: IDL.Text });
	const Profile = IDL.Record({
		contact: IDL.Text,
		about: IDL.Text,
		username: IDL.Text
	});
	return IDL.Service({
		createUser: IDL.Func([IDL.Text], [Result], []),
		getUser: IDL.Func([], [Result_1], ['query']),
		updateProfile: IDL.Func([Profile], [Result], []),
		whoami: IDL.Func([], [IDL.Principal], ['query'])
	});
};
export const init = ({ IDL }) => {
	return [];
};
