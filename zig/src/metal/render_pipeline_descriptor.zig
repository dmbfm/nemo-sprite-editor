const Function = @import("function.zig").Function;
const VertexDescriptor = @import("vertex_descriptor.zig").VertexDescriptor;
const Mutability = @import("enums.zig").Mutability;
const PixelFormat = @import("enums.zig").PixelFormat;

pub const RenderPipelineDescriptor = opaque {
    const Self = @This();

    extern fn release(self: *RenderPipelineDescriptor) void;
    extern fn RenderPipelineDescriptor_setLabel(self: *Self, label: [*:0]const u8) void;
    extern fn RenderPipelineDescriptor_reset(self: *Self) void;
    extern fn RenderPipelineDescriptor_setVertexFunction(self: *Self, value: *Function) void;
    extern fn RenderPipelineDescriptor_setFragmentFunction(self: *Self, value: *Function) void;
    extern fn RenderPipelineDescriptor_setVertexDescriptor(self: *Self, value: *VertexDescriptor) void;
    extern fn RenderPipelineDescriptor_setVertexBufferMutability(self: *Self, index: c_int, value: u64) void;
    extern fn RenderPipelineDescriptor_setFragmentBufferMutability(self: *Self, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentPixelFormat(self: *Self, index: u64, format: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentWriteMask(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentAlphaBlendOperation(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentRgbBlendOperation(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentDestinationAlphaBlendFactor(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentDestinationRgbBlendFactor(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentSourceAlphaBlendFactor(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setColorAttachmentSourceRgbBlendFactor(self: *Self, index: u64, value: u64) void;
    extern fn RenderPipelineDescriptor_setDepthAttachmentPixelFormat(self: *Self, index: c_int, value: u64) void;
    extern fn RenderPipelineDescriptor_setStencilAttachmentPixelFormat(self: *Self, index: c_int, value: u64) void;

    pub fn deinit(self: *Self) void {
        release(self);
    }

    pub fn setLabel(self: *Self, label: [:0]const u8) void {
        RenderPipelineDescriptor_setLabel(self, label.ptr);
    }

    pub fn reset(self: *Self) void {
        RenderPipelineDescriptor_reset(self);
    }

    pub fn setVertexFunction(self: *Self, value: *Function) void {
        RenderPipelineDescriptor_setVertexFunction(self, value);
    }

    pub fn setFragmentFunction(self: *Self, value: *Function) void {
        RenderPipelineDescriptor_setFragmentFunction(self, value);
    }

    pub fn setVertexDescriptor(self: *Self, desc: *VertexDescriptor) void {
        RenderPipelineDescriptor_setVertexDescriptor(self, desc);
    }

    pub fn setVertexBufferMutability(self: *Self, index: usize, mutability: Mutability) void {
        RenderPipelineDescriptor_setVertexBufferMutability(self, @intCast(c_int, index), @enumToInt(mutability));
    }

    pub fn setFragmentBufferMutability(self: *Self, index: usize, mutability: Mutability) void {
        RenderPipelineDescriptor_setFragmentBufferMutability(self, @intCast(c_int, index), @enumToInt(mutability));
    }

    pub fn setColorAttachmentPixelFormat(self: *Self, index: usize, format: PixelFormat) void {
        RenderPipelineDescriptor_setColorAttachmentPixelFormat(self, @intCast(c_int, index), @enumToInt(format));
    }
};
