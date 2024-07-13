const std = @import("std");
pub fn Queue(comptime T: type) void {
    return struct {
        const Self = @This();
        elems: []T,
        alloc: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator, max: usize) Self {
            const elements = allocator.alloc(T, max);
            return .{
                .elems = elements,
                .alloc = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.alloc.free(self.elems);
            self.* = undefined;
        }
    };
}
