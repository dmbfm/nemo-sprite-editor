const std = @import("std");
const math = @import("math.zig");
const Vec3f = math.Vec3f;
const Color = @import("Color.zig");
const Quad = @This();

position: Vec3f = .{},
width: f32 = 1,
height: f32 = 1,
material: MaterialType = .solid_color,
color: Color = .{},
texture: u32 = 0,

pub const MaterialType = enum {
    solid_color,
    textured,
};

pub fn init(position: Vec3f, width: f32, height: f32) Quad {
    return .{
        .position = position,
        .width = width,
        .height = height,
    };
}

pub fn initXYZ(x: f32, y: f32, z: f32, width: f32, height: f32) Quad {
    return .{
        .position = .{ .x = x, .y = y, .z = z },
        .width = width,
        .height = height,
    };
}

test {
    var q = Quad{};
    _ = q;
}
