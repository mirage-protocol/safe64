/// copied and modified from https://github.com/pyth-network/pyth-crosschain/blob/main/target_chains/aptos/contracts/sources/i64.move
module safe64::signed64 {
    const ENEGATIVE_VALUE: u64 = 4501;
    const EPOSITIVE_VALUE: u64 = 4502;

    /// As Move does not support negative numbers natively, we use our own internal
    /// representation.
    ///
    /// To consume these values, first call `get_is_negative()` to determine if the Signed64
    /// represents a negative or positive value. Then call `get_magnitude_if_positive()` or
    /// `get_magnitude_if_negative()` to get the magnitude of the number in unsigned u64 format.
    /// This API forces consumers to handle positive and negative numbers safely.
    struct Signed64 has copy, drop, store {
        negative: bool,
        magnitude: u64,
    }

    public fun zero(): Signed64 {
        new(0, false)
    }

    public fun new(magnitude: u64, negative: bool): Signed64 {
        // Ensure we have a single zero representation: (0, false).
        // (0, true) is invalid.
        if (magnitude == 0) {
            negative = false;
        };

        Signed64 {
            magnitude: magnitude,
            negative: negative,
        }
    }

    // adds two Signed64s, returns a new one
    public fun add(a: Signed64, b: Signed64): Signed64 {
        if (a.negative && b.negative) {
            new(a.magnitude + b.magnitude, true)
        } else if (!a.negative && !b.negative) {
            new(a.magnitude + b.magnitude, false)
        } else {
            let (larger, smaller) = if (a.magnitude >= b.magnitude) {
                (a, b)
            } else {
                (b, a)
            };

            new(larger.magnitude - smaller.magnitude, larger.negative)
        }
    }

    // subs b from a, returns a new one
    public fun sub(a: Signed64, b: Signed64): Signed64 {
        b.negative = !b.negative;
        add(a, b)
    }

    public fun get_is_negative(i: &Signed64): bool {
        i.negative
    }

    public fun get_magnitude_if_positive(in: &Signed64): u64 {
        assert!(!in.negative, ENEGATIVE_VALUE);
        in.magnitude
    }

    public fun get_magnitude_if_negative(in: &Signed64): u64 {
        assert!(in.negative, EPOSITIVE_VALUE);
        in.magnitude
    }

    #[test]
    fun test_get_is_negative() {
        assert!(get_is_negative(&new(234, true)) == true, 1);
        assert!(get_is_negative(&new(767, false)) == false, 1);
    }

    #[test]
    fun test_get_magnitude_if_positive_positive() {
        assert!(get_magnitude_if_positive(&new(7686, false)) == 7686, 1);
    }

    #[test]
    #[expected_failure(abort_code = 4501, location = safe64::signed64)]
    fun test_get_magnitude_if_positive_negative() {
        assert!(get_magnitude_if_positive(&new(7686, true)) == 7686, 1);
    }

    #[test]
    fun test_get_magnitude_if_negative_negative() {
        assert!(get_magnitude_if_negative(&new(7686, true)) == 7686, 1);
    }

    #[test]
    #[expected_failure(abort_code = 4502, location = safe64::signed64)]
    fun test_get_magnitude_if_negative_positive() {
        assert!(get_magnitude_if_negative(&new(7686, false)) == 7686, 1);
    }

    #[test]
    fun test_add_both_positive() {
        let a = new(1, false);
        let b = new(3, false);
        let c = add(a, b);// 1 + 3 = 4
        assert!(get_magnitude_if_positive(&c) == 4, 1);
    }

    #[test]
    fun test_add_both_negative() {
        let a = new(1, true);
        let b = new(3, true);
        let c = add(a, b);// -1 + -3 = -4
        assert!(get_magnitude_if_negative(&c) == 4, 1);
    }

    #[test]
    fun test_add_mixed_result_positive() {
        let a = new(1, true);
        let b = new(3, false);
        let c = add(a, b); // -1 + 3 = 2
        assert!(get_magnitude_if_positive(&c) == 2, 1);
    }

    #[test]
    fun test_add_mixed_result_negative() {
        let a = new(3, true);
        let b = new(1, false);
        let c = add(a, b); // -3 + 1 = -2
        assert!(get_magnitude_if_negative(&c) == 2, 1);
    }    
    
    #[test]
    fun test_add_mixed_result_zero() {
        let a = new(2, true);
        let b = new(2, false);
        let c = add(a, b); // -2 + 2 = 0
        // 0 has negative flag set to false
        assert!(get_magnitude_if_positive(&c) == 0, 1);
    }

    #[test]
    fun test_sub_both_positive_result_negative() {
        let a = new(1, false);
        let b = new(3, false);
        let c = sub(a, b);// 1 - 3 = -2
        assert!(get_magnitude_if_negative(&c) == 2, 1);
    }

    #[test]
    fun test_sub_both_positive_result_positive() {
        let a = new(3, false);
        let b = new(1, false);
        let c = sub(a, b);// 3 - 1 = 2
        assert!(get_magnitude_if_positive(&c) == 2, 1);
    }

    #[test]
    fun test_sub_both_negative_result_positive() {
        let a = new(1, true);
        let b = new(3, true);
        let c = sub(a, b);// -1 - -3 = 2
        assert!(get_magnitude_if_positive(&c) == 2, 1);
    }

    #[test]
    fun test_sub_both_negative_result_negative() {
        let a = new(3, true);
        let b = new(1, true);
        let c = sub(a, b);// -3 - -1 = -2
        assert!(get_magnitude_if_negative(&c) == 2, 1);
    }

    #[test]
    fun test_sub_mixed_result_negative() {
        let a = new(1, true);
        let b = new(3, false);
        let c = sub(a, b); // -1 - 3 = -4
        assert!(get_magnitude_if_negative(&c) == 4, 1);
    }

    #[test]
    fun test_sub_mixed_result_positive() {
        let a = new(3, false);
        let b = new(5, true);
        let c = sub(a, b); // 3 - -5 = 8
        assert!(get_magnitude_if_positive(&c) == 8, 1);
    }    
    
    #[test]
    fun test_sub_positive_result_zero() {
        let a = new(2, false);
        let b = new(2, false);
        let c = sub(a, b); // 2 - 2 = 0
        // 0 has negative flag set to false
        assert!(get_magnitude_if_positive(&c) == 0, 1);
    }

    #[test]
    fun test_sub_negative_result_zero() {
        let a = new(2, true);
        let b = new(2, true);
        let c = sub(a, b); // -2 - -2 = 0
        // 0 has negative flag set to false
        assert!(get_magnitude_if_positive(&c) == 0, 1);
    }

}