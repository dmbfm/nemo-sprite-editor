const std = @import("std");
const testing = std.testing;
const mtl = @import("metal.zig");
const app = @import("app.zig");

const math = @import("math.zig");

const Quad = struct {
    position: math.Vec3f,
    width: f32,
    height: f32,
    texture: u32,
};

const QuadRenderer = struct {};

const Nemo = struct {
    device: *mtl.Device = undefined,
    command_queue: *mtl.CommandQueue = undefined,
    library: *mtl.Library = undefined,

    //buffer: mtl.Buffer = undefined,
    //render_pipeline_state: mtl.RenderPipelineState = undefined,

    pub fn init(self: *Nemo) !void {
        self.device = try mtl.Device.init();
        self.command_queue = try self.device.newCommandQueue();
        self.library = try self.device.newDefaultLibrary();
    }

    pub fn frame(self: *Nemo) !void {
        if (app.windowResized()) {
            std.log.info("REIsized!!!!!!!!!!!!!!!!!!!!!!!!!", .{});
        }

        var r: f64 = @intToFloat(f64, app.windowWith()) / 1080.0;

        app.setClearColor(mtl.ClearColor.init(r, 0, 0, 1));

        var command_buffer = try self.command_queue.commandBuffer();
        defer command_buffer.deinit();

        var render_pass_descriptor = try app.currentRenderPassDescriptor();

        var render_command_encoder = try command_buffer.renderCommandEncoderWithDescriptor(render_pass_descriptor);
        render_command_encoder.endEncoding();

        var drawable = app.currentDrawable() catch {
            std.log.info("No drawable available; skipping frame", .{});
            return;
        };
        command_buffer.presentDrawable(drawable);
        command_buffer.commit();
    }

    pub fn deinit(self: *Nemo) !void {
        self.device.deinit();
        self.command_queue.deinit();
        self.library.deinit();
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

export fn nemoFrame() void {
    nemo.frame() catch {
        @panic("nemoFrame");
    };
}
