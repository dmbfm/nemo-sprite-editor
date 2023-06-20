const mtl = @import("metal.zig");

pub const ViewContext = extern struct {
    view: *anyopaque,
    mouse_x: f64,
    mouse_y: f64,

    extern fn NemoViewContext_currentDrawable(self: *ViewContext) ?*mtl.Drawable;
    extern fn NemoViewContext_currentRenderPassDescriptor(self: *ViewContext) ?*mtl.RenderPassDescriptor;
    extern fn NemoViewContext_setClearColor(self: *ViewContext, color: mtl.ClearColor) void;

    const Error = error{
        CurrentDrawableError,
    };

    pub fn currentDrawable(self: *ViewContext) Error!*mtl.Drawable {
        var result = NemoViewContext_currentDrawable(self);
        if (result == null) {
            return Error.CurrentDrawableError;
        }
        return result.?;
    }

    pub fn currentRenderPassDescriptor(self: *ViewContext) Error!*mtl.RenderPassDescriptor {
        var result = NemoViewContext_currentRenderPassDescriptor(self);
        if (result == null) {
            return Error.CurrentDrawableError;
        }
        return result.?;
    }

    pub fn setClearColor(self: *ViewContext, color: mtl.ClearColor) void {
        NemoViewContext_setClearColor(self, color);
    }
};
