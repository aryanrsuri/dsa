const std = @import("std");

/// Use countillary array to map the count to an index
pub fn counting_sort(comptime array: []usize) void {
    comptime var max = std.mem.max(usize, array);
    var count = [_]usize{0} ** (max + 1);
    var out = [_]usize{0} ** (max + 1);

    for (array) |x| {
        const y = std.mem.count(usize, array, &[_]usize{x});
        count[x] = y;
    }

    for (1..max + 1) |i| {
        count[i] += count[i - 1];
    }

    for (array) |i| {
        var x = count[i];
        x -= 1;
        out[x] = i;
        count[i] -= 1;
    }

    for (0..array.len) |i| {}

    std.debug.print("out: {any}\n", .{out});
    std.debug.print("arr: {any}\n", .{array});
}

test "count" {
    comptime var arr = [_]usize{ 4, 2, 2, 8, 3, 3, 1, 50 };
    counting_sort(&arr);
    std.debug.print(" {any} ", .{arr});
}
