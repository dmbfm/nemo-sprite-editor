const std = @import("std");
const Color = @This();

r: f32 = 0,
g: f32 = 0,
b: f32 = 0,
a: f32 = 1,

pub fn init(r: f32, g: f32, b: f32, a: f32) Color {
    return .{ .r = r, .g = g, .b = b, .a = a };
}
