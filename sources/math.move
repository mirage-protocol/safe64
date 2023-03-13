/// A library to prevent overflow when multiplying lots of u64 values
module safe_u64::math {
    #[test_only]
    const MAX_U64: u256 = 18446744073709551615;

    #[test_only]
    const MAX_U128: u256 = 340282366920938463463374607431768211455;

    const EOVERFLOW: u64 = 64007;

    // mulXdivY will multiply x values divided by y values
    // mulXdivY_64 will attempt to cast the value back to u64

    public fun to256(x: u64): u256 {
        (x as u256)
    }

    public fun to64(x: u256): u64 {
        assert!(x < 18446744073709551615, EOVERFLOW); // MAX_U64
        (x as u64)
    }

    public fun mul(x: u64, y: u64): u256 {
        (x as u256) * (y as u256)
    }

    public fun div(x: u64, y: u64): u256 {
        (x as u256) / (y as u256)
    }

    public fun muldiv(x: u64, y: u64, z: u64): u256 {
        mul(x, y) / (z as u256)
    }

    public fun muldiv_64(x: u64, y: u64, z: u64): u64 {
        to64(muldiv(x, y, z))
    }

    public fun mul3(x: u64, y: u64, z: u64): u256 {
        mul(x, y) * (z as u256)
    }

    public fun mul3div(a: u64, b: u64, c: u64, d: u64): u256 {
        mul3(a, b, c) / to256(d)
    }

    public fun mul3div_64(a: u64, b: u64, c: u64, d: u64): u64 {
        to64(mul3div(a, b, c, d))
    }

    public fun mul3div2(a: u64, b: u64, c: u64, d: u64, e: u64): u256 {
        mul3(a, b, c) / mul(d, e)
    }

    public fun mul3div2_64(a: u64, b: u64, c: u64, d: u64, e: u64): u64 {
        to64(mul3div2(a, b, c, d, e))
    }

    public fun square(x: u64): u256 {
        mul(x, x)
    }

    #[test]
    fun test_muldiv_64() {
        let big = ((MAX_U64 - 1) as u64);
        assert!(square(big) > MAX_U64, 1);
        
        let x = muldiv_64(big, big, big);
        assert!(x == big, 1);
    }

    #[test]
    fun test_mul3div_64() {
        let big = (((MAX_U64 - 1) / 10) as u64);
        assert!(square(big) > MAX_U64, 1);

        let x = mul3div_64(big, big, 10, big);
        assert!(x == 10 * big, 1);
    }

    #[test]
    fun test_mul3div2_64() {
        let big = ((MAX_U64 - 1) as u64);
        assert!(square(big) > MAX_U64, 1);

        let x = mul3div2_64(big, big, big, big, big);
        assert!(x == big, 1);
    }
}