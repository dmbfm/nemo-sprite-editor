pub const Function = opaque {
    extern fn release(self: *Function) void;

    pub fn deinit(self: *Function) void {
        release(self);
    }
};
