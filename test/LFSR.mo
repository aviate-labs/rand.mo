import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import TrieSet "mo:base/TrieSet";

import IO "mo:io/IO";

import LFSR "../src/LFSR";

do {
    let feed = LFSR.LFSR8(null);
    var s = TrieSet.empty<Nat>();
    var i         = 0;
    var restarted = false;
    while (not restarted) {
        i += 1;
        let (v, r) = feed.next();
        let n = Nat8.toNat(v);
        if (TrieSet.mem<Nat>(s, n, Hash.hash(n), Nat.equal)) {
            assert(false);
        };
        s := TrieSet.put(s, n, Hash.hash(n), Nat.equal);
        restarted := r;
    };
    if (i != 0xFF) assert(false);

    assert(Iter.size(LFSR.toIter(feed)) == 0xFF);
    switch (IO.readAll(LFSR.toReader(feed))) {
        case (#ok(bs)) assert(bs.size() == 0xFF);
        case (_)       assert(false);
    };
};
