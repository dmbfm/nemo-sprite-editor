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
const Color = @import("Color.zig");
const rnd = @import("random.zig");

const Nemo = struct {
    device: *mtl.Device = undefined,
    renderer: Renderer = .{},

    texture: Renderer.TextureHandle = 0,

    quads: [10_000]Quad = undefined,

    pub fn init(self: *Nemo) !void {
        self.device = try mtl.Device.init();
        try self.renderer.init(self.device);
        self.texture = try self.renderer.textureNew(100, 100);

        // init quads
        for (&self.quads) |*quad| {
            quad.color = Color.random();
            var x: f32 = rnd.floatRange(f32, -10, 10);
            var y: f32 = rnd.floatRange(f32, -10, 10);
            var w: f32 = rnd.floatRange(f32, 0.1, 2);
            var h: f32 = rnd.floatRange(f32, 0.1, 2);
            quad.position = Vec3f.init(x, y, 0);
            quad.width = w;
            quad.height = h;
        }
    }

    pub fn updateQuads(self: *Nemo) void {
        for (&self.quads) |*quad| {
            var x: f32 = rnd.floatRange(f32, -10, 10);
            var y: f32 = rnd.floatRange(f32, -10, 10);
            var w: f32 = rnd.floatRange(f32, 0.1, 2);
            var h: f32 = rnd.floatRange(f32, 0.1, 2);
            quad.position = Vec3f.init(x, y, 0);
            quad.width = w;
            quad.height = h;
        }
    }

    pub fn frame(self: *Nemo) !void {
        app.setClearColor(mtl.ClearColor.init(1, 1, 1, 1));

        var camera = Camera.init(Vec3f.init(0, 0, 1), 10, 10, 0.1, 1000);
        camera.updateMatrix();

        //self.updateQuads();
        try self.renderer.drawQuads(camera, self.quads[0..]);

        //if (app.windowResized()) {
        //    std.log.info("REIsized!!!!!!!!!!!!!!!!!!!!!!!!!", .{});
        //}
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

export fn nemoFrame() void {
    nemo.frame() catch {
        @panic("nemoFrame");
    };
}
