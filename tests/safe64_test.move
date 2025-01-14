#[test_only]
module safe64::safe64_test {
    use safe64::safe64;
    use safe64::safe64rounding;

    const MAX_U64: u64 = 18446744073709551615;

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

    // Basic rounding tests
    #[test]
    fun test_basic_rounding() {
        // 89054/10000 = 8.9054 
        let x = safe64rounding::muldiv(1, 89054, 10000, false);
        assert!(x == 8, 0);

        let y = safe64rounding::muldiv(1, 89054, 10000, true);
        assert!(y == 9, 1);

        // 99999/10000 = 9.9999
        let z1 = safe64rounding::muldiv(1, 99999, 10000, false);
        assert!(z1 == 9, 2);

        let z2 = safe64rounding::muldiv(1, 99999, 10000, true);
        assert!(z2 == 10, 3);
    }

    // Edge cases for rounding
    #[test]
    fun test_rounding_edge_cases() {
        // Test exact division (10000/100 = 100)
        let x1 = safe64rounding::muldiv(100, 100, 1, false);
        let x2 = safe64rounding::muldiv(100, 100, 1, true);
        assert!(x1 == 10000, 0);
        assert!(x2 == 10000, 1);
        assert!(x1 == x2, 2);

        // Test with small remainder (1001/1000 = 1.001)
        let y1 = safe64rounding::muldiv(1001, 1, 1000, false);
        let y2 = safe64rounding::muldiv(1001, 1, 1000, true);
        assert!(y1 == 1, 3);
        assert!(y2 == 2, 4);
    }

    // Test mul3div variations
    #[test]
    fun test_mul3div_rounding() {
        // Test case: (101 * 101 * 99) / 10000 = 100.9899
        let x1 = safe64rounding::mul3div(101, 101, 99, 10000, false);
        let x2 = safe64rounding::mul3div(101, 101, 99, 10000, true);
        assert!(x1 == 100, 0);
        assert!(x2 == 101, 1);
    }

    // Test mul3div2 variations
    #[test]
    fun test_mul3div2_rounding() {
        // Test case: (101 * 101 * 99) / (100 * 100) = 100.9899
        let x1 = safe64rounding::mul3div2(101, 101, 99, 100, 100, false);
        let x2 = safe64rounding::mul3div2(101, 101, 99, 100, 100, true);
        assert!(x1 == 100, 0);
        assert!(x2 == 101, 1);
    }

    // Test mul3div3 variations
    #[test]
    fun test_mul3div3_rounding() {
        // Test case: (101 * 101 * 101) / (100 * 100 * 100) = 1.030301
        let x1 = safe64rounding::mul3div3(101, 101, 101, 100, 100, 100, false);
        let x2 = safe64rounding::mul3div3(101, 101, 101, 100, 100, 100, true);
        assert!(x1 == 1, 0);
        assert!(x2 == 2, 1);
    }

    // Test consistency between rounding and non-rounding versions
    #[test]
    fun test_rounding_consistency() {
        // Test with values that divide evenly
        let a = 1000;
        let b = 2000;
        let c = 50;

        // muldiv consistency
        let x1 = (safe64::muldiv(a, b, c) as u64);
        let x2 = safe64rounding::muldiv(a, b, c, false);
        assert!(x1 == x2, 0);

        // muldiv2 consistency
        let y1 = safe64::muldiv2_64(a, b, c, 2);
        let y2 = safe64rounding::muldiv2(a, b, c, 2, false);
        assert!(y1 == y2, 1);

        // mul3div consistency
        let z1 = safe64::mul3div_64(a, b, c, 5);
        let z2 = safe64rounding::mul3div(a, b, c, 5, false);
        assert!(z1 == z2, 2);
    }
}