const std = @import("std");
const rnd = @import("random.zig");
const Color = @This();

r: f32 = 0,
g: f32 = 0,
b: f32 = 0,
a: f32 = 1,

pub fn init(r: f32, g: f32, b: f32, a: f32) Color {
    return .{ .r = r, .g = g, .b = b, .a = a };
}

pub fn random() Color {
    var r = rnd.float(f32);
    var g = rnd.float(f32);
    var b = rnd.float(f32);

    return Color.init(r, g, b, 1);
}
