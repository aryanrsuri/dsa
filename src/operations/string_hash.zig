const std = @import("std");

pub fn string_hash(string: []const u8) u64 {
    var str = std.mem.trim(u8, string, " \n");
    const prime: u8 = 31;
    const m: u32 = 1e9 + 9;
    var hash: u64 = 0;
    var prime_power: u64 = 1;
    for (str) |char| {
        hash = (hash + (char - 'a' + 1) * prime_power) % m;
        prime_power = (prime_power * prime) % m;
    }
    return hash;
}

test "hash string" {
    const result = string_hash("t");
    const result2 = string_hash("t");
    std.debug.print("\nresult : {} {}\n", .{ result, result2 });
}
