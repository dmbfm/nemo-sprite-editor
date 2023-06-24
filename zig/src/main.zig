const std = @import("std");
const testing = std.testing;
const mtl = @import("metal.zig");
const app = @import("app.zig");

const math = @import("math.zig");
const Vec3f = math.Vec3f;
const Mat4f = math.Mat4f;
const Camera = @import("Camera.zig");
const Quad = @import("Quad.zig");
const Renderer = @import("Renderer.zig");

const Nemo = struct {
    device: *mtl.Device = undefined,
    renderer: Renderer = .{},

    pub fn init(self: *Nemo) !void {
        self.device = try mtl.Device.init();
        try self.renderer.init(self.device);
    }

    pub fn frame(self: *Nemo) !void {
        app.setClearColor(mtl.ClearColor.init(1, 1, 1, 1));

        var camera = Camera.init(Vec3f.init(0, 0, 1), 10, 10, 0.1, 1000);
        camera.updateMatrix();

        var quad: Quad = Quad.init(Vec3f.init(0, 0, 0), 0.5, 0.5);
        quad.material = .solid_color;

        quad.color = .{ .r = 0.326, .g = 0.621, .b = 1, .a = 1 };

        var quads: []const Quad = &[1]Quad{quad};

        try self.renderer.drawQuads(camera, quads);

        //if (app.windowResized()) {
        //    std.log.info("REIsized!!!!!!!!!!!!!!!!!!!!!!!!!", .{});
        //}
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
