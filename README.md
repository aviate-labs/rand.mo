# Pseudo Random Number Generators

## LFSR (linear feedback shift register)

### Types of LFSR

#### 8-bit

```text
X^8 + X^6 + X^5 + X^4 + 1
-> 2^8 -1 = 255
```

#### 16-bit

```text
X^16 + X^14 + X^13 + X^11 + 1
-> 2^16 - 1 = 65_535
```

#### 32-bit

```text
X^32+ X^22 + X^2 + X^1 + 1
-> 2^32 - 1
```

### Usage

```motoko
let feed = LFSR.LFSR8(0);
let (v, _) = feed.next();

// Iter
let iter = LFSR.toIter(feed);
```
## XorShift

Reference: [prng](https://vigna.di.unimi.it/ftp/papers/xorshift.pdf).
