import Hash "mo:base-0.7.3/Hash";
import Iter "mo:base-0.7.3/Iter";
import Nat "mo:base-0.7.3/Nat";
import Nat8 "mo:base-0.7.3/Nat8";
import Nat16 "mo:base-0.7.3/Nat16";
import Nat32 "mo:base-0.7.3/Nat32";
import TrieSet "mo:base-0.7.3/TrieSet";

import IO "mo:io/IO";

import LFSR "../src/LFSR";

do {
    let feed = LFSR.LFSR8(null);
    var s = TrieSet.empty<Nat32>();
    var i         = 0;
    var restarted = false;
    while (not restarted) {
        i += 1;
        let (v, r) = feed.next();
        let n = Nat32.fromNat(Nat8.toNat(v));
        if (TrieSet.mem<Nat32>(s, n, n, Nat32.equal)) {
            assert(false);
        };
        s := TrieSet.put(s, n, n, Nat32.equal);
        restarted := r;
    };
    if (i != 0xFF) assert(false);

    assert(Iter.size(LFSR.toIter(feed)) == 0xFF);
    switch (IO.readAll(LFSR.toReader(feed))) {
        case (#ok(bs)) assert(bs.size() == 0xFF);
        case (_)       assert(false);
    };
};
