# SafeU64

A pure move library allowing for safe multiplication and division of multiple `u64` values without overflow.

In many situations we want to multiply and divide many `u64` values, e.g. coin balances. But multiplying many large `u64` values can easily overflow, so checks are necessary when performing large mathematical operations.

## Features

```sol
muldiv(x, y, z): u256 -> xy / z
muldiv_64(x, y, x): u64 -> xy / z
```

`mulXdivY` will multiply `X` values and divide `Y` values:

```sol
mul3div2_64(a, b, c, d, e): u64 -> abc / de
```

## License

MIT
