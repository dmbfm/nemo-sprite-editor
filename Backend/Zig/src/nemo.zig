const std = @import("std");
const mtl = @import("metal.zig");
const Window = @import("window.zig").Window;

const Self = @This();

window: *Window = undefined,
device: ?*mtl.Device = null,

pub fn init(self: *Self, window: *Window) !void {
    self.window = window;
    self.device = try mtl.Device.init();
}

pub fn deinit(self: *Self) void {
    if (self.device != null) {
        self.device.?.deinit();
    }
}

pub fn getMetalDevice(self: *Self) ?*mtl.Device {
    var name_buf: [64]u8 = undefined;
    var name = self.device.?.name(&name_buf);
    std.log.info("=======\n name = {s} \n ========\n", .{name});
    return self.device;
}

pub fn frame(self: *Self) !void {
    _ = self;
}

test {}
