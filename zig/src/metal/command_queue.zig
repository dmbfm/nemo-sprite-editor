pub const CommandBuffer = @import("command_buffer.zig").CommandBuffer;

pub const CommandQueue = opaque {
    const Error = error{
        CommandBufferError,
    };

    extern fn release(self: *CommandQueue) void;
    extern fn CommandQueue_commandBuffer(self: *CommandQueue) ?*CommandBuffer;

    pub fn deinit(self: *CommandQueue) void {
        release(self);
    }

    pub fn commandBuffer(self: *CommandQueue) Error!*CommandBuffer {
        var result = CommandQueue_commandBuffer(self);
        if (result == null) {
            return Error.CommandBufferError;
        }

        return result.?;
    }
};
