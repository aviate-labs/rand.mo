import Iter "mo:base/Iter";

import IO "mo:io/IO";

import LFSR "../src/LFSR";

do {
    let feed = LFSR.LFSR8(null);

    var i         = 0;
    var restarted = false;
    while (not restarted) {
        i += 1;
        let (_, r) = feed.next();
        restarted := r;
    };
    if (i != 0xFF) assert(false);

    assert(Iter.size(LFSR.toIter(feed)) == 0xFF);
    let (bs, _) = IO.readAll(LFSR.toReader(feed));
    assert(bs.size() == 0xFF);
};
