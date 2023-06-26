const std = @import("std");
const Quad = @import("Quad.zig");
const Renderer = @This();
const Camera = @import("Camera.zig");
const mtl = @import("metal.zig");
const app = @import("app.zig");
const Pool = @import("pool.zig").Pool;
const QuadRenderer = @import("Renderer/quad_renderer.zig").QuadRenderer;
const dispatch_semaphore_create = std.c.dispatch_semaphore_create;
const dispatch_semaphore_wait = std.c.dispatch_semaphore_wait;
const dispatch_semaphore_signal = std.c.dispatch_semaphore_signal;
const DISPATCH_TIME_FOREVER = std.c.DISPATCH_TIME_FOREVER;

pub const MaxQuads = 1_000_000;
pub const MaxTextures = MaxQuads;
pub const MaxInFlightBuffers = 3;

pub const BufferIndexVertex = 0;
pub const BufferIndexUniforms = 11;
pub const BufferIndexGlobals = 22;

pub const TextureHandle = usize;

library: *mtl.Library = undefined,
device: *mtl.Device = undefined,
command_queue: *mtl.CommandQueue = undefined,
texture_pool: Pool(*mtl.Texture, 128) = undefined,

global_uniform_buffer: [MaxInFlightBuffers]*mtl.Buffer = undefined,

frame_semaphore: std.c.dispatch_semaphore_t = undefined,
current_frame_index: usize = 0,

quad_renderer: QuadRenderer(.batched) = undefined,

pub fn init(self: *Renderer, device: *mtl.Device) !void {
    self.device = device;
    self.library = try device.newDefaultLibrary();
    self.command_queue = try device.newCommandQueue();

    for (0..MaxInFlightBuffers) |i| {
        self.global_uniform_buffer[i] = try device.newBufferWithLength(MaxQuads * @sizeOf([16]f32));
    }

    self.frame_semaphore = dispatch_semaphore_create(@as(isize, MaxInFlightBuffers)).?;
    try self.quad_renderer.init(self);
}

pub fn drawQuads(
    self: *Renderer,
    camera: Camera,
    quadlist: []const Quad,
) !void {

    // Wait for the frame semaphore
    _ = dispatch_semaphore_wait(self.frame_semaphore, DISPATCH_TIME_FOREVER);

    // Increment frame index
    self.current_frame_index = (self.current_frame_index + 1) % @as(usize, MaxInFlightBuffers);
    var idx = self.current_frame_index;

    //// Update global data
    {
        var contents = self.global_uniform_buffer[idx].contents([16]f32);
        contents[0] = camera.matrix.data;
    }

    var command_buffer = try self.command_queue.commandBuffer();
    var render_pass_descriptor = try app.currentRenderPassDescriptor();
    var encoder = try command_buffer.renderCommandEncoderWithDescriptor(render_pass_descriptor);
    encoder.setVertexBuffer(self.global_uniform_buffer[idx], 0, BufferIndexGlobals);

    try self.quad_renderer.drawQuads(self, quadlist, encoder);

    var drawable = try app.currentDrawable();
    encoder.endEncoding();

    command_buffer.addCompletedHandler(Renderer, &commandBufferCompletedHandler, self);

    command_buffer.presentDrawable(drawable);
    command_buffer.commit();
}

pub fn commandBufferCompletedHandler(self: *Renderer, _: *mtl.CommandBuffer) void {
    _ = dispatch_semaphore_signal(self.frame_semaphore);
}

pub fn textureNew(self: *Renderer, width: usize, height: usize) !TextureHandle {
    var texture_desc = try mtl.TextureDescriptor.init2DDescriptorWithPixelFormat(mtl.PixelFormat.RGBA8Unorm, width, height, false);
    defer texture_desc.deinit();

    var handle = try self.texture_pool.alloc();

    var texture = try self.device.newTextureWithDescriptor(texture_desc);

    try self.texture_pool.set(handle, texture);

    return handle;
}

pub fn textureSetData(self: *Renderer, texture: TextureHandle) void {
    _ = texture;
    _ = self;
}

test {
    var r = Renderer{};
    _ = r;
}
