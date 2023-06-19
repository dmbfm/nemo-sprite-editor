pub const Drawable = @import("drawable.zig").Drawable;
pub const RenderCommandEncoder = @import("render_command_encoder.zig").RenderCommandEncoder;
pub const RenderPassDescriptor = @import("render_pass_descriptor.zig").RenderPassDescriptor;

pub const CommandBuffer = opaque {
    const Error = error{
        NewRenderCommandEncoder,
    };

    extern fn release(self: *CommandBuffer) void;
    extern fn CommandBuffer_commit(self: *CommandBuffer) void;
    extern fn CommandBuffer_presentDrawable(self: *CommandBuffer, drawable: *Drawable) void;
    extern fn CommandBuffer_addCompletedHandler(self: *CommandBuffer, cb: *const fn (*CommandBuffer) void) void;
    extern fn CommandBuffer_setLabel(self: *CommandBuffer, label: [*:0]const u8) void;
    extern fn CommandBuffer_renderCommandEncoderWithDescriptor(self: *CommandBuffer, desc: *RenderPassDescriptor) ?*RenderCommandEncoder;

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

    pub fn renderCommandEncoderWithDescriptor(self: *CommandBuffer, desc: *RenderPassDescriptor) Error!RenderCommandEncoder {
        var result = CommandBuffer_renderCommandEncoderWithDescriptor(self, desc);
        if (result == null) {
            return Error.NewRenderCommandEncoder;
        }
        return result.?;
    }
};
