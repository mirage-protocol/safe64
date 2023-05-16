# Safe64

A pure move library allowing for safe multiplication and division of multiple `u64` values.

Many situations require multiplying and dividing many `u64` values, e.g. coin balances. But multiplying many large `u64` values can easily overflow, so checks are necessary when performing large mathematical operations. This library routes through either `u128` or `u256` to prevent the overflow.

## Functions

```rust
// all arguments are u64
mul(x, y): u128
muldiv_64(x, y, z): u64
muldiv(x, y, z): u128
muldiv2(a, b, c, d): u128
muldiv2_64(a, b, c, d): u64
mul3div2_64(a, b, c, d, e): u64
mul3(x, y, z): u256
mul3div(a, b, c, d): u256
mul3div_64(a, b, c, d): u64
mul3div2(a, b, c, d, e): u256
mul3div2_64(a, b, c, d, e): u64
mul3div3(a, b, c, d, e, f): u256
mul3div3_64(a, b, c, d, e, f): u64
square(x): u128
```

`mulXdivY` will multiply `X` values and divide `Y` values:

## How to Use

Add to `Move.toml`:

```toml
[dependencies.Safe64]
git = "https://github.com/mirage-protocol/safe64.git"
rev = "main"
```

And then use in code:

```rust
use safe64::safe64;

fun multiply_big_u64() {
    // Note: big_u64 * big_u64 > MAX_U64
    let big_u64: u64 = 18446744073709551615; // MAX_U64

    // safely multiply and divide many "big" u64 values
    let a: u64 = safe64::muldiv_64(big_u64, big_u64, big_u64);
    let b: u64 = safe64::mul3div2_64(
        big_u64,
        big_u64,
        1000,
        big_u64,
        big_u64
    );

    // and we get the expected result in u64
    assert!(a == big_u64, 1);
    assert!(b == 1000, 1);
}
```

## License

MIT
