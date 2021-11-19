import Array "mo:base/Array";
import Int "mo:base/Int";
import IO "mo:io/IO";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";

module {
    public type LFSR<T> = {
        next() : (T, Bool);
    };

    // An 8-bit linear feedback shift register.
    public class LFSR8(
        s : ?Nat8, // Seed.
    ) : LFSR<Nat8> {
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
            // X^8 + X^6 + X^5 + X^4 + 1
            let b = (s >> 0) ^ (s >> 2) ^ (s >> 3) ^ (s >> 4) & 1;
            state := (s >> 1) | (b << 7);
            (state, state == seed);
        };
    };

    // An 16-bit linear feedback shift register.
    public class LFSR16(
        s : ?Nat16, // Seed.
    ) : LFSR<Nat16> {
        private let seed : Nat16 = switch (s) {
            case (null) { nat16(Int.abs(Time.now())); };
            case (? s)  { s;                          };
        };
        private var state = seed;

        public func next() : (
            Nat16, // Next pseudo random number.
            Bool,  // Whether the sequence was completed and is restarting.
        ) {
            let s = state;
            // X^16 + X^14 + X^13 + X^11 + 1
            let b = (s >> 0) ^ (s >> 2) ^ (s >> 3) ^ (s >> 5) & 1;
            state := (s >> 1) | (b << 15);
            (state, state == seed);
        };
    };

    // An 32-bit linear feedback shift register.
    public class LFSR32(
        s : ?Nat32, // Seed.
    ) : LFSR<Nat32> {
        private let seed : Nat32 = switch (s) {
            case (null) { nat32(Int.abs(Time.now())); };
            case (? s)  { s;                          };
        };
        private var state = seed;

        public func next() : (
            Nat32, // Next pseudo random number.
            Bool,  // Whether the sequence was completed and is restarting.
        ) {
            let s = state;
            // X^32+ X^22 + X^2 + X^1 + 1
            let b = (s >> 0) ^ (s >> 10) ^ (s >> 30) ^ (s >> 31) & 1;
            state := (s >> 1) | (b << 31);
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
        public func read(n : Nat) : IO.Result<[T]> {
            var ts : [T] = [];
            for (i in Iter.range(0, n-1)) {
                if (restarted) return #eof(ts);
                let (v, r) = lfsr.next();
                restarted := r;
                ts := Array.append<T>(ts, [v]);
            };
            #ok(ts);
        };
    };

    private func nat8(n : Nat) : Nat8 {
        Nat8.fromNat(Nat64.toNat(Nat64.fromNat(n) & 0xFF));
    };

    private func nat16(n : Nat) : Nat16 {
        Nat16.fromNat(Nat64.toNat(Nat64.fromNat(n) & 0xFFFF));
    };

    private func nat32(n : Nat) : Nat32 {
        Nat32.fromNat(Nat64.toNat(Nat64.fromNat(n) & 0xFFFFFFFF));
    };
};
