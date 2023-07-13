const std = @import("std");

/// Trie data structure for effeciently storing string chars
/// @returns Trie type
pub fn Trie() type {
    return struct {
        root: ?*Node = null,
        allocator: std.mem.Allocator,
        const Self = @This();
        const Node = struct {
            bytes: [26]*u8 = undefined,
            word: bool = false,
        };

        pub fn init(allocator: std.mem.Allocator) Self {
            var root: *Node = allocator.create(Node) catch {
                @panic("Node allocation failed");
            };
            return .{ .allocator = allocator, .root = root };
        }

        fn deinit(self: *Self) void {
            if (self.root) |root| {
                self.allocator.destroy(root);
            }
        }

        fn insert(self: *Self, bytes: []const u8) !?void {}
    };
}
test "trie" {
    const t = Trie();
    var trie = t.init(std.testing.allocator);
    defer trie.deinit();
    // _ = try trie.insert("test");
    // _ = try trie.insert("test");
    std.debug.print("trie : {any}\n", .{trie});
}
