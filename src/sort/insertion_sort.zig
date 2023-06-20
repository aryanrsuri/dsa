const std = @import("std");

pub fn insertion_sort(comptime T: type) type {
    return struct {
        array: []T = undefined,
        fn sort(array: []T) void {
            var i: usize = 0;
            var min = i;
            while (i < array.len - 1) : (i += 1) {
                var j: usize = i + 1;
                while (j < array.len) : (j += 1) {
                    if (array[j] < array[min]) {
                        min = i;
                    }
                }

                std.mem.swap(T, &array[min], &array[i]);
                // array[min] = array[i];
            }
        }
    };
}

test "insertion sort" {
    const array = insertion_sort(u64);
    var arr = [_]u64{ 2, 5, 4, 3, 6, 7 };
    std.debug.print("\n-----------\narr:{any}\n", .{arr});
    array.sort(&arr);
    std.debug.print("\n-----------\narr:{any}\n", .{arr});
}
