const mtl = @import("../metal.zig");
const Quad = @import("../Quad.zig");
const Renderer = @import("../Renderer.zig");
const QuadRendererDumb = @import("QuadRendererDumb.zig");
const QuadRendererBatched = @import("QuadRendererBatched.zig");

pub const QuadRendererType = enum {
    dumb,
    batched,
};

pub fn QuadRenderer(comptime quad_renderer_type: QuadRendererType) type {
    const Impl = switch (quad_renderer_type) {
        .dumb => QuadRendererDumb,
        .batched => QuadRendererBatched,
    };

    return struct {
        impl: Impl = .{},

        const Self = @This();

        pub fn init(self: *Self, renderer: *Renderer) !void {
            return self.impl.init(renderer);
        }

        pub fn drawQuads(
            self: *Self,
            renderer: *Renderer,
            quadlist: []const Quad,
            encoder: *mtl.RenderCommandEncoder,
        ) !void {
            return self.impl.drawQuads(renderer, quadlist, encoder);
        }
    };
}
