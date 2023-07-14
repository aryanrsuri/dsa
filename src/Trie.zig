const std = @import("std");

/// Trie data structure for effeciently storing string chars
/// @returns Trie type
pub fn Trie() type {
    return struct {
        root: ?*Node = null,
        allocator: std.mem.Allocator,
        const Self = @This();
        const Node = struct {
            bytes: []u8 = undefined,
            next: ?*Node = null,
            word: bool = false,
        };

        pub fn init(allocator: std.mem.Allocator) Self {
            // var root: *Node = allocator.create(Node) catch {
            //     @panic("Node allocation failed");
            // };
            return .{ .allocator = allocator };
        }

        fn deinit(self: *Self) void {
            // while (self.root) |r| {
            //     self.allocator.free(r.bytes);
            // }
            self.* = undefined;
        }

        fn insert(self: *Self, chars: []const u8) !void {
            for (0..chars.len) |i| {
                var bytes = try self.allocator.alloc(u8, 26);
                defer self.allocator.free(bytes);
                bytes[chars[i] - 97] = chars[i];
                var node = Node{ .bytes = bytes };
                if (i == chars.len) {
                    node.word = true;
                }

                while (true) : (self.root.next) {
                    insert_after(self.)
                }
            }
            // if (self.root) |safe| {} else {
            //
            // }
        }
        fn insert_after(node: ?*Node, new: ?*Node) void {
            if (node) |safe| {
                safe.next.?.next = new;
            }
        }

        // fn print(self: *Self, node: *Node) void {
        //     for (node.*.bytes) |char| {}
        // }
    };
}
test "trie" {
    const t = Trie();
    var trie = t.init(std.testing.allocator);
    var root = Trie().Node{};
    defer trie.deinit();
    trie.root = &root;
    std.debug.print("\n", .{});
    _ = try trie.insert("and");
    std.debug.print("{any}\n", .{trie.root.?.bytes});
    std.debug.print("{s}\n", .{trie.root.?.next.?.bytes});
    // _ = try trie.insert("art");
}
