import Binary "mo:encoding/Binary";
import Buffer "mo:base-0.7.3/Buffer";
import Int "mo:base-0.7.3/Int";
import IO "mo:io/IO";
import Iter "mo:base-0.7.3/Iter";
import Nat64 "mo:base-0.7.3/Nat64";
import Time "mo:base-0.7.3/Time";

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
            state *% 2685821657736338717;
        };
    };

    public func toIter(gen : XorShift) : Iter.Iter<Nat64> = object {
        let xors = gen;
        public func next() : ?Nat64 {
            ?xors.next();
        };
    };

    public func toReader(gen : XorShift) : IO.Reader<Nat8> = object {
        let xors = gen;
        let bs = Buffer.Buffer<Nat8>(8);
        public func read(n : Nat) : IO.Result<[Nat8]> {
            let ts = Buffer.Buffer<Nat8>(n);
            for (_ in Iter.range(0, n-1)) {
                if (bs.size() == 0) {
                    for (b in Binary.BigEndian.fromNat64(gen.next()).vals()) {
                        bs.add(b);
                    };
                };
                switch (bs.removeLast()) {
                    case (? v) {
                        ts.add(v);
                    };
                    case (null) return #eof(Buffer.toArray(ts));
                };
            };
            #ok(Buffer.toArray(ts));
        };
    };
};
