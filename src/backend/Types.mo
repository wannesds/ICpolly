import Blob "mo:base/Blob";
module Types {
	//user should NOT be able to change this
	public type User = {
		created : Int;
	};

	//user should be able to change this
	public type Profile = {
		username : Text;
		contact : Text;
		about : Text;
		img : Blob;
	};

	public type UserProfile = User and Profile;

	public type QuestionType = {
		#YesNo;
		#MultiChoice : [Text];
	};

	public type AnswerType = {
		#YesNo : Bool;
		#MultiChoice : Text;
	};

	public type Poll = {
		//TODO add optional image
		id : Nat;
		questionType : QuestionType;
		question : Text;
		creator : Principal;
		created : Int;
		voteCount : Nat;
		fund : Nat;
	};

	public type Answer = {
		pollId : Nat;
		//user principal could maybe be removed when hashing princ+Nat for answerStore Key
		principal : Principal; //dont need use type there as user might have more fields in future
		answer : AnswerType;
	};

	public type PollWithYesNoStats = {
		poll : Poll;
		yesNoStats : (Nat, Nat);
	};

	public type BugReport = {
		creator : Principal;
		message : Text;
		img : Blob;
	};
};
