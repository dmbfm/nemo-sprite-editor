//
//  Quad batched renderer
//
//  We store verte data for all quads in a single buffer, just like we do with
//  the dumb renderer.
//
//  Suppose we have N quads.
//
//  The Vertex buffer will then consist of 6 x N vertices, totalling 6 x N x
//  sizeOf(VertexData) bytes.
//
//  The Uniform buffer will consist of N entries, totalling N x sizeOf(UniformData)
//  bytes.
//
//  So far the arrangement is the same as in the dumb quad renderer. The
//  difference now will be that instead of binding the buffers with offsets and
//  encoding a draw function for each quad, we will issue a single draw command.
//

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
    var vertex_fn = try library.newFunctionWithName("vertex_quad_batch_main");
    defer vertex_fn.deinit();
    var fragment_fn = try library.newFunctionWithName("frag_quad_batch_main");
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

            uniform_contents[i] = .{ .color = [_]f32{ q.color.r, q.color.g, q.color.b, 1 } };
        }
    }

    {
        encoder.setRenderPipelineState(self.pipelines[0]);
        encoder.setVertexBuffer(self.vertex_buffer[idx], 0, Renderer.BufferIndexVertex);
        encoder.setFragmentBuffer(self.uniform_buffer[idx], 0, Renderer.BufferIndexUniforms);
        encoder.drawPrimitives(.triangle, 0, 6 * quadlist.len);
    }
}
