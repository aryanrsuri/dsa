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
    var front = array[0..med];
    var back = array[med + 1 ..];
    merge_sort(front);
    merge_sort(back);
}
