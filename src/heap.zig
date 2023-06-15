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

        fn heapify(self: *Self, i: usize) void {
            var max = i;
            var left = (2 * i) + 1;
            var right = (2 * i) + 2;
            var len = self.data.items.len;
            // if (left >= len or left < 0) {
            //     return;
            // }
            if (left < len and self.data.items[left] > self.data.items[max]) {
                max = left;
            }
            if (right < len and self.data.items[right] > self.data.items[max]) {
                max = right;
            }
            if (max != i) {
                std.mem.swap(T, &self.data.items[i], &self.data.items[max]);
                self.heapify(max);
            }
        }

        fn insert(self: *Self, element: T) void {
            var len = self.data.items.len;
            std.debug.print("\nelem: {}\n", .{element});
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
                }
                while (i > 0) : (i -= 1) {
                    self.heapify(i);
                }
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
    h.insert(5);
    h.insert(2);
    std.debug.print("\n---------------\nheap: {any}\n", .{h.data.items});
}
