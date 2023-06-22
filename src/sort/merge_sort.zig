const std = @import("std");

/// Merge sort is a divide and conquer sorting
/// algorithim that uses recursion to sort
/// on the turn of the median ad nosuem
/// n ln n effeciency
/// Arguments:
///    array of type i64
/// Returns:
///    void (array is sorted in place)
fn merge_sort(array: []i64) void {
    const med: usize = array.len / 2;
    var left = array[0 .. med + 1];
    var right = array[med..];
    std.debug.print("left : {any} \n right : {any} \n", .{ left, right });
    merge_sort(left);
    merge_sort(right);

    var i: usize = 0;
    var j: usize = 0;
    var k: usize = 0;
    while (i < left.len and j < right.len) : (k += 1) {
        if (left[i] < right[j]) {
            array[k] = left[i];
            i += 1;
        } else {
            array[k] = right[j];
            j += 1;
        }
    }
}

test " merge sort " {
    var array = [_]i64{ 9, 5, 1, 4, 3 };
    std.debug.print("unsorted array : {any}\n", .{array});
    merge_sort(&array);
    std.debug.print("sorted array : {any}\n", .{array});
}
