const std = @import("std");

pub fn RingBuffer(comptime T: type) type {
    return struct {
        const Self = @This();
        buffer: []T,
        read_index: usize,
        write_index: usize,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator, capacity: usize) !Self {
            var stream = try allocator.alloc(T, capacity);
            return .{
                .buffer = stream,
                .read_index = 0,
                .write_index = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.buffer);
            self.* = undefined;
        }

        pub fn write(self: *Self, value: T) !void {
            if (self.full()) return error.CapacityReached;
            self.write_overflow(value);
        }

        pub fn write_overflow(self: *Self, value: T) void {
            self.buffer[self.mask(self.write_index, 1)] = value;
            self.write_index = self.mask(self.write_index + 1, 2);
        }

        fn mask(self: *Self, index: usize, k: usize) usize {
            return index % (k * self.buffer.len);
        }

        fn full(self: *Self) bool {
            return (self.write_index + 1) % self.buffer.len == self.read_index;
        }
    };
}

test "rb" {
    const rb = RingBuffer(usize);
    var r = try rb.init(std.testing.allocator, 10);
    defer r.deinit();
    for (0..9) |n| {
        _ = try r.write(n);
    }

    _ = r.write_overflow(10);

    std.debug.print(" ring buffer : {any}\n", .{r.buffer});
}
