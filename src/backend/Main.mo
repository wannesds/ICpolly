import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";
import Int8 "mo:base/Int8";
import Int32 "mo:base/Int32";
import Array "mo:base/Array";
import Float "mo:base/Float";
import Order "mo:base/Order";
import None "mo:base/None";
import Error "mo:base/Error";

import Util "Utils";
import T "Types";

actor {
	//TYPES INDEX
	public type User = T.User;
	public type Profile = T.Profile;
	public type UserProfile = T.UserProfile;

	public type QuestionType = T.QuestionType;
	public type AnswerType = T.AnswerType;
	public type Poll = T.Poll;
	public type Answer = T.Answer;
	public type PollWithYesNoStats = T.PollWithYesNoStats;

	//CONSTANTS
	let genericErr = {
		getPoll = "Couldn't find poll with id ";
		verifyCreator = "You are not the creator!";
		alreadyAnswered = "You already answered this poll!";
		answerPoll = "Can't answer poll!";
		notRegistered = "You are not registered!";
		alreadyRegistered = "You are already registered!";
		noPollFetch = "Could not fetch requested poll data!";
	};

	// PRIVATE FUNCTIONS

	func _verifyAnswerType(a : AnswerType, q : QuestionType) : Bool {
		switch (a, q) {
			case (#YesNo(_), #YesNo(_)) true;
			case (#MultiChoice(_), #MultiChoice(_)) true;
			case (_) false;
		};
	};

	func _sortByVotes(x : Poll, y : Poll) : Order.Order {
		//manual sort func
		if (x.voteCount < y.voteCount) {
			#less;
		} else if (x.voteCount > y.voteCount) {
			#greater;
		} else {
			#equal;
		};
	};

	func _getAllPolls() : [Poll] {
		let buf = Buffer.Buffer<Poll>(8);

		for ((key, value) in pollStore.entries()) {
			buf.add(value);
		};

		let arr = Buffer.toArray(buf);
		Array.sort(arr, _sortByVotes);
	};

	func _getAllAnswers() : [Answer] {
		let buf = Buffer.Buffer<Answer>(8);

		for ((key, value) in answerStore.entries()) {
			buf.add(value);
		};

		Buffer.toArray(buf);
	};

	func _checkIfVoted(principal : Principal, id : Nat) : Bool {
		for ((key, value) in answerStore.entries()) {
			if (id == value.pollId) {
				if (principal == value.principal) return true;
			};
		};
		false;
	};

	func _getPollAnswersYesNo(id : Nat) : (Nat, Nat) {
		var yesCount = 0;
		var noCount = 0;

		label l for ((key, value) in answerStore.entries()) {
			if (id != value.pollId) continue l;
			switch (value.answer) {
				case (#YesNo(b)) {
					if (b) { yesCount += 1 } else { noCount += 1 };
				};
				case (#MultiChoice(t)) {}; //should never be the case
			};
		};

		(yesCount, noCount);
	};

	// DATA STORAGE
	stable var pollIdCount : Nat = 0;
	stable var answerIdCount : Nat = 0; //temp

	stable var stableUsers : [(Principal, UserProfile)] = [];
	let userStore = HashMap.fromIter<Principal, UserProfile>(Iter.fromArray(stableUsers), 4, Principal.equal, Principal.hash);

	stable var stablePolls : [(Nat, Poll)] = [];
	let pollStore = HashMap.fromIter<Nat, Poll>(Iter.fromArray(stablePolls), 4, Nat.equal, Util.hashNat);

	stable var stableAnswers : [(Nat, Answer)] = [];
	let answerStore = HashMap.fromIter<Nat, Answer>(Iter.fromArray(stableAnswers), 8, Nat.equal, Util.hashNat);

	// Upgrade canister
	system func preupgrade() {
		stableUsers := Iter.toArray(userStore.entries());
		stablePolls := Iter.toArray(pollStore.entries());
		stableAnswers := Iter.toArray(answerStore.entries());
	};

	system func postupgrade() {
		stableUsers := [];
		stablePolls := [];
		stableAnswers := [];
	};

	// USER/PROFILE REGISTER
	public query ({ caller }) func whoami() : async Principal {
		caller;
	};

	public shared ({ caller }) func createUser(username : Text) : async Result.Result<(), Text> {
		let null = userStore.get(caller) else return #err(genericErr.alreadyRegistered);

		let userProfile : UserProfile = {
			created = Time.now();
			username;
			contact = " ";
			about = " ";
			img = "";
		};

		userStore.put(caller, userProfile);
		#ok();
	};

	public shared query ({ caller }) func getUser() : async Result.Result<UserProfile, Text> {
		let ?user = userStore.get(caller) else return #err(genericErr.notRegistered);
		#ok(user);
	};

	public shared ({ caller }) func updateProfile(profile : Profile) : async Result.Result<(), Text> {
		let ?user = userStore.get(caller) else return #err(genericErr.notRegistered);

		let userProfile : UserProfile = {
			created = user.created;
			username = profile.username;
			contact = profile.contact;
			about = profile.about;
			img = profile.img;
		};

		let ?_ = userStore.replace(caller, userProfile) else return #err("Could not update profile");
		#ok();
	};

	//POLLS

	public shared ({ caller }) func createPoll(question : Text) : async Result.Result<Nat, Text> {
		let ?user = userStore.get(caller) else return #err(genericErr.notRegistered);
		let true = (question.size() >= 8) else return #err("Your question is too short!");

		let newPoll : Poll = {
			id = pollIdCount;
			questionType : QuestionType = #YesNo;
			question = question;
			creator = caller;
			created = Time.now();
			voteCount = 0;
		};
		pollStore.put(pollIdCount, newPoll);
		//increment pollId for next poll
		pollIdCount += 1;
		//returns pollId that was used to create current Poll
		#ok(pollIdCount - 1);
	};

	public shared query func getPoll(pollId : Nat) : async Result.Result<Poll, Text> {
		let ?poll = pollStore.get(pollId) else return #err(genericErr.getPoll # Nat.toText(pollId));

		#ok poll;
	};

	public shared ({ caller }) func deletePoll(pollId : Nat) : async Result.Result<(), Text> {
		let ?poll = pollStore.get(pollId) else return #err(genericErr.getPoll # Nat.toText(pollId));
		let true = (poll.creator == caller) else return #err(genericErr.verifyCreator);

		pollStore.delete(pollId);

		#ok;
	};

	public shared ({ caller }) func answerPoll(pollId : Nat, answerBool : Bool) : async Result.Result<(), Text> {
		let ?user = userStore.get(caller) else return #err(genericErr.notRegistered);
		let ?poll = pollStore.get(pollId) else return #err(genericErr.getPoll # Nat.toText(pollId));
		if (true == _checkIfVoted(caller, pollId)) return #err(genericErr.alreadyAnswered # Nat.toText(pollId));

		let newAnswer : Answer = {
			pollId = pollId;
			principal = caller;
			answer = #YesNo(answerBool);
		};
		//I know , there are better ways to do this, ( like having mutable voteCount and changing mute state before put in hashmap, or use of classes maybe)
		var updatedPoll : Poll = {
			id = poll.id;
			questionType = poll.questionType;
			question = poll.question;
			creator = poll.creator;
			created = poll.created;
			voteCount = poll.voteCount + 1;
		};

		try {
			let ?res = pollStore.replace(updatedPoll.id, updatedPoll) else return #err(genericErr.getPoll);
			answerStore.put(answerIdCount, newAnswer);
			answerIdCount += 1;
		} catch error {
			return #err(genericErr.getPoll # Error.message(error));
		};

		#ok;
	};

	public shared query ({ caller }) func getAllPollsWithYesNoAnswers() : async Result.Result<([(PollWithYesNoStats, Bool)]), Text> {
		//no time to get propper types
		let buf = Buffer.Buffer<(PollWithYesNoStats, Bool)>(8);
		try {
			let polls = _getAllPolls();

			for (poll in Iter.fromArray(polls)) {
				let answerScore : (Nat, Nat) = _getPollAnswersYesNo(poll.id);
				let answerAlready : Bool = _checkIfVoted(caller, poll.id);
				let pollWStats = { poll; yesNoStats = answerScore };
				buf.add(pollWStats, answerAlready);
			};
		} catch (err) {
			return #err(genericErr.noPollFetch);
		};

		#ok(Buffer.toArray(buf));
	};

	//TEST FUNCTIONS
	public shared query func getAllPolls() : async [Poll] {
		_getAllPolls();
	};

	public shared query func getAllAnswers() : async [Answer] {
		_getAllAnswers();
	};

	public shared query func getPollAnswerScore(id : Nat) : async (Nat, Nat) {
		_getPollAnswersYesNo(id);
	};

};
