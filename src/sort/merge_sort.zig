const std = @import("std");

/// Merge sort is a divide and conquer sorting
/// algorithim that uses recursion to sort
/// on the turn of the median ad nosuem
/// n ln n effeciency
/// Arguments:
///    array of type i64
/// Returns:
///    void (array is sorted in place)
fn merge_sort(array: []i64) [5]i64 {
    var med: usize = array.len / 2;
    std.debug.print("median , arran len {} {} \n", .{ med, array.len });
    var left = array[0 .. med + 1];
    var right = array[med..];
    left = merge_sort(left);
    right = merge_sort(right);

    return merge(array, left, right);
}
fn merge(array: []i64, left: []i64, right: []i64) []i64 {
    var i: usize = 0;
    var j: usize = 0;
    var k: usize = 0;
    while (i < left.len and j < right.len) : (k += 1) {
        if (left[i] <= right[j]) {
            array[k] = left[i];
            i += 1;
        } else {
            array[k] = right[j];
            j += 1;
        }
    }

    return array;
}

test " merge sort " {
    // var t = [_]u64{ 1, 2, 3, 4, 5, 6 };
    // std.debug.print("array 0..3: {}\n, array 3.. : {*}\n", .{ t[0..3], t[3..] });
    var array = [5]i64{ 9, 5, 1, 4, 3 };
    std.debug.print("unsorted array : {any}\n", .{array});
    array = merge_sort(&array);
    std.debug.print("sorted array : {any}\n", .{array});
}
