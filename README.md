# SafeU64

A pure move library allowing for safe multiplication and division of multiple `u64` values without overflow.

In many situations we want to multiply and divide many `u64` values, e.g. coin balances. But multiplying many large `u64` values can easily overflow, so checks are necessary when performing large mathematical operations.

## Features

```rust
muldiv(x, y, z): u256 -> xy / z
muldiv_64(x, y, x): u64 -> xy / z
```

`mulXdivY` will multiply `X` values and divide `Y` values:

```rust
mul3div2_64(a, b, c, d, e): u64 -> abc / de
```

## How to Use

Add to `Move.toml`:

```toml
[dependencies.SafeU64]
git = "https://github.com/mirage-protocol/safe_u64.git"
rev = "main"
```

And then use in code:

```rust
use safe_u64::safe_u64;

...

// big_u64 * big_u64 > MAX_U64
let big_u64: u64 = ... ;

// safely multiply and divide many "big" u64 values
let a: u64 = safe_u64::muldiv_64(big_u64, big_u64, big_u64);
let b: u64 = safe_u64::mul3div2_64(
    big_u64,
    big_u64,
    1000,
    big_u64,
    100000
)
```

## License

MIT
