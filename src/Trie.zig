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
            // next: ?*Node = null,
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
            self.* = undefined;
        }

        fn insert(self: *Self, chars: []const u8) !?void {
            _ = self;
            for (chars) |byte| {
                std.debug.print("{}\n", .{byte});
            }
        }
    };
}
test "trie" {
    const t = Trie();
    var trie = t.init(std.testing.allocator);
    defer trie.deinit();
    _ = try trie.insert("and");
    // std.debug.print("{any}\n", .{trie});
}
