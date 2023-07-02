const std = @import("std");

pub fn bitwise() void {
    const shift_r = 100 << 2;
    const shirt_l = 1 << 2;
    const twobit = 0b100;
    std.debug.print("rs : {}\n", .{shift_r});
    std.debug.print("ls : {}\n", .{shirt_l});
    std.debug.print("bits : {}\n", .{twobit});
}

test "bw" {
    _ = bitwise();
}
