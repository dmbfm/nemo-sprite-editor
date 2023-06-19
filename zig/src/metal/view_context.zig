const c = @import("c.zig");
const mtl = @import("../metal.zig");
const RenderPassDescriptor = mtl.RenderPassDescriptor;
const Drawable = c.Drawable;
const NSRect = c.NSRect;
const ClearColor = c.ClearColor;
const MBOK = c.MBOK;

pub const MetalViewContext = opaque {
    const Error = error{
        CurrentRenderPassDescriptorError,
        currentDrawableError,
    };

    extern fn metalViewContextCurrrentRenderPassDescriptor(self: *MetalViewContext, out: *RenderPassDescriptor) c_int;
    extern fn metalViewContextCurrrentDrawable(self: *MetalViewContext, out: *Drawable) c_int;
    extern fn metalViewContextViewBounds(self: *MetalViewContext) NSRect;
    extern fn metalViewContextScalingFactor(self: *MetalViewContext) f64;
    extern fn metalViewContextSetClearColor(self: *MetalViewContext, color: ClearColor) void;

    pub fn viewBounds(self: *MetalViewContext) NSRect {
        return metalViewContextViewBounds(self);
    }

    pub fn currentRenderPassDescriptor(self: *MetalViewContext) Error!RenderPassDescriptor {
        var rpd = RenderPassDescriptor{};

        if (metalViewContextCurrrentRenderPassDescriptor(self, &rpd) != MBOK) {
            return Error.CurrentRenderPassDescriptorError;
        }

        return rpd;
    }

    pub fn currentDrawable(self: *MetalViewContext) Error!Drawable {
        var drawable = Drawable{};

        if (metalViewContextCurrrentDrawable(self, &Drawable) != MBOK) {
            return Error.currentDrawableError;
        }

        return drawable;
    }

    pub fn setClearColor(self: *MetalViewContext, color: ClearColor) void {
        metalViewContextSetClearColor(self, color);
    }
};
