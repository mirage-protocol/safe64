/// copied and modified from https://github.com/pyth-network/pyth-crosschain/blob/main/target_chains/aptos/contracts/sources/i64.move
module safe64::i64 {

    const MAX_POSITIVE_MAGNITUDE: u64 = (1 << 63) - 1;
    const MAX_NEGATIVE_MAGNITUDE: u64 = (1 << 63);

    const EMAGNITUDE_TOO_LARGE: u64 = 4500;
    const ENEGATIVE_VALUE: u64 = 4501;
    const EPOSITIVE_VALUE: u64 = 4502;

    /// As Move does not support negative numbers natively, we use our own internal
    /// representation.
    ///
    /// To consume these values, first call `get_is_negative()` to determine if the I64
    /// represents a negative or positive value. Then call `get_magnitude_if_positive()` or
    /// `get_magnitude_if_negative()` to get the magnitude of the number in unsigned u64 format.
    /// This API forces consumers to handle positive and negative numbers safely.
    struct I64 has copy, drop, store {
        negative: bool,
        magnitude: u64,
    }

    public fun new(magnitude: u64, negative: bool): I64 {
        let max_magnitude = MAX_POSITIVE_MAGNITUDE;
        if (negative) {
            max_magnitude = MAX_NEGATIVE_MAGNITUDE;
        };
        assert!(magnitude <= max_magnitude, EMAGNITUDE_TOO_LARGE);


        // Ensure we have a single zero representation: (0, false).
        // (0, true) is invalid.
        if (magnitude == 0) {
            negative = false;
        };

        I64 {
            magnitude: magnitude,
            negative: negative,
        }
    }

    // adds two I64s, returns a new one
    public fun add(a: I64, b: I64): I64 {
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

            new(larger.magnitude - smaller.magnitude, larger.negative && !smaller.negative)
        }
    }

    public fun get_is_negative(i: &I64): bool {
        i.negative
    }

    public fun get_magnitude_if_positive(in: &I64): u64 {
        assert!(!in.negative, ENEGATIVE_VALUE);
        in.magnitude
    }

    public fun get_magnitude_if_negative(in: &I64): u64 {
        assert!(in.negative, EPOSITIVE_VALUE);
        in.magnitude
    }

    fun parse_magnitude(from: u64, negative: bool): u64 {
        // If positive, then return the input verbatamin
        if (!negative) {
            return from
        };

        // Otherwise convert from two's complement by inverting and adding 1
        let inverted = from ^ 0xFFFFFFFFFFFFFFFF;
        inverted + 1
    }

    #[test]
    #[expected_failure(abort_code = 4500, location = safe64::i64)]
    fun test_magnitude_too_large_positive() {
        new(0x8000000000000000, false);
    }

    #[test]
    #[expected_failure(abort_code = 4500, location = safe64::i64)]
    fun test_magnitude_too_large_negative() {
        new(0x8000000000000001, true);
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
    #[expected_failure(abort_code = 4501, location = safe64::i64)]
    fun test_get_magnitude_if_positive_negative() {
        assert!(get_magnitude_if_positive(&new(7686, true)) == 7686, 1);
    }

    #[test]
    fun test_get_magnitude_if_negative_negative() {
        assert!(get_magnitude_if_negative(&new(7686, true)) == 7686, 1);
    }

    #[test]
    #[expected_failure(abort_code = 4502, location = safe64::i64)]
    fun test_get_magnitude_if_negative_positive() {
        assert!(get_magnitude_if_negative(&new(7686, false)) == 7686, 1);
    }

    #[test]
    fun test_add_both_positive() {
        let a = new(1, false);
        let b = new(3, false);
        let c = add(a, b);// 1 + 3 = 4
        assert(get_magnitude_if_positive(&c) == 4, 1);
    }

    #[test]
    fun test_add_both_negative() {
        let a = new(1, true);
        let b = new(3, true);
        let c = add(a, b);// -1 + -3 = -4
        assert(get_magnitude_if_negative(&c) == 4, 1);
    }

    #[test]
    fun test_add_mixed_result_positive() {
        let a = new(1, true);
        let b = new(3, false);
        let c = add(a, b); // -1 + 3 = 2
        assert(get_magnitude_if_positive(&c) == 2, 1);
    }

    #[test]
    fun test_add_mixed_result_negative() {
        let a = new(3, true);
        let b = new(1, false);
        let c = add(a, b); // -3 + 1 = -2
        assert(get_magnitude_if_negative(&c) == 2, 1);
    }    
    
    #[test]
    fun test_add_mixed_result_zero() {
        let a = new(2, true);
        let b = new(2, false);
        let c = add(a, b); // -2 + 2 = 0
        // 0 has negative flag set to false
        assert(get_magnitude_if_positive(&c) == 0, 1);
    }

}