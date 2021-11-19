import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import TrieSet "mo:base/TrieSet";

import XorShift "../src/XorShift";

import Debug "mo:base/Debug";

var r = XorShift.XorShift64(null);
var s = TrieSet.empty<Text>();
var i = 0;
while (i < 99) {
    let n = Nat64.toText(r.next());
    s := TrieSet.put<Text>(s, n, Text.hash(n), Text.equal);
    i += 1;
};
assert(TrieSet.size(s) == 99);
