const std = @import("std");

pub fn bubble_sort(array: []u64) void {
    var i: usize = 0;
    while (i < array.len - 1) : (i += 1) {
        var j: usize = 0;
        while (j < array.len - i - 1) : (j += 1) {
            if (array[j] > array[j + 1]) {
                var temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}
pub fn bubble_sort_optimised(array: []u64) void {
    var i: usize = 0;
    while (i < array.len - 1) : (i += 1) {
        var j: usize = 0;
        var sorted: bool = false;
        while (j < array.len - i - 1) : (j += 1) {
            if (array[j] > array[j + 1]) {
                var temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;

                sorted = true;
            }
        }

        if (!sorted) break;
    }
}

test " bubble sort" {
    var a = [_]u64{ 1, 7, 3, 2, 7, 5, 10, 0, 9 };
    std.debug.print("\narray : {any}\n", .{a});
    bubble_sort(&a);
    std.debug.print("\narray : {any}\n", .{a});
    bubble_sort_optimised(&a);
    std.debug.print("\narray : {any}\n", .{a});
}
