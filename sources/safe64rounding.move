/// A gas-efficient library for performing u64 operations with rounding support
/// Routes all operations through u128 or u256
module safe64::safe64rounding {
    inline fun round_u128(value: u128, divisor: u128, round_up: bool): u128 {
        let quotient = value / divisor;
        let remainder = value % divisor;
        
        if (!round_up || remainder == 0) {
            quotient
        } else {
            quotient + 1
        }
    }

    inline fun round_u256(value: u256, divisor: u256, round_up: bool): u256 {
        let quotient = value / divisor;
        let remainder = value % divisor;
        
        if (!round_up || remainder == 0) {
            quotient
        } else {
            quotient + 1
        }
    }

    /// Multiply and divide with rounding option
    public inline fun muldiv(x: u64, y: u64, z: u64, round_up: bool): u64 {
        let result = (x as u128) * (y as u128);
        (round_u128(result, (z as u128), round_up) as u64)
    }

    /// Multiply and divide 2 with rounding option
    public inline fun muldiv2(a: u64, b: u64, c: u64, d: u64, round_up: bool): u64 {
        let num = (a as u128) * (b as u128);
        let den = (c as u128) * (d as u128);
        (round_u128(num, den, round_up) as u64)
    }

    /// Multiply 3 and divide with rounding option
    public inline fun mul3div(a: u64, b: u64, c: u64, d: u64, round_up: bool): u64 {
        let num = ((a as u256) * (b as u256) * (c as u256));
        let div = (d as u256);
        (round_u256(num, div, round_up) as u64)
    }

    /// Multiply 3, divide 2 with rounding option
    public inline fun mul3div2(a: u64, b: u64, c: u64, d: u64, e: u64, round_up: bool): u64 {
        let num = ((a as u256) * (b as u256) * (c as u256));
        let div = ((d as u256) * (e as u256));
        (round_u256(num, div, round_up) as u64)
    }

    /// Multiply 3, divide 3 with rounding option
    public inline fun mul3div3(a: u64, b: u64, c: u64, d: u64, e: u64, f: u64, round_up: bool): u64 {
        let num = ((a as u256) * (b as u256) * (c as u256));
        let div = ((d as u256) * (e as u256) * (f as u256));
        (round_u256(num, div, round_up) as u64)
    }
}