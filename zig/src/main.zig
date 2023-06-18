const std = @import("std");
const testing = std.testing;
const mtl = @import("metal.zig");

const Nemo = struct {
    device: mtl.Device = undefined,
    command_queue: mtl.CommandQueue = undefined,
    library: mtl.Library = undefined,
    buffer: mtl.Buffer = undefined,
    render_pipeline_state: mtl.RenderPipelineState = undefined,

    pub fn init(self: *Nemo) !void {
        self.device = try mtl.Device.init();
        std.log.info("device = {s}", .{self.device.name()});

        self.command_queue = try self.device.newCommandQueue();
        self.command_queue.setLabel("Main Command Queue");
        self.library = try self.device.newDefaultLibrary();
        // self.buffer = try self.device.newBufferWithLength(128);
        var data = [_]u8{ 1, 1, 1, 1 };
        self.buffer = try self.device.newBufferWithBytes(data[0..]);
        var contents = self.buffer.contents();
        std.log.info("contents = {any}", .{contents});

        var render_pipeline_desc = try mtl.RenderPipelineDescriptor.init();
        defer render_pipeline_desc.deinit();

        var vfunc = try self.library.newFunctionWithName("vertex_main");
        defer vfunc.deinit();

        var frag_func = try self.library.newFunctionWithName("frag_main");
        defer frag_func.deinit();

        render_pipeline_desc.setColorAttachmentPixelFormat(0, .RGBA8Unorm);
        render_pipeline_desc.setVertexFunction(&vfunc);
        render_pipeline_desc.setFragmentFunction(&frag_func);

        var vertex_desc = try mtl.VertexDescriptor.init();
        defer vertex_desc.deinit();

        vertex_desc.setAttributeFormat(0, .Float3);
        vertex_desc.setAttributeOffset(0, 0);
        vertex_desc.setAttributeBufferIndex(0, 0);
        vertex_desc.setLayoutStride(0, 3 * @sizeOf(f32));

        render_pipeline_desc.setVertexDescriptor(&vertex_desc);

        self.render_pipeline_state = try self.device.newRenderPipelineStateWithDescriptor(&render_pipeline_desc);
    }

    pub fn deinit(self: *Nemo) !void {
        self.device.deinit();
    }
};

var nemo = Nemo{};

export fn nemoInit() void {
    nemo.init() catch {
        @panic("nemoInit panic");
    };
}

export fn nemoDeinit() void {
    nemo.deinit() catch {
        @panic("nemoDeinit panic");
    };
}
