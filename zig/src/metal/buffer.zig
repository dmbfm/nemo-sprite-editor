const std = @import("std");

pub const Buffer = opaque {
    extern fn release(self: *Buffer) void;
    extern fn Buffer_contents(self: *Buffer) [*c]u8;
    extern fn Buffer_length(self: *Buffer) u64;

    pub fn deinit(self: *Buffer) void {
        release(self);
    }

    pub fn contents(self: *Buffer, comptime T: type) []T {
        var ptr = Buffer_contents(self);
        var len = Buffer_length(self);
        var r: []T = undefined;
        r.ptr = @ptrCast([*]T, @alignCast(@alignOf(T), ptr));
        r.len = len / @sizeOf(T);
        return r;
        //return std.mem.bytesAsSlice(T, r);
    }
};
