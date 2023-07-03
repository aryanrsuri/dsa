const std = @import("std");

/// A Ring Buffer or cyclic queue is array
/// of contigous data with a cyclic read/write
/// index useful for data stream
/// @param T type
/// @returns Generic ring buffer type
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
            self.buffer[self.wrap(self.write_index)] = value;
            self.write_index = self.wrap_2(self.write_index + 1);
        }

        fn wrap(self: *Self, index: usize) usize {
            return index % (self.buffer.len);
        }

        fn wrap_2(self: *Self, index: usize) usize {
            return index % (self.buffer.len * 2);
        }

        fn full(self: *Self) bool {
            return (self.write_index + 1) % self.buffer.len == self.read_index;
        }
    };
}

test "rb" {
    const rb = RingBuffer(usize);
    var r = try rb.init(std.testing.allocator, 20);
    defer r.deinit();
    for (0..9) |n| {
        _ = try r.write(n);
    }

    std.debug.print(" ring buffer : {any}\n", .{r.buffer});
}
