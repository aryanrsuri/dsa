const std = @import("std");

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();
        vertices: T,
        edges: std.AutoHashMap(T, [][3]T),
        allocator: std.mem.Allocator,
        directed: bool = false,

        fn init(alloc: std.mem.Allocator, v: T) Self {
            return .{
                .vertices = v,
                .allocator = alloc,
                .edges = std.AutoHashMap(T, [][3]T).init(alloc),
            };
        }

        fn deinit(self: *Self) void {
            self.edges.clearAndFree();
            self.edges.deinit();
        }

        fn add_vertex(self: *Self, v: T) !void {
            var nedge = [_][3]T{[3]T{ v, undefined, 0 }};
            _ = try self.edges.getOrPutValue(
                v,
                &nedge,
            );
            // std.debug.print("vertex added : {any} \n", .{nedge});
        }

        fn add_edge(self: *Self, vertex_1: T, vertex_2: T) !void {
            try self.add_weighted_edge(vertex_1, vertex_2, 0);
        }

        fn add_weighted_edge(self: *Self, vertex_1: T, vertex_2: T, weight: T) !void {
            try self.add_vertex(vertex_1);
            try self.add_vertex(vertex_2);
            var edges = self.edges.get(vertex_1);
            var nedge = [_]T{ vertex_1, vertex_2, weight };
            if (edges) |edge| {
                edge[1] = nedge;
                std.debug.print("edge : {any} {any}\n", .{ @TypeOf(edge), nedge });
                // try self.edges.put(vertex_1, &edge);
            }
        }
    };
}

test " grpah " {
    const g = Graph(u64);
    var graph = g.init(std.testing.allocator, 2);
    defer graph.deinit();
    _ = try graph.add_vertex(1);
    _ = try graph.add_vertex(2);
    _ = try graph.add_edge(1, 2);
}
