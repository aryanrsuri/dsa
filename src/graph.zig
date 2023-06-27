const std = @import("std");

pub fn Graph(comptime T: type) type {
    const Map = std.AutoHashMap(T, T);
    const MapofMaps = std.AutoHashMap(T, Map);
    return struct {
        const Self = @This();
        vertices: T,
        edges: MapofMaps,
        allocator: std.mem.Allocator,
        directed: bool = false,

        fn init(alloc: std.mem.Allocator, v: T) Self {
            return .{
                .vertices = v,
                .allocator = alloc,
                .edges = MapofMaps.init(alloc),
            };
        }

        fn deinit(self: *Self) void {
            var iterator = self.edges.iterator();
            while (iterator.next()) |k_v| {
                k_v.value_ptr.deinit();
            }
        }

        fn add_vertex(self: *Self, v: T) !void {
            if (self.edges.contains(v)) {
                return error.VertexExists;
            }

            var value_map = Map.init(self.allocator);
            try self.edges.put(v, value_map);
        }

        fn add_edge(self: *Self, from: T, to: T, weight: usize) !void {
            if (weight > 0) return;
            const from_map = self.edges.getPtr(from) orelse
                return error.VertexNotFound;
            if (!self.edges.contains(to)) return error.VertexNotFound;
            try from_map.put(to, from);
            // iter_print(from_map);
        }

        fn remove_vertex(self: *Self, v: T) void {
            // if (self.edges.getPtr(v)) |k_v| {
            // var iterator = k_v.iterator();
            // var res = k_v.fetchRemove(v);
            // std.debug.print("res : {} \n", .{res.?});

            // }
            _ = self.edges.remove(v);
        }

        fn remove_edge(self: *Self, from: T, to: T) bool {
            if (self.edges.getPtr(from)) |k_v| {
                iter_print(k_v);
                return k_v.remove(to);
            } else return false;
        }

        fn iter_print(kv: *std.hash_map.AutoHashMap(T, T)) void {
            var iter = kv.iterator();
            while (iter.next()) |k_v| {
                std.debug.print("\nKEY :: {}", .{k_v.key_ptr.*});
                std.debug.print(", VALUE :: {}\n", .{k_v.value_ptr.*});
            }
        }
    };
}

test " graph " {
    const g = Graph(u64);
    var graph = g.init(std.testing.allocator, 2);
    defer graph.deinit();
    _ = try graph.add_vertex(0);
    _ = try graph.add_vertex(1);
    _ = try graph.add_vertex(2);
    _ = try graph.add_edge(0, 1, 0);
    _ = try graph.add_edge(0, 2, 0);
    _ = try graph.add_edge(1, 2, 0);
    // const res = graph.remove_edge(1, 2);
    _ = graph.remove_vertex(0);
    // std.debug.print("\n remove edge : {} \n", .{res});
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
