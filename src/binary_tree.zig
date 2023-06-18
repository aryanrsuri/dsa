const std = @import("std");

/// @fn BinaryTree : Implements Binary search tree
/// @param T : type
/// @returns type
pub fn BinaryTree(comptime T: type) type {
    return struct {
        const Self = @This();
        const Node = struct {
            left: ?*Node = null,
            right: ?*Node = null,
            data: T,
        };

        head: ?*Node,
        len: usize = 0,

        fn init() Self {
            return .{ .head = null };
        }

        fn put(self: *Self, node: *Node) void {
            if (self.head) |head| {
                self.insert_after_parent(head, node);
            } else {
                self.head = node;
            }
            self.len += 1;
        }

        fn insert(self: *Self, element: T) void {
            var new_node: Node = .{ .data = element };
            if (self.head == null) {
                self.head = &new_node;
            } else {
                insert_node_after(self.head.?, &new_node);
            }
        }

        fn insert_node_after(node: *Node, new_node: *Node) void {
            if (new_node.data < node.data) {
                node.left = insert_node_after(node.left.?, new_node);
            } else {
                node.right = insert_node_after(node.right.?, new_node);
            }
        }
        fn display(self: *Self, head: ?*Node) void {
            if (head == null) {
                return;
            } else {
                std.debug.print("{} -> \n", .{head.?.data});
                self.display(head.?.left);
                self.display(head.?.right);
            }
        }
    };
}

test " bt " {
    const bt = BinaryTree(u64);
    var btinst = bt.init();

    btinst.insert(1);
    btinst.insert(3);

    // var t = bt.Node{ .data = 5 };
    // var w = bt.Node{ .data = 3 };
    // var e = bt.Node{ .data = 4 };
    // var m = bt.Node{ .data = 10 };
    // btinst.put(&t);
    // btinst.put(&w);
    // btinst.put(&e);
    // btinst.put(&m);
    std.debug.print("head {}  \n", .{btinst.head.?.data});
    // std.debug.print("head->left{} \n", .{btinst.head.?.left.?.data});
    // std.debug.print("head->right {} \n", .{btinst.head.?.right.?.data});
    // std.debug.print("head->right->left {} \n", .{btinst.head.?.right.?.left.?.data});
}
