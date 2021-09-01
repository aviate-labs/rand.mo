import Array "mo:base/Array";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";

import IO "mo:io/IO";

module {
    public type LFSR<T> = {
        next() : (T, Bool);
    };

    // An 8 bit linear feedback shift register.
    public class LFSR8(
        // Seed.
        s : ?Nat8,
    ) {
        private let seed : Nat8 = switch (s) {
            case (null) { nat8(Int.abs(Time.now())); };
            case (? s)  { s;                         };
        };
        private var state = seed;

        public func next() : (
            Nat8, // Next pseudo random number.
            Bool, // Whether the sequence was completed and is restarting.
        ) {
            let s = state;
            let b = (s >> 0) ^ (s >> 2) ^ (s >> 3) ^ (s >> 4);
            state := (s >> 1) | (b << 7);
            (state, state == seed);
        };
    };

    public func toIter<T>(feed : LFSR<T>) : Iter.Iter<T> = object {
        let lfsr = feed;
        var restarted = false;
        public func next() : ?T {
            if (restarted) return null;
            let (v, r) = lfsr.next();
            restarted := r;
            ?v;
        };
    };

    public func toReader<T>(feed : LFSR<T>) : IO.Reader<T> = object {
        let lfsr = feed;
        var restarted = false;
        public func read(n : Nat) : ([T], IO.Error) {
            var ts : [T] = [];
            for (i in Iter.range(0, n-1)) {
                if (restarted) return (ts, IO.EOF);
                let (v, r) = lfsr.next();
                restarted := r;
                ts := Array.append<T>(ts, [v]);
            };
            (ts, "");
        };
    };

    private func nat8(n : Nat) : Nat8 {
        Nat8.fromNat(Nat64.toNat(Nat64.fromNat(n) & 0xFF));
    };
};
