const std = @import("std");
/// @fn Tree : Implements Binary search tree
/// @param T : type
/// @returns type
pub fn Tree(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        root: ?*Node = null,
        const Self = @This();
        const Node = struct {
            value: T,
            left: ?*Node = null,
            right: ?*Node = null,
        };

        fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
            };
        }

        pub fn insert(self: *Self, value: T) !?*const Node {
            var node: *?*Node = &self.root;
            while (node.*) |safe_node| {
                node = traverse(safe_node, value);
            }
            node.* = try self.allocator.create(Node);
            node.*.?.* = .{
                .value = value,
            };
            return node.*;
        }

        fn traverse(safe: *Node, value: T) *?*Node {
            var next: *?*Node = undefined;
            if (safe.value > value) {
                next = &safe.left;
            } else {
                next = &safe.right;
            }

            return next;
        }

        fn deinit_all(self: *Self) void {
            self.deinit(self.root);
        }

        fn deinit(self: *Self, node: ?*Node) void {
            if (node) |safe_node| {
                self.deinit(safe_node.left);
                self.deinit(safe_node.right);
                self.allocator.destroy(safe_node);
            }
        }

        fn print_all(self: *Self) void {
            std.debug.print("\n", .{});
            self.print(self.root);
        }

        fn print(self: *Self, node: ?*Node) void {
            if (node) |safe_node| {
                self.print(safe_node.left);
                self.print(safe_node.right);
                std.debug.print(" | {any} |  \n", .{safe_node.value});
            }
        }
    };
}

test " bt " {
    var tree = Tree(usize).init(std.testing.allocator);
    defer tree.deinit_all();
    for (1..20) |x| {
        _ = try tree.insert(x);
    }

    tree.print_all();
}
