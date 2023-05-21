/// A gas-efficient library to prevent overflow when performing u64 operations
/// Routes all operations through u128 or u256
module safe64::safe64 {

    /// Multiply
    public fun mul(x: u64, y: u64): u128 {
        (x as u128) * (y as u128)
    }

    /// Multiply and divide
    public fun muldiv(x: u64, y: u64, z: u64): u128 {
         (x as u128) * (y as u128) / (z as u128)
    }

    /// Multiply, divide and cast
    public fun muldiv_64(x: u64, y: u64, z: u64): u64 {
        ((x as u128) * (y as u128) / (z as u128) as u64)
    }

    /// Multiply and divide 2
    public fun muldiv2(a: u64, b: u64, c: u64, d: u64): u128 {
         (a as u128) * (b as u128) / ((c as u128) * (d as u128))
    }

    /// Multiply and divide 2
    public fun muldiv2_64(a: u64, b: u64, c: u64, d: u64): u64 {
        ((a as u128) * (b as u128) / ((c as u128) * (d as u128)) as u64)
    }

    /// Multiply 3
    /// Cast through u256 since MAX_U64^3 overflows u128
    public fun mul3(x: u64, y: u64, z: u64): u256 {
        (x as u256) * (y as u256) * (z as u256)
    }

    /// Multiply 3 and divide
    public fun mul3div(a: u64, b: u64, c: u64, d: u64): u256 {
        ((a as u256) * (b as u256) * (c as u256)) / (d as u256)
    }

    /// Multiply 3, divide and cast
    /// For 3 we cast to u256 since MAX_U64^3 overflows u128
    public fun mul3div_64(a: u64, b: u64, c: u64, d: u64): u64 {
        (((a as u256) * (b as u256) * (c as u256)) / (d as u256) as u64)
    }

    /// Multiply 3, divide 2
    public fun mul3div2(a: u64, b: u64, c: u64, d: u64, e: u64): u256 {
        ((a as u256) * (b as u256) * (c as u256)) / ((d as u256) * (e as u256))
    }

    /// Multiply 3, divide 2 and cast
    public fun mul3div2_64(a: u64, b: u64, c: u64, d: u64, e: u64): u64 {
        (((a as u256) * (b as u256) * (c as u256)) / ((d as u256) * (e as u256)) as u64)
    }

    /// Multiply 3, divide 3
    public fun mul3div3(a: u64, b: u64, c: u64, d: u64, e: u64, f: u64): u256 {
        ((a as u256) * (b as u256) * (c as u256)) / ((d as u256) * (e as u256) * (f as u256))
    }

    /// Multiply 3, divide 3 and cast
    public fun mul3div3_64(a: u64, b: u64, c: u64, d: u64, e: u64, f: u64): u64 {
       (((a as u256) * (b as u256) * (c as u256)) / ((d as u256) * (e as u256) * (f as u256)) as u64)
    }

    /// Square a number
    public fun square(x: u64): u128 {
        (x as u128) * (x as u128)
    }
}
