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
        head: ?*Node,
        len: usize = 0,

        fn init() Self {
            return .{ .head = null };
        }

        fn append(self: *Self, new_node: *Node) void {
            new_node.next = self.head;
            self.head = new_node;
            self.len += 1;
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
            self.len -= 1;
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

    std.debug.print("\n\n\n ------------------ \n\n\n {}\n", .{ll});
}

pub fn DoublyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct { next: ?*Node = null, prev: ?*Node = null, data: T };

        head: ?*Node,
        tail: ?*Node,
        len: usize = 0,

        fn init() Self {
            return .{
                .head = null,
                .tail = null,
            };
        }

        fn insert_node_after(self: *Self, node: *Node, new_node: *Node) void {
            new_node.prev = node;
            if (node.next) |next| {
                new_node.next = next;
                next.prev = new_node;
            } else {
                new_node.next = null;
                self.tail = new_node;
            }

            node.next = new_node;
            self.len += 1;
        }

        fn insert_node_before(self: *Self, node: *Node, new_node: *Node) void {
            new_node.next = node;
            if (node.prev) |prev| {
                new_node.prev = prev;
                prev.next = new_node;
            } else {
                new_node.prev = null;
                self.head = new_node;
            }

            node.prev = new_node;
            self.len += 1;
        }
        fn append(self: *Self, new_node: *Node) void {
            if (self.tail) |tail| {
                self.insert_node_after(tail, new_node);
            } else {
                self.prepend(new_node);
            }
        }

        fn prepend(self: *Self, new_node: *Node) void {
            if (self.head) |head| {
                self.insert_node_before(head, new_node);
            } else {
                self.head = new_node;
                self.tail = new_node;
                new_node.prev = null;
                new_node.next = null;
                self.len += 1;
            }
        }

        fn remove(self: *Self, node: *Node) void {
            if (node.prev) |prev| {
                prev.next = node.next;
            } else {
                self.head = node.next;
            }

            if (node.next) |next| {
                next.prev = node.prev;
            } else {
                self.tail = node.prev;
            }

            self.len += 1;
        }
    };
}

test "doubly Linked List" {
    const lll = DoublyLinkedList(u8);
    var ll = lll.init();
    var one = lll.Node{ .data = 1 };
    ll.append(&one);
    ll.append(&one);
    ll.append(&one);
    ll.append(&one);

    std.debug.print("\n\n\n ------------------ \n\n\n {}\n", .{ll});
}
