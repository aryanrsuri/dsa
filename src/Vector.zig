const std = @import("std");

pub fn Vector(comptime T: type, comptime SIZE: usize) type {
    return struct {
        const Self = @This();
        allocator: std.mem.Allocator,
        items: []T,

        pub fn init(allocator: std.mem.Allocator) Self {
            var items = allocator.alloc(T, SIZE) catch @panic("Vector Allocation failed");
            return .{ .allocator = allocator, .items = items };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
            self.* = undefined;
        }

        pub fn space(self: *Self) usize {
            return self.SIZE;
        }

        pub fn clear(self: *Self) void {
            self.mask(0);
        }

        pub fn zero(self: *Self) void {
            self.mask(0);
        }

        pub fn one(self: *Self) void {
            self.mask(1);
        }

        pub fn cast(self: *Self, comptime d_type: type) !Vector(d_type, SIZE) {
            const d_meta = @typeInfo(d_type);
            if (d_meta != .Float or d_meta != .Int) return error{Error};
            _ = self;
        }

        pub fn set(self: *Self, comptime length: usize, items: [length]T) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] = items[i];
            }
        }

        pub fn mask(self: *Self, value: T) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] = value;
            }
        }

        pub fn copy(self: *Self) Vector(T, SIZE) {
            var i: usize = 0;
            var v: Vector(T, SIZE) = Vector(T, SIZE).init(self.allocator);
            while (i < self.items.len) : (i += 1) {
                v.items[i] = self.items[i];
            }

            return v;
        }

        pub fn scale(self: *Self, scalar: T) void {
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] *= scalar;
            }
        }

        pub fn magnitude(self: *Self) T {
            return std.math.sqrt(self.dot(self));
        }

        pub fn normalise(self: *Self) void {
            var i: usize = 0;
            const _magnitude = self.magnitude();
            while (i < self.items.len) : (i += 1) {
                self.items[i] /= _magnitude;
            }
        }

        pub fn eql(self: *Self, u: *Vector(T, SIZE)) bool {
            var result: bool = true;
            var i: usize = 0;
            while (i < self.items.len) : (i += 1) {
                if (self.items[i] != u.items[i]) {
                    result = false;
                }
            }

            return result;
        }

        pub fn dot(self: *Self, u: *Vector(T, SIZE)) T {
            if (self.items.len != u.items.len) @panic(" Vector spaces unequal ");
            var i: usize = 0;
            var result: T = 0;
            while (i < self.items.len) : (i += 1) {
                self.items[i] *= u.items[i];
                result += self.items[i] * self.items[i];
            }

            return result;
        }
    };
}

test "Vector" {
    var t = std.testing.allocator;
    var v = Vector(f64, 3).init(t);
    var u = Vector(f64, 3).init(t);
    var k = Vector(u64, 3).init(t);
    var l = Vector(u64, 3).init(t);
    k.one();
    l.one();

    defer {
        v.deinit();
        u.deinit();
        k.deinit();
        l.deinit();
    }

    v.mask(2.0);
    u.mask(5.0);
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    _ = v.dot(&u);
    std.debug.print("\n {any}\t{any} \n", .{ v.items, u.items });
    u.mask(0.0);
    _ = v.dot(&u);
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
    std.debug.print("\n {any}\t{any} \n", .{ v.items, k.eql(&l) });
}
