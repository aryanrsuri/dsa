const std = @import("std");
const MAX = 10;

/// A queue is a first in first out data structure
pub fn Queue(comptime T: type) type {
    return struct {
        const Self = @This();
        front: usize,
        rear: usize,
        items: [MAX]T,

        fn init() Self {
            return .{
                .front = 0,
                .rear = 0,
                .items = undefined,
            };
        }

        fn enqueue(self: *Self, element: T) !void {
            if (self.front == 0) self.front = 1;
            self.items[self.rear] = element;
            self.rear += 1;
        }

        fn dequeue(self: *Self) ?T {
            const element = self.items[self.front];
            self.items[self.front] = 0;
            if (self.front == 0) return null;
            if (self.front >= self.rear) {
                self.front = 0;
                self.rear = 0;
            } else {
                self.front += 1;
            }

            return element;
        }

        fn peek(self: *Self) ?T {
            if (self.front == 0) return null;
            return self.items[self.front];
        }
    };
}

test "Queue" {
    const q = Queue(u8);
    var que = q.init(std.testing.allocator);
    var i: u8 = 0;
    while (i < MAX) : (i += 1) {
        try que.enqueue(i);
    }

    std.debug.print("\nqueue: {any}\n", .{que.items});
    var n = que.dequeue();
    std.debug.print("n: {any}\n", .{n});
    n = que.dequeue();
    std.debug.print("n: {any}\n", .{n});
    std.debug.print("peek: {any}\n", .{que.peek()});
    std.debug.print("queue: {any}\n", .{que.items});
}
