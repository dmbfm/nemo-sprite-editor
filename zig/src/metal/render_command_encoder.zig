const RenderPipelineState = @import("render_pipeline_state.zig").RenderPipelineState;
const Viewport = @import("structs.zig").Viewport;
const ScissorRect = @import("structs.zig").ScissorRect;
const Buffer = @import("buffer.zig").Buffer;
const Winding = @import("enums.zig").Winding;
const TriangleFillMode = @import("enums.zig").TriangleFillMode;
const CullMode = @import("enums.zig").CullMode;
const PrimitiveType = @import("enums.zig").PrimitiveType;

pub const RenderCommandEncoder = opaque {
    const Self = @This();

    extern fn RenderCommandEncoder_setRenderPipelineState(self: *Self, state: *RenderPipelineState) void;
    extern fn RenderCommandEncoder_setTriangleFillMode(self: *Self, value: u64) void;
    extern fn RenderCommandEncoder_setFrontFaceWinding(self: *Self, value: u64) void;
    extern fn RenderCommandEncoder_setCullMode(self: *Self, value: u64) void;
    extern fn RenderCommandEncoder_setViewport(self: *Self, value: Viewport) void;
    extern fn RenderCommandEncoder_setScissorRect(self: *Self, value: ScissorRect) void;
    extern fn RenderCommandEncoder_setBlendColor(self: *Self, r: f32, g: f32, b: f32, a: f32) void;
    extern fn RenderCommandEncoder_setVertexBuffer(self: *Self, buffer: *Buffer, offset: u64, index: u64) void;
    extern fn RenderCommandEncoder_setFragmentBuffer(self: *Self, buffer: *Buffer, offset: u64, index: u64) void;
    extern fn RenderCommandEncoder_setVertexBytes(self: *Self, bytes: [*c]const u8, length: u64, index: u64) void;
    extern fn RenderCommandEncoder_setFragmentBytes(self: *Self, bytes: [*c]const u8, length: u64, index: u64) void;
    extern fn RenderCommandEncoder_drawPrimitives(self: *RenderCommandEncoder, primitive_type: u64, vertex_start: u64, vertex_end: u64) void;
    extern fn RenderCommandEncoder_endEncoding(self: *Self) void;

    pub fn setRenderPipelineState(self: *Self, state: *RenderPipelineState) void {
        RenderCommandEncoder_setRenderPipelineState(self, state);
    }

    pub fn setTriangleFillMode(self: *Self, value: TriangleFillMode) void {
        RenderCommandEncoder_setTriangleFillMode(self, @enumToInt(value));
    }

    pub fn setFrontFacingWinding(self: *Self, value: Winding) void {
        RenderCommandEncoder_setFrontFaceWinding(self, @enumToInt(value));
    }

    pub fn setCullMode(self: *Self, value: CullMode) void {
        RenderCommandEncoder_setCullMode(self, @enumToInt(value));
    }

    pub fn setViewport(self: *Self, value: Viewport) void {
        RenderCommandEncoder_setViewport(self, value);
    }

    pub fn setScissorRect(self: *Self, value: ScissorRect) void {
        RenderCommandEncoder_setScissorRect(self, value);
    }

    pub fn setBlendColor(self: *Self, r: f32, g: f32, b: f32, a: f32) void {
        RenderCommandEncoder_setBlendColor(self, r, g, b, a);
    }

    pub fn setVertexBuffer(self: *Self, buffer: *Buffer, offset: usize, index: usize) void {
        RenderCommandEncoder_setVertexBuffer(self, buffer, @intCast(u64, offset), @intCast(u64, index));
    }

    pub fn setVertexBytes(self: *Self, bytes: []const u8, index: usize) void {
        RenderCommandEncoder_setVertexBytes(self, bytes.ptr, @intCast(u64, bytes.len), @intCast(u64, index));
    }

    pub fn setFragmentBuffer(self: *Self, buffer: *Buffer, offset: usize, index: usize) void {
        RenderCommandEncoder_setFragmentBuffer(self, buffer, @intCast(u64, offset), @intCast(u64, index));
    }

    pub fn setFragmentBytes(self: *Self, bytes: []const u8, index: usize) void {
        RenderCommandEncoder_setFragmentBytes(self, bytes.ptr, @intCast(u64, bytes.len), @intCast(u64, index));
    }

    pub fn endEncoding(self: *Self) void {
        RenderCommandEncoder_endEncoding(self);
    }

    pub fn drawPrimitives(self: *Self, primitive_type: PrimitiveType, vertex_start: usize, vertex_end: usize) void {
        RenderCommandEncoder_drawPrimitives(self, @enumToInt(primitive_type), @intCast(u64, vertex_start), @intCast(u64, vertex_end));
    }
};
