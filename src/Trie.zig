const std = @import("std");

/// Trie data structure for effeciently storing string chars
/// @returns Trie type
pub fn Trie() type {
    return struct {
        root: ?*Node = null,
        allocator: std.mem.Allocator,
        const Self = @This();
        const Node = struct {
            char_array: []const u8 = undefined,
            word_count: usize = 0,
            left: ?*Node = null,
            right: ?*Node = null,
        };

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit_all(self: *Self) void {
            self.deinit(self.root);
        }

        fn deinit(self: *Self, node: ?*Node) void {
            if (node) |safe_node| {
                self.deinit(safe_node.left);
                self.deinit(safe_node.right);
                self.allocator.destroy(safe_node);
            }
        }

        pub fn insert(self: *Self, chars: []const u8) !?*const Node {
            var node: *?*Node = &self.root;
            while (node.*) |safe_node| {
                node = traverse(safe_node, chars);
            }

            for (chars) |char| {
                std.debug.print("{s}\n", .{[_]u8{char}});
            }

            node.* = try self.allocator.create(Node);
            node.*.?.* = .{
                .char_array = chars,
                .word_count = chars.len,
            };
            return node.*;
        }

        fn traverse(safe_node: *Node, chars: []const u8) *?*Node {
            var next: *?*Node = undefined;
            // std.debug.print("safe {any} chars : {any}\n", .{ safe_node.char_array, chars });
            if (safe_node.word_count > chars.len) {
                next = &safe_node.left;
            } else {
                next = &safe_node.right;
            }

            return next;
        }

        fn print_all(self: *Self) void {
            std.debug.print("\n", .{});
            self.print(self.root);
        }

        fn print(self: *Self, node: ?*Node) void {
            if (node) |safe_node| {
                self.print(safe_node.left);
                self.print(safe_node.right);
                std.debug.print(" | {s} |  \n", .{safe_node.char_array});
            }
        }
    };
}
test "trie" {
    const t = Trie();
    var trie = t.init(std.testing.allocator);
    defer trie.deinit_all();
    _ = try trie.insert("test");
    _ = try trie.insert("text");
    // _ = try trie.insert("test");
    // _ = try trie.insert("test");
    _ = trie.print_all();
    // std.debug.print("trie : {any}\n", .{trie});
}
