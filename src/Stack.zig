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

pub fn Stack2(comptime T: type) type {
    return struct {
        const Self = @This();
        items: std.ArrayList(T),

        pub fn alloc(allocator: std.mem.Allocator) Self {
            return .{
                .items = std.ArrayList(T).init(allocator),
            };
        }

        pub fn dealloc(self: *Self) void {
            self.items.deinit();
        }

        pub fn push(self: *Self, item: T) !void {
            try self.items.append(item);
        }
    };
}

test "Stack" {
    // const u8stack = Stack(u8);
    const u8stack2 = Stack2(u8);
    var stack2 = u8stack2.alloc(std.testing.allocator);
    defer stack2.dealloc();
    var r = try stack2.push(10);
    // var r = try stack2.push(-10);
    std.debug.print("\n{any}\n", .{r});
    std.debug.print("\n{any}\n", .{stack2.items});
    // var stack = u8stack.init(std.testing.allocator);
    //
    // defer stack.deinit();
    // stack.print();
    // var n = stack.pop();
    // std.debug.print("\npopped element: {any}", .{n});
    // try stack.push(255);
    // try stack.push(2);
    // try stack.push(3);
    // try stack.push(3);
    // try stack.push(3);
    // try stack.push(3);
    // try stack.push(3);
    // try stack.push(3);
    // try stack.push(3);
    // stack.print();
    // n = stack.pop();
    // std.debug.print("\npopped element: {any}", .{n});
    // stack.print();
}
