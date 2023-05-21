#[test_only]
module safe64::safe64_test {
    use safe64::safe64;

    const MAX_U64: u64 = 18446744073709551615;

    #[test]
    fun test_muldiv_64() {
        let big = MAX_U64;
        assert!(safe64::square(big) > (MAX_U64 as u128), 1);
        
        let x = safe64::muldiv_64(big, big, big);
        assert!(x == big, 1);
    }

    #[test]
    #[expected_failure(arithmetic_error, location = Self)]
    fun test_muldiv_64_overflow() {
        let big = MAX_U64;

        safe64::muldiv_64(big, big, 1);
    }

    #[test]
    fun test_muldiv2_64() {
        let big = MAX_U64;
        
        let x = safe64::muldiv2_64(big, big, big, 10);
        assert!(x == big / 10, 1);
    }

    #[test]
    fun test_mul3div_64() {
        let big = MAX_U64 / 10;

        let x = safe64::mul3div_64(big, big, 10, big);
        assert!(x == 10 * big, 1);
    }

    #[test]
    fun test_mul3div2_64() {
        let big = MAX_U64;

        let x = safe64::mul3div2_64(big, 250, 2_000_000, 500, big);
        assert!(x == 1_000_000, 1);
    }
}
