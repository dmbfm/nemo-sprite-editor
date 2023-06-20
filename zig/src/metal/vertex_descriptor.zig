const VertexFormat = @import("enums.zig").VertexFormat;
const VertexStepFunction = @import("enums.zig").VertexStepFunction;

pub const VertexDescriptor = opaque {
    const Error = error{
        VertexDescriptorError,
    };

    const Self = @This();

    extern fn release(self: *Self) void;
    extern fn VertexDescriptor_init() ?*Self;
    extern fn VertexDescriptor_reset(self: *Self) void;
    extern fn VertexDescriptor_setAttributeFormat(self: *Self, index: u64, value: u64) void;
    extern fn VertexDescriptor_setAttributeOffset(self: *Self, index: u64, value: u64) void;
    extern fn VertexDescriptor_setAttributeBufferIndex(self: *Self, index: u64, value: u64) void;
    extern fn VertexDescriptor_setLayoutStride(self: *Self, index: u64, value: u64) void;
    extern fn VertexDescriptor_setLayoutStepRate(self: *Self, index: u64, value: u64) void;
    extern fn VertexDescriptor_setLayoutStepFunction(self: *Self, index: u64, value: u64) void;

    pub fn init() !*Self {
        var result = VertexDescriptor_init();
        if (result == null) {
            return Error.VertexDescriptorError;
        }
        return result.?;
    }

    pub fn deinit(self: *Self) void {
        release(self);
    }

    pub fn reset(self: *Self) void {
        VertexDescriptor_reset(self);
    }

    pub fn setAttributeFormat(self: *Self, index: usize, value: VertexFormat) void {
        VertexDescriptor_setAttributeFormat(self, @intCast(u64, index), @enumToInt(value));
    }

    pub fn setAttributeOffset(self: *Self, index: usize, value: usize) void {
        VertexDescriptor_setAttributeOffset(self, @intCast(u64, index), @intCast(u64, value));
    }

    pub fn setAttributeBufferIndex(self: *Self, index: usize, value: usize) void {
        VertexDescriptor_setAttributeBufferIndex(self, @intCast(u64, index), @intCast(u64, value));
    }

    pub fn setLayoutStride(self: *Self, index: usize, value: usize) void {
        VertexDescriptor_setLayoutStride(self, @intCast(u64, index), @intCast(u64, value));
    }

    pub fn setLayoutStepRate(self: *Self, index: usize, value: usize) void {
        VertexDescriptor_setLayoutStepRate(self, @intCast(u64, index), @intCast(u64, value));
    }

    pub fn setLayoutStepFunction(self: *Self, index: usize, value: VertexStepFunction) void {
        VertexDescriptor_setLayoutStepFunction(self, @intCast(u64, index), @enumToInt(value));
    }
};
