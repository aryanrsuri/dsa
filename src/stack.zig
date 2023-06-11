const std = @import("std");
pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();
        max: usize = 10,
        top: isize = -1,
        items: std.ArrayList(T),
        allocator: std.mem.Allocator,

        fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .items = std.ArrayList(T).init(allocator),
            };
        }

        fn deinit(self: *Self) void {
            self.items.deinit();
        }

        fn push(self: *Self, elem: T) !void {
            if (self.items.items.len >= self.max) return error.StackOverflow;
            self.top += 1;
            try self.items.append(elem);
        }

        fn pop(self: *Self) ?T {
            if (self.items.items.len == 0) return null;
            const elem = self.items.items[self.items.items.len - 1];
            self.items.items.len -= 1;
            return elem;
        }

        fn print(self: *Self) void {
            std.debug.print("\n [ ", .{});
            for (self.items.items) |elem| {
                std.debug.print("{} ", .{elem});
            }
            std.debug.print("]\n", .{});
        }
    };
}

test "Stack" {
    const u8stack = Stack(u8);
    var stack = u8stack.init(std.testing.allocator);
    defer stack.deinit();
    stack.print();
    var n = stack.pop();
    std.debug.print("\npopped element: {any}", .{n});
    try stack.push(255);
    try stack.push(2);
    try stack.push(3);
    try stack.push(3);
    try stack.push(3);
    try stack.push(3);
    try stack.push(3);
    try stack.push(3);
    try stack.push(3);
    stack.print();
    n = stack.pop();
    std.debug.print("\npopped element: {any}", .{n});
    stack.print();
}
