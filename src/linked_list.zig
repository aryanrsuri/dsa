const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct {
            next: ?*Node = null,
            data: T,

            /// (node pointer node pointer) -> void
            fn insert_after(node: *Node, new_node: *Node) void {
                new_node.next = node.next;
                node.next = new_node;
            }

            /// (node pointer) -> node removed orelse null
            fn remove_next(node: *Node) ?*Node {
                const next_node = node.next orelse return null;
                node.next = next_node.next;
                return next_node;
            }

            /// (const node pointer) -> count
            fn count_next_nodes(node: *Node) usize {
                var count: usize = 0;
                var iter = node.next;
                while (iter) |n| : (iter = n.next) {
                    count += 1;
                }

                return count;
            }
        };
        head: ?*Node = null,

        fn init() Self {
            return .{};
        }

        fn append(self: *Self, new_node: *Node) void {
            new_node.next = self.head;
            self.head = new_node;
        }

        fn remove(self: *Self, node: *Node) void {
            if (self.head == node) {
                self.head = node.next;
            } else {
                var curr_node = self.head.?;
                while (curr_node.next != node) {
                    curr_node = curr_node.next.?;
                }
                curr_node.next = node.next;
            }
        }

        fn len(self: *Self) usize {
            if (self.head) |n| {
                return 1 + n.count_next_nodes();
            } else {
                return 0;
            }
        }
    };
}

test "Singly Linked List" {
    const lll = LinkedList(u8);
    var ll = lll.init();
    var one = lll.Node{ .data = 1 };
    ll.append(&one);
    ll.append(&one);
    ll.append(&one);
    ll.append(&one);
    _ = ll.print();
    // std.debug.print("sgll: {}\n", .{ll});
}
