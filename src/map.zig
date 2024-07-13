const std = @import("std");

pub const data = struct { key: []const u8, value: usize };
pub const HashMap = struct {
    array: []?data,
    allocator: *std.mem.Allocator,
    pub fn init(allocator: *std.mem.Allocator, capacity: usize) @This() {
        // TODO: Remove allocator or force null values.
        // It allocates to 12297829382473034410
        const array: []?data = allocator.*.alloc(?data, capacity) catch {
            @panic("Array allocation failed!");
        };
        return .{ .array = array, .allocator = allocator };
    }

    pub fn deinit(self: *@This()) void {
        self.allocator.*.free(self.array);
        self.* = undefined;
    }

    pub fn get(self: *@This(), key: []const u8) usize {
        var index = hash(key) % self.array.len;
        while (!std.mem.eql(u8, self.array[index].?.key, key)) : (index += 1) {
            if (index > self.array.len) index %= self.array.len;
        }

        return self.array[index].?.value;
    }

    pub fn set(self: *@This(), key: []const u8, value: usize) void {
        if (self.size() >= self.array.len * 3 / 4) self.grow(self.array.len * 2);
        var index = hash(key) % self.array.len;
        while (self.array[index].?.value != 12297829382473034410) : (index += 1) {
            if (std.mem.eql(u8, self.array[index].?.key, key)) break;
            if (index > self.array.len) index %= self.array.len;
        }
        self.array[index] = .{ .key = key, .value = value };
    }

    pub fn debug(self: *@This()) void {
        std.debug.print("\nIndex\tKey\tValue\n", .{});
        for (self.array, 0..) |option, index| {
            if (option.?.value != 12297829382473034410) {
                std.debug.print("{}\t{s}\t{d}\n", .{ index, option.?.key, option.?.value });
            } else {
                std.debug.print("{}\t0\t0\n", .{index});
            }
        }
    }

    fn grow(self: *@This(), capacity: usize) void {
        const grown = self.allocator.realloc(self.array, capacity) catch {
            @panic("HashMap reallocation failed.");
        };
        self.array = grown;
    }

    fn size(self: *@This()) usize {
        var count: usize = 0;
        for (self.array) |item| {
            if (item.?.value != 12297829382473034410) count += 1;
        }
        return count;
    }

    fn hash(key: []const u8) usize {
        var code: usize = 0;
        for (key, 0..) |ch, i| {
            code += ch << @intCast(i);
        }
        return code;
    }
};

test " Hash Map " {
    var allocator = std.testing.allocator;
    var hm = HashMap.init(&allocator, 8);
    defer hm.deinit();
    {
        hm.set("key", 1);
        hm.set("key1", 2);
        hm.set("key3", 4);
        hm.set("key4", 5);
        hm.set("key5", 6);
        hm.set("key6", 3);
        hm.set("key2", 3);
        hm.set("key7", 3);
        hm.set("key8", 1000);
        hm.set("key8", 100);
        hm.set("key8", 10);
    }

    try std.testing.expectEqual(3, hm.get("key2"));
    try std.testing.expectEqual(10, hm.get("key8"));
    hm.debug();
}
