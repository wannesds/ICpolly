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
import Debug "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import LT "PollyLedger/Types";
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
	public type BugReport = T.BugReport;

	public type LTResult<T, E> = { #Ok : T; #Err : E };

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

	//also checked out NatLab, pretty cool stuff, will use that in the future, for now basic vanilla icrc1
	//came to the conclusion that Id be better of making in an app token icrc integration
	// let pollyLedger = actor ("q3fc5-haaaa-aaaaa-aaahq-cai") : actor {
	// 	icrc1_name : shared () -> async Text;
	// 	icrc1_symbol : shared query () -> async Text;
	// 	icrc1_decimals : shared query () -> async Nat8;
	// 	icrc1_fee : shared query () -> async Nat;
	// 	icrc1_metadata : shared query () -> async [(Text, LT.Value)];
	// 	icrc1_total_supply : shared query () -> async LT.Tokens;
	// 	icrc1_minting_account : shared query () -> async ?LT.Account;
	// 	icrc1_balance_of : shared query (account : LT.Account) -> async LT.Tokens;
	// 	icrc1_supported_standards : shared query () -> async [{ name : Text; url : Text }];
	// 	icrc1_transfer : shared (args : LT.TransferArgs) -> async LTResult<LT.TxIndex, LT.TransferError>;
	// 	icrc1_transfer_from : shared (args : LT.TransferArgsFrom) -> async LTResult<LT.TxIndex, LT.TransferError>;

	// };

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

	func _getAllBugReports() : [BugReport] {
		let buf = Buffer.Buffer<BugReport>(8);

		for ((key, value) in bugReportStore.entries()) {
			buf.add(value);
		};

		Buffer.toArray(buf);
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

	stable var stableBugReports : [(Nat, BugReport)] = [];
	let bugReportStore = HashMap.fromIter<Nat, BugReport>(Iter.fromArray(stableBugReports), 4, Nat.equal, Util.hashNat);

	// Upgrade canister
	system func preupgrade() {
		stableUsers := Iter.toArray(userStore.entries());
		stablePolls := Iter.toArray(pollStore.entries());
		stableAnswers := Iter.toArray(answerStore.entries());
		stableBugReports := Iter.toArray(bugReportStore.entries());
	};

	system func postupgrade() {
		stableUsers := [];
		stablePolls := [];
		stableAnswers := [];
		stableBugReports := [];
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
		// let args : LT.TransferArgs = {
		// 	from_subaccount = null;
		// 	to = { owner = caller; subaccount = null };
		// 	memo = null;
		// 	created_at_time = null;
		// 	amount : LT.Tokens = 10_000_000;
		// 	fee = null;
		// };
		// try {
		// 	let txnRes = await pollyLedger.icrc1_transfer(args);
		// 	Debug.print(debug_show ("Txn result on creation +10 :", txnRes));
		// } catch (_) {
		// 	Debug.print(debug_show ("Txn failed"));
		// };
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
			fund = 0; //temp null , should also be added as input
		};
		// let args : LT.TransferArgs = {
		// 	from_subaccount = null;
		// 	to = { owner = caller; subaccount = null; };
		// 	memo = null;
		// 	created_at_time = null;
		// 	amount : LT.Tokens = 10_000_000;
		// 	fee = null;
		// };

		// let txnRes = await pollyLedger.icrc1_transfer(args);

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
			fund = poll.fund;
		};

		try {
			let ?res = pollStore.replace(updatedPoll.id, updatedPoll) else return #err(genericErr.getPoll);
			answerStore.put(answerIdCount, newAnswer);
			answerIdCount += 1;
			//
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

	public shared ({ caller }) func createBugReport(message : Text, img : Blob) : async Result.Result<Nat, Text> {
		let ?user = userStore.get(caller) else return #err(genericErr.notRegistered);

		let newBugReport : BugReport = {
			creator = caller;
			img = img;
			message = message;
		};

		bugReportStore.put(bugReportStore.size(), newBugReport);

		#ok(bugReportStore.size());
	};

	public shared query func getAllBugReports() : async [BugReport] {
		_getAllBugReports();
	};

	//LEDGER
	// public shared query func getPollyMetadata() : async [(Text, LT.Value)] {
	// 	let x = await pollyLedger.icrc1_metadata;
	// 	x;
	// };

	//SPECIAL
	// Deposit cycles into this archive canister.
	public shared func depositCycles() : async () {
		let amount = ExperimentalCycles.available();
		let accepted = ExperimentalCycles.accept(amount);
		assert (accepted == amount);
	};

	//TEMP FUNCTION //converted in one for ledger
	// public shared ({ caller }) func airdropStudents() : async Bool {
	// 	let ?acc = await pollyLedger.icrc1_minting_account() else return false;

	// 	let bootcamp = actor("rww3b-zqaaa-aaaam-abioa-cai") : actor {
	// 		getAllStudentsPrincipal : shared () -> async [Principal];
	// 	};

	// 	try {
	// 		let students : [Principal] = await bootcamp.getAllStudentsPrincipal();
	// 		for (principal in students.vals()) {
	// 			let args : LT.TransferArgs = {
	// 				from_subaccount = null;
	// 				to = { owner = principal; subaccount = null; };
	// 				memo = null;
	// 				created_at_time = null;
	// 				amount = 10_000_000;
	// 				fee = null;
	// 			};
	// 			if (caller == acc.owner) else {
	// 				ignore await pollyLedger.icrc1_transfer(args);
	// 			}
	// 			//ignoring and not getting result type bcs of 300+ iterations,
	// 		};
	// 	} catch (e) {
	// 		return false
	// 	};
	// 	//change function to some alrdy build in error, transaction or mint result?
	// 	true
	// };

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
