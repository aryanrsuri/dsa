const std = @import("std");

pub fn Set(comptime T: type) type {
    return struct {
        const Self = @This();
        set: []T,
        index: usize,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .set = &[_]T{},
                .index = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.set);
            self.* = undefined;
        }

        pub fn add(self: *Self, value: T) void {
            self.set[self.index] = value;
            self.index += 1;
            self.allocator.resize();
        }

        // pub fn remove(self: *Self, value: T) void {
        //     for (self.set) |item| {
        //         // if (item == value)
        //
        //     }
        //
        // }

        pub fn @"union"(self: *Self, set: *Set) void {
            for (set.set) |value| {
                self.set[self.index] = value;
                self.index += 1;
                std.debug.print("{any}\n", .{value});
            }
        }
    };
}
