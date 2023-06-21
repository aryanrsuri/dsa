const std = @import("std");

/// Selection sort uses a "minimum" index to sort on
/// and places it as the front of the array
/// Arguments:
///     type
/// Returns:
///     type
fn selection_sort(array: []i64) void {
    var i: usize = 0;
    while (i < array.len - 1) : (i += 1) {
        var min = i;
        var j: usize = i + 1;
        while (j < array.len) : (j += 1) {
            if (array[j] < array[min]) {
                min = j;
            }
        }
        std.mem.swap(i64, &array[min], &array[i]);
    }
}

test "selection sort" {
    var array = [_]i64{ 2, 5, 4, 3, 6, 7 };
    std.debug.print("\n before sort array -> {any}\n", .{array});
    selection_sort(&array);
    std.debug.print(" after sort array -> {any}\n", .{array});
}
