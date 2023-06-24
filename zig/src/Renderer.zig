const std = @import("std");
const Quad = @import("Quad.zig");
const Renderer = @This();
const Camera = @import("Camera.zig");
const mtl = @import("metal.zig");
const app = @import("app.zig");

const NumPipelines = 2;
const MaxQuads = 100_000;

const QuadVertexData = extern struct {
    position: [3]f32,
    texcoord: [2]f32,
};

const QuadUniformData = extern struct {
    color: [3]f32,
};

library: *mtl.Library = undefined,
device: *mtl.Device = undefined,
command_queue: *mtl.CommandQueue = undefined,

quad_buffer: ?*mtl.Buffer = null,
global_uniform_buffer: ?*mtl.Buffer = null,
quad_uniform_buffer: ?*mtl.Buffer = null,

pipelines: [NumPipelines]*mtl.RenderPipelineState = undefined,

pub fn init(self: *Renderer, device: *mtl.Device) !void {
    self.device = device;
    self.library = try device.newDefaultLibrary();
    self.command_queue = try device.newCommandQueue();

    self.quad_buffer = try device.newBufferWithLength(MaxQuads * @sizeOf(QuadVertexData));
    self.global_uniform_buffer = try device.newBufferWithLength(@sizeOf([16]f32));
    self.quad_uniform_buffer = try device.newBufferWithLength(MaxQuads * @sizeOf(QuadUniformData));

    var vertex_fn = try self.library.newFunctionWithName("vertex_main");
    defer vertex_fn.deinit();
    var fragment_fn = try self.library.newFunctionWithName("frag_main");
    defer fragment_fn.deinit();

    var vertex_desc = try mtl.VertexDescriptor.init();
    defer vertex_desc.deinit();

    vertex_desc.setAttributeFormat(0, mtl.VertexFormat.Float3);
    vertex_desc.setAttributeOffset(0, 0);
    vertex_desc.setAttributeBufferIndex(0, 0);

    vertex_desc.setAttributeFormat(1, mtl.VertexFormat.Float2);
    vertex_desc.setAttributeOffset(1, @offsetOf(QuadVertexData, "texcoord"));
    vertex_desc.setAttributeBufferIndex(1, 0);

    vertex_desc.setLayoutStride(0, @sizeOf(QuadVertexData));

    var rpd = try mtl.RenderPipelineDescriptor.init();
    defer rpd.deinit();

    rpd.setVertexFunction(vertex_fn);
    rpd.setFragmentFunction(fragment_fn);
    rpd.setVertexDescriptor(vertex_desc);
    rpd.setLabel("Quad Solid Color Pipeline");
    rpd.setColorAttachmentPixelFormat(0, mtl.PixelFormat.BGRA8Unorm);

    self.pipelines[0] = try device.newRenderPipelineStateWithDescriptor(rpd);
}

pub fn drawQuads(
    self: *Renderer,
    camera: Camera,
    quadlist: []const Quad,
) !void {
    // Update global data
    {
        var contents = self.quad_buffer.?.contents([16]f32);
        contents[0] = camera.matrix.data;
    }

    // Update per-quad data
    {
        var contents = self.quad_buffer.?.contents([6]QuadVertexData);
        var uniform_contents = self.quad_uniform_buffer.?.contents(QuadUniformData);

        for (quadlist, 0..) |quad, i| {
            const x = quad.position.x;
            const y = quad.position.y;
            const z = quad.position.z;
            const w = quad.width;
            const h = quad.height;

            contents[i] = [6]QuadVertexData{
                .{
                    .position = [_]f32{ x, y, z },
                    .texcoord = [_]f32{ 0, 1 },
                },
                .{
                    .position = [_]f32{ x + w, y + h, z },
                    .texcoord = [_]f32{ 1, 0 },
                },
                .{
                    .position = [_]f32{ x, y + h, z },
                    .texcoord = [_]f32{ 0, 0 },
                },
                .{
                    .position = [_]f32{ x, y, z },
                    .texcoord = [_]f32{ 0, 1 },
                },
                .{
                    .position = [_]f32{ x + w, y, z },
                    .texcoord = [_]f32{ 1, 1 },
                },
                .{
                    .position = [_]f32{ x + w, y + h, z },
                    .texcoord = [_]f32{ 1, 0 },
                },
            };

            var uniform_data = QuadUniformData{
                .color = [_]f32{ quad.color.r, quad.color.g, quad.color.b },
            };
            uniform_contents[i] = uniform_data;
        }

        // Draw quads
        {
            var command_buffer = try self.command_queue.commandBuffer();
            var render_pass_descriptor = try app.currentRenderPassDescriptor();
            var encoder = try command_buffer.renderCommandEncoderWithDescriptor(render_pass_descriptor);

            encoder.setRenderPipelineState(self.pipelines[0]);
            encoder.setFragmentBuffer(self.global_uniform_buffer.?, 0, 1);

            for (quadlist, 0..) |_, i| {
                encoder.setVertexBuffer(self.quad_buffer.?, i * @sizeOf(QuadVertexData), 0);
                encoder.setFragmentBuffer(self.quad_uniform_buffer.?, i * @sizeOf(QuadUniformData), 11);
                encoder.drawPrimitives(.triangle, 0, 6);
            }

            var drawable = try app.currentDrawable();
            encoder.endEncoding();
            command_buffer.presentDrawable(drawable);
            command_buffer.commit();
        }
    }
}

test {
    var r = Renderer{};
    _ = r;
}
