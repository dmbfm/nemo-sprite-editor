const std = @import("std");
const testing = std.testing;
const mtl = @import("metal.zig");

const ViewContext = @import("view_context.zig").ViewContext;

const Nemo = struct {
    device: *mtl.Device = undefined,
    command_queue: *mtl.CommandQueue = undefined,
    //library: mtl.Library = undefined,
    //buffer: mtl.Buffer = undefined,
    //render_pipeline_state: mtl.RenderPipelineState = undefined,

    pub fn init(self: *Nemo) !void {
        self.device = try mtl.Device.init();
        self.command_queue = try self.device.newCommandQueue();
    }

    pub fn frame(self: *Nemo, ctx: *ViewContext) !void {
        ctx.setClearColor(mtl.ClearColor.init(1, 0, 0, 1));

        var command_buffer = try self.command_queue.commandBuffer();
        defer command_buffer.deinit();

        var render_pass_descriptor = try ctx.currentRenderPassDescriptor();

        var render_command_encoder = try command_buffer.renderCommandEncoderWithDescriptor(render_pass_descriptor);
        render_command_encoder.endEncoding();

        var drawable = try ctx.currentDrawable();
        command_buffer.presentDrawable(drawable);
        command_buffer.commit();
    }

    pub fn deinit(self: *Nemo) !void {
        self.device.deinit();
    }

    pub fn metalDevice(self: *Nemo) ?*mtl.Device {
        return self.device;
    }
};

var nemo = Nemo{};

export fn nemoMetalDevice() ?*mtl.Device {
    return nemo.metalDevice();
}

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

export fn nemoFrame(ctx: *ViewContext) void {
    nemo.frame(ctx) catch {
        @panic("nemoFrame");
    };
}
