import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

module Utils {
    public func hashNat(id : Nat) : Hash.Hash {
        Text.hash(Nat.toText(id));
    };

    //for future storage improvements, make more generalized
	// func hashPoll(created : Int, creater : Principal, question : Text) : Hash.Hash {
	// 	let t1 = Int.toText(created);
	// 	let t2 = Principal.toText(creater);
	// 	let t3 = question;
	// 	Text.hash(t1 # t2 # t3);
	// };
	// func hashPrincipalPollHash(p : Principal, pollHash : Hash.Hash) : Hash.Hash {
	// 	let t1 = Principal.toText(p);
	// 	let t2 = Nat32.toText(pollHash);
	// 	Text.hash(t1 # t2);
	// };

};