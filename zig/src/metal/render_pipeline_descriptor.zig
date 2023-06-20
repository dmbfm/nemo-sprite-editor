const Function = @import("function.zig").Function;
const VertexDescriptor = @import("vertex_descriptor.zig").VertexDescriptor;
const Mutability = @import("enums.zig").Mutability;
const PixelFormat = @import("enums.zig").PixelFormat;
const WriteMask = @import("enums.zig").WriteMask;
const BlendOperation = @import("enums.zig").BlendOperation;
const BlendFactor = @import("enums.zig").BlendFactor;

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
    extern fn RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(self: *Self, index: u64, value: u8) void;
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

    pub fn setColorAttachmentWriteMask(self: *Self, index: usize, value: WriteMask) void {
        RenderPipelineDescriptor_setColorAttachmentWriteMask(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentBlendEnabled(self: *Self, index: usize, value: bool) void {
        RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(self, @intCast(c_int, index), @intCast(u8, value));
    }

    pub fn setColorAttachmentAlphaBlendOperation(self: *Self, index: usize, value: BlendOperation) void {
        RenderPipelineDescriptor_setColorAttachmentAlphaBlendOperation(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentRgbBlendOperation(self: *Self, index: usize, value: BlendOperation) void {
        RenderPipelineDescriptor_setColorAttachmentRgbBlendOperation(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentDestinationAlphaBlendFactor(self: *Self, index: usize, value: BlendFactor) void {
        RenderPipelineDescriptor_setColorAttachmentDestinationAlphaBlendFactor(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentDestinationRgbBlendFactor(self: *Self, index: usize, value: BlendFactor) void {
        RenderPipelineDescriptor_setColorAttachmentDestinationRgbBlendFactor(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentSourceAlphaBlendFactor(self: *Self, index: usize, value: BlendFactor) void {
        RenderPipelineDescriptor_setColorAttachmentSourceAlphaBlendFactor(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentSourceRgbBlendFactor(self: *Self, index: usize, value: BlendFactor) void {
        RenderPipelineDescriptor_setColorAttachmentSourceRgbBlendFactor(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setDepthAttachmentPixelFormat(self: *Self, index: usize, value: PixelFormat) void {
        RenderPipelineDescriptor_setDepthAttachmentPixelFormat(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setStencilAttachmentPixelFormat(self: *Self, index: usize, value: PixelFormat) void {
        RenderPipelineDescriptor_setStencilAttachmentPixelFormat(self, @intCast(c_int, index), @enumToInt(value));
    }
};
