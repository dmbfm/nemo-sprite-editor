const ClearColor = @import("structs.zig").ClearColor;
const Texture = @import("texture.zig").Texture;
const StoreAction = @import("enums.zig").StoreAction;
const LoadAction = @import("enums.zig").LoadAction;

pub const RenderPassDescriptor = opaque {
    const Self = @This();

    pub extern fn release(self: *Self) void;
    pub extern fn RenderPassDescriptor_init() ?*Self;
    pub extern fn RenderPassDescriptor_setColorAttachmentClearColor(self: *Self, index: usize, color: ClearColor) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentTexture(self: *Self, index: usize, texture: *Texture) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentLevel(self: *Self, index: usize, value: u64) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentSlice(self: *Self, index: usize, value: u64) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentLoadAction(self: *Self, index: usize, value: LoadAction) void;
    pub extern fn RenderPassDescriptor_setColorAttachmentStoreAction(self: *Self, index: usize, value: StoreAction) void;
    pub extern fn RenderPassDescriptor_setDepthAttachmentClearDepth(self: *Self, value: f64) void;
    pub extern fn RenderPassDescriptor_setStencilAttachmentClearStencil(self: *Self, value: f64) void;

    pub fn deinit(self: *Self) void {
        release(self);
    }
};
