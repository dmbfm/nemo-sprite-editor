pub const Buffer = opaque {
    extern fn release(self: *Buffer) void;
    extern fn Buffer_contents(self: *Buffer) [*c]u8;
    extern fn Buffer_length(self: *Buffer) u64;

    pub fn deinit(self: *Buffer) void {
        release(self);
    }

    pub fn contents(self: *Buffer) []u8 {
        var ptr = Buffer_contents(self);
        var len = Buffer_length(self);
        var r: []u8 = undefined;
        r.ptr = ptr;
        r.len = len;
        return r;
    }
};
