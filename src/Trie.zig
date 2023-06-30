const std = @import("std");

/// Trie data structure for effeciently storing string chars
/// @returns Trie type
pub fn Trie() type {
    return struct {
        root: ?*Node = null,
        const Self = @This();
        const Node = struct {
            char_array: [26]u8 = undefined,
            word_count: u8 = 0,
            next: 
        };

        pub fn init() Self {
            return .{};
        }

        pub fn insert(self: *Self, key: []const u8) void {
            if (self.root != null) {
                for (key) |char| {
                    std.debug.print("\nchar: {any}\n", .{char});
                }
            } else {}
        }
    };
}
test "trie" {
    const t = Trie();
    var trie = t.init();
    trie.insert("test");
    std.debug.print("trie : {any}\n", .{trie});
}
