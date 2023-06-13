const std = @import("std");
const queue = @import("queue.zig");
const stack = @import("stack.zig");
const s = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = s.allocator();

fn main() !void {
    _ = queue.Queue();
}
