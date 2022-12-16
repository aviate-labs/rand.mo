import Hash "mo:base-0.7.3/Hash";
import Nat "mo:base-0.7.3/Nat";
import Nat64 "mo:base-0.7.3/Nat64";
import Text "mo:base-0.7.3/Text";
import TrieSet "mo:base-0.7.3/TrieSet";

import XorShift "../src/XorShift";

import Debug "mo:base-0.7.3/Debug";

var r = XorShift.XorShift64(null);
var s = TrieSet.empty<Text>();
var i = 0;
while (i < 99) {
    let n = Nat64.toText(r.next());
    s := TrieSet.put<Text>(s, n, Text.hash(n), Text.equal);
    i += 1;
};
assert(TrieSet.size(s) == 99);
