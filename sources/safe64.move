/// A gas-efficient library to prevent overflow when performing u64 operations
/// Routes all operations through u128
module safe64::safe64 {
    use std::error;

    /// Casting back to u64 failed
    const ECASTING_OVERFLOW: u64 = 1;

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
        let ret = (x as u128) * (y as u128) / (z as u128);

        assert!(ret <= 18446744073709551615, error::out_of_range(ECASTING_OVERFLOW));
        (ret as u64)
    }

    /// Multiply and divide 2
    public fun muldiv2(a: u64, b: u64, c: u64, d: u64): u128 {
         (a as u128) * (b as u128) / ((c as u128) * (d as u128))
    }

    /// Multiply and divide 2
    public fun muldiv2_64(a: u64, b: u64, c: u64, d: u64): u64 {
        let ret = (a as u128) * (b as u128) / ((c as u128) * (d as u128));

        assert!(ret <= 18446744073709551615, error::out_of_range(ECASTING_OVERFLOW));
        (ret as u64)
    }

    /// Multiply 3
    public fun mul3(x: u64, y: u64, z: u64): u128 {
        (x as u128) * (y as u128) * (z as u128)
    }

    /// Multiply 3 and divide
    public fun mul3div(a: u64, b: u64, c: u64, d: u64): u128 {
        ((a as u128) * (b as u128) * (c as u128)) / (d as u128)
    }

    /// Multiply 3, divide and cast
    /// For 3 we cast to 256 since MAX_U64^3 overflows u128
    public fun mul3div_64(a: u64, b: u64, c: u64, d: u64): u64 {
        let ret: u128 = ((a as u128) * (b as u128) * (c as u128)) / (d as u128);

        assert!(ret <= 18446744073709551615, error::out_of_range(ECASTING_OVERFLOW));
        (ret as u64)
    }

    /// Multiply 3, divide 2
    public fun mul3div2(a: u64, b: u64, c: u64, d: u64, e: u64): u128 {
        ((a as u128) * (b as u128) * (c as u128)) / ((d as u128) * (e as u128))
    }

    /// Multiply 3, divide 2 and cast
    public fun mul3div2_64(a: u64, b: u64, c: u64, d: u64, e: u64): u64 {
        let ret = ((a as u128) * (b as u128) * (c as u128)) / ((d as u128) * (e as u128));

        assert!(ret <= 18446744073709551615, error::out_of_range(ECASTING_OVERFLOW));
        (ret as u64)
    }

    /// Multiply 3, divide 3
    public fun mul3div3(a: u64, b: u64, c: u64, d: u64, e: u64, f: u64): u128 {
        ((a as u128) * (b as u128) * (c as u128)) / ((d as u128) * (e as u128) * (f as u128))
    }

    /// Multiply 3, divide 3 and cast
    public fun mul3div3_64(a: u64, b: u64, c: u64, d: u64, e: u64, f: u64): u64 {
        let ret = ((a as u128) * (b as u128) * (c as u128)) / ((d as u128) * (e as u128) * (f as u128));

        assert!(ret <= 18446744073709551615, error::out_of_range(ECASTING_OVERFLOW));
        (ret as u64)
    }

    public fun square(x: u64): u128 {
        (x as u128) * (x as u128)
    }

    ////////////////////////////////////////////////////////////
    //                        TESTING                         //
    ////////////////////////////////////////////////////////////

    #[test_only]
    const MAX_U64: u128 = 18446744073709551615;

    #[test_only]
    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    #[test]
    fun test_muldiv_64() {
        let big = ((MAX_U64) as u64);
        assert!(square(big) > MAX_U64, 1);
        
        let x = muldiv_64(big, big, big);
        assert!(x == big, 1);
    }

    #[test]
    fun test_mul3div_64() {
        let big = (((MAX_U64) / 10) as u64);
        assert!(square(big) > MAX_U64, 1);

        let x = mul3div_64(big, big, 10, big);
        assert!(x == 10 * big, 1);
    }

    #[test]
    fun test_mul3div2_64() {
        let big: u64 = (MAX_U64 as u64);
        assert!(square(big) > MAX_U64, 1);

        let x = mul3div2_64(big, 250, 2_000_000, 500, big);
        assert!(x == 1_000_000, 1);
    }
}