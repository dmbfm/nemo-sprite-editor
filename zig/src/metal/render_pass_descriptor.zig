const ClearColor = @import("structs.zig").ClearColor;
const Texture = @import("texture.zig").Texture;
const StoreAction = @import("enums.zig").StoreAction;
const LoadAction = @import("enums.zig").LoadAction;

pub const RenderPassDescriptor = opaque {
    const Self = @This();

    pub extern fn release(self: *Self) void;
    pub extern fn RenderPassDescriptor_init() ?*Self;
    pub extern fn RenderPassDescriptor_setColorAttachmentClearColor(self: *Self, index: c_int, color: ClearColor) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentTexture(self: *Self, index: c_int, texture: *Texture) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentLevel(self: *Self, index: c_int, value: u64) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentSlice(self: *Self, index: c_int, value: u64) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentLoadAction(self: *Self, index: c_int, value: u64) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentStoreAction(self: *Self, index: c_int, value: u64) void;
    pub extern fn RenderPassDescriptor_setDepthAttachmentClearDepth(self: *Self, value: f64) void;
    pub extern fn RenderPassDescriptor_setStencilAttachmentClearStencil(self: *Self, value: f64) void;

    pub fn deinit(self: *Self) void {
        release(self);
    }

    pub fn setColorAttachmentClearColor(self: *Self, index: usize, color: ClearColor) void {
        RenderPassDescriptor_setColorAttachmentClearColor(self, @intCast(c_int, index), color);
    }

    pub fn setColorAttachmentTexture(self: *Self, index: usize, texture: *Texture) void {
        RenderPassDescriptor_setColorAttachmentTexture(self, @intCast(c_int, index), texture);
    }

    pub fn setColorAttachmentLevel(self: *Self, index: usize, level: usize) void {
        RenderPassDescriptor_setColorAttachmentLevel(self, @intCast(c_int, index), @intCast(u64, level));
    }

    pub fn setColorAttachmentSlice(self: *Self, index: usize, value: usize) void {
        RenderPassDescriptor_setColorAttachmentSlice(self, @intCast(c_int, index), @intCast(u64, value));
    }

    pub fn setColorAttachmentLoadAction(self: *Self, index: usize, value: LoadAction) void {
        RenderPassDescriptor_setColorAttachmentLoadAction(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setColorAttachmentStoreAction(self: *Self, index: usize, value: LoadAction) void {
        RenderPassDescriptor_setColorAttachmentStoreAction(self, @intCast(c_int, index), @enumToInt(value));
    }

    pub fn setDepthAttachmentClearDepth(self: *Self, value: f64) void {
        RenderPassDescriptor_setDepthAttachmentClearDepth(self, value);
    }

    pub fn setStencilAttachmentClearStencil(self: *Self, value: f64) void {
        RenderPassDescriptor_setStencilAttachmentClearStencil(self, value);
    }
};
