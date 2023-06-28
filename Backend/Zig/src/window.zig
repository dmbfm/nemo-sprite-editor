const std = @import("std");
const mtl = @import("metal.zig");

pub const Window = opaque {
    extern fn nemo_NemoEditorWindow_mouseX(self: *Window) f64;
    extern fn nemo_NemoEditorWindow_mouseY(self: *Window) f64;
    extern fn nemo_NemoEditorWindow_currentRenderPassDescriptor(self: *Window) ?*mtl.RenderPassDescriptor;
    extern fn nemo_NemoEditorWindow_currentDrawable(self: *Window) ?*mtl.Drawable;
    extern fn nemo_NemoEditorWindow_setClearColor(self: *Window, color: mtl.ClearColor) void;

    pub fn getMouseX(self: *Window) f64 {
        return nemo_NemoEditorWindow_mouseX(self);
    }

    pub fn getMouseY(self: *Window) f64 {
        return nemo_NemoEditorWindow_mouseY(self);
    }

    pub fn currentRenderPassDescriptor(self: *Window) ?*mtl.RenderPassDescriptor {
        return nemo_NemoEditorWindow_currentRenderPassDescriptor(self);
    }

    pub fn currentDrawable(self: *Window) ?*mtl.Drawable {
        return nemo_NemoEditorWindow_currentDrawable(self);
    }

    pub fn setClearColor(self: *Window, color: mtl.ClearColor) void {
        nemo_NemoEditorWindow_setClearColor(self, color);
    }
};
