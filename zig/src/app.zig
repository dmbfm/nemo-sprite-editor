pub const mtl = @import("metal.zig");

extern fn NemoApp_mouseX() f64;
extern fn NemoApp_mouseY() f64;
extern fn NemoApp_windowWidth() c_int;
extern fn NemoApp_windowHeight() c_int;
extern fn NemoApp_windowScaleFactor() f64;
extern fn NemoApp_windowResized() bool;
extern fn NemoApp_mouseIsDragging() bool;
extern fn NemoApp_currentDrawable() ?*mtl.Drawable;
extern fn NemoApp_currentRenderPassDescriptor() ?*mtl.RenderPassDescriptor;
extern fn NemoApp_setClearColor(color: mtl.ClearColor) void;

const Error = error{
    CurrentDrawableError,
    CurrentRenderPassDescriptorError,
};

pub fn mouseX() f64 {
    return NemoApp_mouseX();
}

pub fn mouseY() f64 {
    return NemoApp_mouseY();
}

pub fn windowWith() usize {
    return @intCast(usize, NemoApp_windowWidth());
}

pub fn windowHeight() usize {
    return @intCast(usize, NemoApp_windowWidth());
}

pub fn windowScaleFator() f64 {
    return NemoApp_windowScaleFactor();
}

pub fn windowResized() bool {
    return NemoApp_windowResized();
}

pub fn currentDrawable() Error!*mtl.Drawable {
    var result = NemoApp_currentDrawable();
    if (result == null) {
        return Error.CurrentDrawableError;
    }
    return result.?;
}

pub fn currentRenderPassDescriptor() Error!*mtl.RenderPassDescriptor {
    var result = NemoApp_currentRenderPassDescriptor();
    if (result == null) {
        return Error.CurrentRenderPassDescriptorError;
    }
    return result.?;
}

pub fn setClearColor(color: mtl.ClearColor) void {
    NemoApp_setClearColor(color);
}
