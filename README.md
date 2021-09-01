# Pseudo Random Number Generators

## LFSR (linear feedback shift register)

Generates up to `1-2^n` unique numbers.

- LFSR8: 8-bit LFSR with a period of 255.

### Usage

```motoko
let feed = LFSR.LFSR8(0);
let (v, _) = feed.next();

// Iter
let iter = LFSR.toIter(feed);
```
