const std = @import("std");

/// Use countillary array to map the count to an index
pub fn counting_sort(comptime array: []usize) [array.len]usize {
    comptime var max = std.mem.max(usize, array);
    const len = array.len;
    var clone = [_]usize{0} ** len;
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

    for (0..len) |i| clone[i] = out[i];

    return clone;
}

//Non comptime counting sort
// pub fn c_sort(array: []usize, comptime max: usize) void {
//     var count = [_]usize{0} ** (max + 1);
//     var output = [_]usize{0} ** (max + 1);
//     for (array) |x| {
//         count[x] = std.mem.count(usize, array, &[_]usize{x});
//     }
//
//     for (1..max + 1) |i| {
//         count[i] += count[i - 1];
//     }
//
//     for (array) |x| {
//         output[count[x] - 1] = x;
//         count[x] -= 1;
//     }
//
//     for (0..array.len) |i| array[i] = output[i];
// }
test "count" {
    comptime var arr = [_]usize{ 4, 2, 2, 8, 3, 3, 1, 50 };
    const res = counting_sort(&arr);
    // _ = c_sort(&arr, 50);
    std.debug.print("res: {any}\n", .{res});
}
