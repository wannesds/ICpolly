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
import Cycles "mo:base/ExperimentalCycles";

actor {
	//TYPES INDEX
	//TEMP: better to have seperate types module and declare here

	//user should NOT be able to change this
	public type User = {
		created : Int;
	};

	//user should be able to change this
	public type Profile = {
		username : Text;
		contact : Text;
		about : Text;
	};

	public type UserProfile = User and Profile;

	//CONSTANTS

	// UTILITY FUNCTIONS

	//TEMP: (use these for other stable stores for making unique hash keys)
	//TEMP: unused shown as example
	func hashQuestion(created : Int, creater : Principal, question : Text) : Hash.Hash {
		let t1 = Int.toText(created);
		let t2 = Principal.toText(creater);
		let t3 = question;
		Text.hash(t1 # t2 # t3);
	};
	func hashPrincipalQuestion(p : Principal, questionHash : Hash.Hash) : Hash.Hash {
		let t1 = Principal.toText(p);
		let t2 = Nat32.toText(questionHash);
		Text.hash(t1 # t2);
	};

	//TEMP : is not needed if possible to 'concat' records, but makes things clear
	func _buildUserProfile(user : User, profile : Profile) : UserProfile {
		return {
			created = user.created;
			username = profile.username;
			contact = profile.contact;
			about = profile.about;
		};
	};

	// DATA STORAGE
	stable var stableUsers : [(Principal, UserProfile)] = [];
	let users = HashMap.fromIter<Principal, UserProfile>(Iter.fromArray(stableUsers), 4, Principal.equal, Principal.hash);

	// Upgrade canister
	system func preupgrade() {
		stableUsers := Iter.toArray(users.entries());
	};

	system func postupgrade() {
		stableUsers := [];
	};

	// PUBLIC API
	public query ({ caller }) func whoami() : async Principal {
		caller;
	};

	public shared ({ caller }) func createUser(username : Text) : async Result.Result<(), Text> {
		let null = users.get(caller) else return #err("User is already registered!");

		let user : User = {
			created = Time.now();
		};
		let profile : Profile = {
			username;
			contact = "";
			about = "";
		};
		let userProfile : UserProfile = _buildUserProfile(user, profile);

		users.put(caller, userProfile);
		#ok();
	};

	//
	public shared query ({ caller }) func getUser() : async Result.Result<UserProfile, Text> {
		let ?user = users.get(caller) else return #err("User does not exist!");
		#ok(user);
	};

	public shared ({ caller }) func updateProfile(profile : Profile) : async Result.Result<(), Text> {
		let ?user = users.get(caller) else return #err("User does not exist!");

		let userProfile : UserProfile = _buildUserProfile(user, profile);

		users.put(caller, userProfile);
		#ok();
	};

};
