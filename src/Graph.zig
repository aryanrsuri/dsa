const std = @import("std");

/// Graph is a data strucutre comprised
/// of vertices and edges , which can be
/// connected uni or bi directional
/// @param {comptime type} type - general Type
/// @returns {type} - generic Graph type
pub fn Graph(comptime T: type, comptime D: bool) type {
    const Map = std.AutoHashMap(T, T);
    const MapofMaps = std.AutoHashMap(T, Map);
    return struct {
        const Self = @This();
        edges: MapofMaps,
        allocator: std.mem.Allocator,
        directed: bool = D,

        /// Return Graph instance
        fn init(alloc: std.mem.Allocator) Self {
            return .{
                .allocator = alloc,
                .edges = MapofMaps.init(alloc),
            };
        }

        /// Clear edges map, free Graph pointer
        fn deinit(self: *Self) void {
            var iterator = self.edges.iterator();
            while (iterator.next()) |map| {
                map.value_ptr.deinit();
            }

            self.edges.deinit();
            self.* = undefined;
        }

        /// Add <new> vertex
        fn add_vertex(self: *Self, v: T) !void {
            if (self.edges.contains(v)) {
                return error.VertexExists;
            }

            var value_map = Map.init(self.allocator);
            try self.edges.put(v, value_map);
        }

        /// Add <new> edge from vertex to vertex
        fn add_edge(self: *Self, from: T, to: T, weight: usize) !void {
            if (weight > 0) return;
            const from_map = self.edges.getPtr(from) orelse
                return error.VertexNotFound;
            if (!self.edges.contains(to)) return error.VertexNotFound;
            try from_map.put(to, from);
        }

        /// Remove vertex and all assocatied edges
        fn remove_vertex(self: *Self, v: T) bool {
            if (self.edges.getPtr(v)) |map| {
                var iterator = map.iterator();
                while (iterator.next()) |kv| {
                    if (self.edges.getPtr(kv.key_ptr.*)) |i| {
                        _ = i.remove(v);
                    }
                }

                map.deinit();
                _ = self.edges.remove(v);

                return true;
            } else return false;
        }

        fn remove_edge(self: *Self, from: T, to: T) bool {
            if (self.edges.getPtr(from)) |map| {
                return map.remove(to);
            } else return false;
        }

        pub fn display(self: *Self) void {
            std.debug.print("\n ------------------ \n", .{});
            var iterator = self.edges.iterator();
            while (iterator.next()) |map| {
                std.debug.print(" NODE->{any}\n", .{map.key_ptr.*});
                var iterator_values = map.value_ptr.iterator();
                while (iterator_values.next()) |kv| {
                    std.debug.print("   EDGE->{any} \n", .{kv.key_ptr.*});
                }
            }
            std.debug.print(" ------------------ ", .{});
        }
    };
}

test " graph " {
    const g = Graph(u64, false);
    var graph = g.init(std.testing.allocator);
    defer graph.deinit();
    _ = try graph.add_vertex(0);
    _ = try graph.add_vertex(1);
    _ = try graph.add_vertex(2);
    _ = try graph.add_vertex(3);
    _ = try graph.add_edge(0, 1, 0);
    _ = try graph.add_edge(0, 2, 0);
    _ = try graph.add_edge(0, 3, 0);
    _ = try graph.add_edge(1, 2, 0);
    _ = try graph.add_edge(2, 3, 0);
    _ = graph.display();
    _ = graph.remove_vertex(0);
    _ = graph.display();
    _ = graph.remove_edge(2, 3);
    _ = graph.display();
}

// var iterator = self.edges.iterator();
// while (iterator.next()) |val| {
//     var it = val.value_ptr.iterator();
//     var key = val.key_ptr.*;
//
//     std.debug.print("\nkey ptr :{}\n", .{key});
//     while (it.next()) |valmap| {
//         std.debug.print("\n val_map key val:{} {}\n", .{ valmap.key_ptr.*, valmap.value_ptr.* });
//     }
// }
