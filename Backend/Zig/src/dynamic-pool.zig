const std = @import("std");

pub fn DynamicPool(comptime T: type) type {
    return struct {
        slots: std.ArrayList(Slot) = undefined,
        allocator: std.mem.Allocator = undefined,

        const Slot = struct {
            generation: u32 = 0,
            ptr: ?*T = null,
        };

        const Key = struct {
            index: u32 = 0,
            generation: u32 = 0,

            pub fn encode(self: Key) u64 {
                var result: u64 = 0;
                result = @intCast(u64, self.index);
                result = result | @intCast(u64, self.generation) << 32;
                return result;
            }

            pub fn decode(value: u64) Key {
                var index: u32 = 0;
                var generation: u32 = 0;

                index = @intCast(u32, value & 0xFFFFFFFF);
                generation = @intCast(u32, (value >> 32));

                return .{ .index = index, .generation = generation };
            }
        };

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .slots = std.ArrayList(Slot).init(allocator),
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            for (self.slots.items) |slot| {
                if (slot.ptr) |ptr| {
                    self.allocator.destroy(ptr);
                }
            }

            self.slots.deinit();
        }

        pub fn alloc(self: *Self) !u64 {
            // Search for a free slot
            for (self.slots.items, 0..) |*slot, idx| {
                var s: *Slot = slot;
                // Free slot found
                if (s.ptr == null) {

                    // Allocate entry
                    s.ptr = try self.allocator.create(T);

                    // Return encoded key
                    var key = Key{ .index = @intCast(u32, idx), .generation = s.generation };
                    return key.encode();
                }
            }

            // If no free slot was found, create a new slot
            var ptr = try self.allocator.create(T);
            var slot = Slot{
                .ptr = ptr,
                .generation = 0,
            };
            try self.slots.append(slot);

            var key = Key{ .index = @intCast(u32, self.slots.items.len - 1), .generation = 0 };
            return key.encode();
        }

        pub fn free(self: *Self, handle: u64) void {
            var key = Key.decode(handle);

            if (self.getSlot(key)) |slot| {
                if (slot.ptr) |ptr| {
                    self.allocator.destroy(ptr);

                    slot.ptr = null;
                    slot.generation += 1;
                }
            }
        }

        fn getSlot(self: *Self, key: Key) ?*Slot {
            if (key.index >= self.slots.items.len) {
                return null;
            }

            return &self.slots.items[key.index];
        }

        pub fn get(self: *Self, handle: u64) ?*T {
            var key = Key.decode(handle);

            if (self.getSlot(key)) |slot| {
                if (slot.generation != key.generation) {
                    return null;
                }

                return slot.ptr;
            }

            return null;
        }
    };
}

test "Key encode and decode" {
    const Pool = DynamicPool(i32);
    const Key = Pool.Key;

    var k = Key{ .index = 12, .generation = 3 };

    try std.testing.expect(k.encode() == 0x30000000C);

    k = Key.decode(0x30000000C);

    try std.testing.expect(k.index == 12 and k.generation == 3);
}

test "Pool" {
    const Pool = DynamicPool(u8);

    var pool = Pool.init(std.testing.allocator);
    defer pool.deinit();

    var a = try pool.alloc();
    var b = try pool.alloc();
    var c = try pool.alloc();

    try std.testing.expect(a == 0);
    try std.testing.expect(b == 1);
    try std.testing.expect(c == 2);

    {
        var aptr = pool.get(a).?;
        aptr.* = 100;

        var bptr = pool.get(b).?;
        bptr.* = 200;

        var cptr = pool.get(c).?;
        cptr.* = 255;
    }

    {
        var aptr = pool.get(a).?;
        try std.testing.expect(aptr.* == 100);

        var bptr = pool.get(b).?;
        try std.testing.expect(bptr.* == 200);

        var cptr = pool.get(c).?;
        try std.testing.expect(cptr.* == 255);
    }

    {
        pool.free(a);
        try std.testing.expect(pool.slots.items[0].generation == 1);
        try std.testing.expect(pool.slots.items[0].ptr == null);

        var d = try pool.alloc();

        var key = Pool.Key.decode(d);
        try std.testing.expect(key.generation == 1);
        try std.testing.expect(key.index == 0);

        var e = try pool.alloc();

        key = Pool.Key.decode(e);
        try std.testing.expect(key.generation == 0);
        try std.testing.expect(key.index == 3);

        pool.free(d);
        pool.free(e);
    }
}
