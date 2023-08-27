const std = @import("std");

pub fn Vector(comptime T: type) type {
    return struct {
        const Self = @This();
        allocator: std.mem.Allocator,
        items: []T,

        pub fn init(allocator: std.mem.Allocator, length: usize) Self {
            var items = allocator.alloc(T, length) catch @panic("Vector Allocation failed");
            return .{ .allocator = allocator, .items = items };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
            self.* = undefined;
        }

        pub fn set(self: *Self, comptime length: usize, items: [length]f64) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] = items[i];
            }
        }

        pub fn mask(self: *Self, value: f64) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] = value;
            }
        }

        pub fn copy(self: *Self) Vector(T) {
            var i: usize = 0;
            var v: Vector(T) = Vector(T).init(self.allocator, self.items.len);
            while (i < self.items.len) : (i += 1) {
                v.items[i] = self.items[i];
            }

            return v;
        }

        pub fn scale(self: *Self, scalar: f64) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] *= scalar;
            }
        }

        pub fn normalise(self: *Self) void {
            var i: usize = 0;
            var magnitude: f64 = 0;
            while (i < self.items.len) : (i += 1) {
                magnitude += (self.items[i] * self.items[i]);
            }
            magnitude = std.math.sqrt(magnitude);
            i = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] /= magnitude;
            }
        }

        pub fn dot(self: *Self, u: *Vector(T)) void {
            if (self.items.len != u.items.len) @panic(" Vector spaces unequal ");
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] *= u.items[i];
            }
        }
    };
}

test "Vector" {
    var t = std.testing.allocator;
    var v = Vector(f64).init(t, 3);
    var u = Vector(f64).init(t, 3);

    defer {
        v.deinit();
        u.deinit();
    }

    v.mask(2.0);
    u.mask(5.0);
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    v.dot(&u);
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    u.mask(0.0);
    v.dot(&u);
    var r = v.copy();
    defer r.deinit();
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    std.debug.print("\n {any}\t{any} \n", .{ v.items, r.items });
    v.mask(5.0);
    u.mask(8.0);
    v.scale(-0.5);
    u.scale(3);
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    u.normalise();
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    u.set(3, [3]f64{ 3, 2, 1 });
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
}
