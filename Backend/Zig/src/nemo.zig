const std = @import("std");
const mtl = @import("metal.zig");
const Window = @import("window.zig").Window;

const Self = @This();

window: *Window = undefined,
device: *mtl.Device = undefined,

pub fn init(self: *Self, window: *Window) !void {
    self.window = window;
    self.device = try mtl.Device.init();
}

pub fn deinit(self: *Self) void {
    self.device.deinit();
}

pub fn getMetalDevice(self: *Self) *mtl.Device {
    return self.device;
}

pub fn frame(self: *Self) !void {
    _ = self;
}

test {}
