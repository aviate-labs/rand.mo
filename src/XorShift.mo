import Int "mo:base/Int";
import IO "mo:io/IO";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";

module {
    public type XorShift = {
        next() : Nat64;
    };

    public class XorShift64(
        s : ?Nat64,
    ) : XorShift {
        private let seed : Nat64 = switch (s) {
            case (null) Nat64.fromNat(Int.abs(Time.now()));
            case (? s)  s;
        };
        var state = seed;

        public func next() : Nat64 {
            state ^= (state >> 12);
            state ^= (state << 25);
            state ^= (state >> 27);
            state * 2685821657736338717;
        };
    };
};
