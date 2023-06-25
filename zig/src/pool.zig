const std = @import("std");

pub fn IndexManager(comptime Size: comptime_int) type {
    return struct {
        indices: [Size]usize = undefined,
        count: usize = 0,

        const Self = @This();

        pub fn push(self: *Self, value: usize) void {
            if (self.count < Size) {
                self.indices[self.count] = value;
                self.count += 1;
            }
        }

        pub fn pop(self: *Self) ?usize {
            if (self.count == 0) {
                return null;
            }

            defer self.count -= 1;
            return self.indices[self.count - 1];
        }
    };
}

pub fn Pool(comptime T: type, comptime Size: comptime_int) type {
    return struct {
        items: [Size]T = undefined,
        count: usize = 0,
        index: IndexManager(Size) = .{},

        const Self = @This();

        const Error = error{
            PoolOutOfSpace,
            HandleOutOfRange,
        };

        pub fn alloc(self: *Self) Error!usize {
            if (self.index.pop()) |value| {
                return value;
            }

            if (self.count >= Size) {
                return Error.PoolOutOfSpace;
            }

            self.count += 1;

            return self.count;
        }

        pub fn get(self: *Self, handle: usize) ?T {
            if (handle > Size) {
                return null;
            }

            return self.items[handle - 1];
        }

        pub fn getPointer(self: *Self, handle: usize) ?*T {
            if (handle > Size) {
                return null;
            }

            return &self.items[handle - 1];
        }

        pub fn set(self: *Self, handle: usize, value: T) Error!void {
            if (handle > Size) {
                return Error.HandleOutOfRange;
            }

            self.items[handle - 1] = value;
        }
    };
}

test "IndexManager" {
    var m = IndexManager(10){};
    for (0..10) |i| {
        m.push(i);
    }

    try std.testing.expect(m.pop().? == 9);
    try std.testing.expect(m.count == 9);
}

test "Pool" {
    var p = Pool(u8, 128){};
    var x1 = try p.alloc();
    try p.set(x1, 100);
    try std.testing.expect(p.get(x1).? == 100);
}
