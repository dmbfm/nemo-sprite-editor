const std = @import("std");
const mtl = @import("../metal.zig");
const Renderer = @import("../Renderer.zig");
const Camera = @import("../Camera.zig");
const Quad = @import("../Quad.zig");
const Self = @This();
const quad = @import("quad.zig");

const VertexData = quad.VertexData;
const UniformData = quad.UniformData;

const MaxInFlightBuffers = Renderer.MaxInFlightBuffers;
const MaxQuads = Renderer.MaxQuads;
const VerticesPerQuad = 6;
const NumPipelines = 1;

vertex_buffer: [MaxInFlightBuffers]*mtl.Buffer = undefined,
uniform_buffer: [MaxInFlightBuffers]*mtl.Buffer = undefined,

pipelines: [NumPipelines]*mtl.RenderPipelineState = undefined,

pub fn init(self: *Self, renderer: *Renderer) !void {
    var device = renderer.device;
    var library = renderer.library;

    // Init buffers
    for (0..MaxInFlightBuffers) |i| {
        self.vertex_buffer[i] = try device.newBufferWithLength(VerticesPerQuad * MaxQuads * @sizeOf(VertexData));
        self.uniform_buffer[i] = try device.newBufferWithLength(MaxQuads * @sizeOf(UniformData));
    }

    // Shader functions
    var vertex_fn = try library.newFunctionWithName("vertex_main");
    defer vertex_fn.deinit();
    var fragment_fn = try library.newFunctionWithName("frag_main");
    defer fragment_fn.deinit();

    // Vertex descriptor
    var vertex_desc = try mtl.VertexDescriptor.init();
    defer vertex_desc.deinit();

    // Attribute 0: float3 position at buffer(0) interleaved
    vertex_desc.setAttributeFormat(0, mtl.VertexFormat.Float3);
    vertex_desc.setAttributeOffset(0, 0);
    vertex_desc.setAttributeBufferIndex(0, 0);

    // Attribute 1: float2 texcoord at bufffer(0) interleaved
    vertex_desc.setAttributeFormat(1, mtl.VertexFormat.Float2);
    vertex_desc.setAttributeOffset(1, @offsetOf(VertexData, "texcoord"));
    vertex_desc.setAttributeBufferIndex(1, 0);

    vertex_desc.setLayoutStride(0, @sizeOf(VertexData));

    // Render Pipeline Descriptor
    var rpd = try mtl.RenderPipelineDescriptor.init();
    defer rpd.deinit();

    rpd.setVertexFunction(vertex_fn);
    rpd.setFragmentFunction(fragment_fn);
    rpd.setVertexDescriptor(vertex_desc);
    rpd.setLabel("Quad Solid Color Pipeline");
    rpd.setColorAttachmentPixelFormat(0, mtl.PixelFormat.BGRA8Unorm);

    // Render Pipeline State
    self.pipelines[0] = try device.newRenderPipelineStateWithDescriptor(rpd);
}

pub fn drawQuads(
    self: *Self,
    renderer: *Renderer,
    quadlist: []const Quad,
    encoder: *mtl.RenderCommandEncoder,
) !void {
    var idx = renderer.current_frame_index;

    // Note: we assume global data is stored at buffer Renderer.BufferIndexGlobals,
    // and is already bound in the encoder via `setBuffer`.

    // Update quad data
    {
        var contents = self.vertex_buffer[idx].contents(VertexData);
        var uniform_contents = self.uniform_buffer[idx].contents(UniformData);

        for (quadlist, 0..) |q, i| {
            const x = q.position.x;
            const y = q.position.y;
            const z = q.position.z;
            const w = q.width;
            const h = q.height;

            contents[VerticesPerQuad * i + 0] = .{ .position = [_]f32{ x, y, z }, .texcoord = [_]f32{ 0, 1 } };
            contents[VerticesPerQuad * i + 1] = .{ .position = [_]f32{ x + w, y + h, z }, .texcoord = [_]f32{ 1, 0 } };
            contents[VerticesPerQuad * i + 2] = .{ .position = [_]f32{ x, y + h, z }, .texcoord = [_]f32{ 0, 0 } };
            contents[VerticesPerQuad * i + 3] = .{ .position = [_]f32{ x, y, z }, .texcoord = [_]f32{ 0, 1 } };
            contents[VerticesPerQuad * i + 4] = .{ .position = [_]f32{ x + w, y, z }, .texcoord = [_]f32{ 1, 1 } };
            contents[VerticesPerQuad * i + 5] = .{ .position = [_]f32{ x + w, y + h, z }, .texcoord = [_]f32{ 1, 0 } };

            uniform_contents[i] = .{ .color = [_]f32{ q.color.r, q.color.g, q.color.b } };
        }
    }

    // draw quads
    {
        encoder.setRenderPipelineState(self.pipelines[0]);

        for (quadlist, 0..) |_, i| {
            encoder.setVertexBuffer(self.vertex_buffer[idx], VerticesPerQuad * i * @sizeOf(VertexData), Renderer.BufferIndexVertex);
            encoder.setFragmentBuffer(self.uniform_buffer[idx], i * @sizeOf(UniformData), Renderer.BufferIndexUniforms);
            encoder.drawPrimitives(.triangle, 0, 6);
        }
    }
}
