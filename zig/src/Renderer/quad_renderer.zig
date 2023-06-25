const mtl = @import("../metal.zig");
const Quad = @import("../Quad.zig");
const Renderer = @import("../Renderer.zig");
const QuadRendererDumb = @import("QuadRendererDumb.zig");

pub const QuadRendererType = enum {
    dumb,
};

pub fn QuadRenderer(comptime quad_renderer_type: QuadRendererType) type {
    const Impl = switch (quad_renderer_type) {
        .dumb => QuadRendererDumb,
    };

    return struct {
        impl: Impl = .{},

        const Self = @This();

        pub fn init(self: *Self, renderer: *Renderer) void {
            self.impl.init(renderer);
        }

        pub fn drawQuads(
            self: *Self,
            renderer: *Renderer,
            quadlist: []const Quad,
            encoder: *mtl.RenderCommandEncoder,
        ) void {
            self.impl.drawQuads(renderer, quadlist, encoder);
        }
    };
}
