pub const Drawable = @import("drawable.zig").Drawable;

pub const CommandBuffer = opaque {
    extern fn release(self: *CommandBuffer) void;

    extern fn CommandBuffer_commit(self: *CommandBuffer) void;
    extern fn CommandBuffer_presentDrawable(self: *CommandBuffer, drawable: *Drawable) void;
    extern fn CommandBuffer_addCompletedHandler(self: *CommandBuffer, cb: *const fn (*CommandBuffer) void) void;
    extern fn CommandBuffer_setLabel(self: *CommandBuffer, label: [*:0]const u8) void;

    pub fn deinit(self: *CommandBuffer) void {
        release(self);
    }

    pub fn commit(self: *CommandBuffer) void {
        CommandBuffer_commit(self);
    }

    pub fn presentDrawable(self: *CommandBuffer, drawable: *Drawable) void {
        CommandBuffer_presentDrawable(self, drawable);
    }

    pub fn addCompletedHandler(self: *CommandBuffer, cb: *const fn (*CommandBuffer) void) void {
        CommandBuffer_addCompletedHandler(self, cb);
    }

    pub fn setLabel(self: *CommandBuffer, label: [:0]const u8) void {
        CommandBuffer_setLabel(self, label.ptr);
    }
};
