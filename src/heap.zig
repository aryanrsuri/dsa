const std = @import("std");
pub fn Heap(comptime T: type) type {
    return struct {
        const Self = @This();
        data: std.ArrayList(T),
        alloc: std.mem.Allocator,

        fn init(allocator: std.mem.Allocator) Self {
            var data = std.ArrayList(T).init(allocator);
            return .{
                .data = data,
                .alloc = allocator,
            };
        }

        fn deinit(self: *Self) void {
            self.data.deinit();
        }

        fn heapify(self: *Self, index: usize) void {
            var max = index;
            var left = (2 * index) + 1;
            var right = (2 * index) + 2;
            const len = self.data.items.len;

            if (left < len and self.data.items[left] > self.data.items[max]) {
                max = left;
            }
            if (right < len and self.data.items[right] > self.data.items[max]) {
                max = right;
            }
            if (max != index) {
                std.mem.swap(T, &self.data.items[index], &self.data.items[max]);
                self.heapify(max);
            }
        }

        fn insert(self: *Self, element: T) void {
            const len = self.data.items.len;
            if (len <= 1) {
                self.data.append(element) catch {
                    @panic(" Append data failed ");
                };
            } else {
                self.data.append(element) catch {
                    @panic(" Append data failed ");
                };

                var i = (len / 2) - 1;
                if (i == 0) {
                    self.heapify(i);
                    return;
                } else {
                    while (i > 0) : (i -= 1) {
                        self.heapify(i);
                    }
                }
            }
        }

        fn remove(self: *Self, element: T) ?T {
            const len = self.data.items.len;
            if (len <= 1) {
                return self.data.popOrNull();
            } else {
                const needle = [1]T{element};
                const index = std.mem.indexOf(
                    T,
                    self.data.items,
                    &needle,
                );
                var i = (len / 2) - 1;
                if (i == 0) {
                    self.heapify(i);
                }
                while (i > 0) : (i -= 1) {
                    self.heapify(i);
                }

                if (index == null) {
                    return null;
                } else {
                    return self.data.orderedRemove(index.?);
                }
            }
        }

        fn depth(self: *Self, index: usize) usize {
            var len = self.data.items.len;
            var curr_depth: usize = 0;
            var curr_node: usize = index;
            while (curr_node > 0 and curr_node < len) : (curr_node = (curr_node - 1) / 2) {
                curr_depth += 1;
            }

            return curr_depth;
        }

        fn display(self: *Self) void {
            const len = self.data.items.len;
            var iter: usize = 0;
            std.debug.print("\n-------------------------\n", .{});
            while (iter < len) : (iter += 1) {
                std.debug.print("\n [ node: {} ** depth: {}  ] \n", .{ self.data.items[iter], self.depth(iter) });
            }
        }
    };
}

test " Heap " {
    const heap = Heap(u8);
    var h = heap.init(std.testing.allocator);
    defer h.deinit();
    h.insert(3);
    h.insert(4);
    h.insert(9);
    h.insert(8);
    h.insert(10);
    h.insert(8);
    h.insert(5);
    h.insert(2);
    h.display();
    _ = h.remove(4);
    _ = h.remove(1);
    h.display();
}
