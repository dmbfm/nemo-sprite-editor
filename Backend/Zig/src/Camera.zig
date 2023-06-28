const std = @import("std");
const math = @import("math.zig");
const Vec3f = math.Vec3f;
const Mat4f = math.Mat4f;
const Camera = @This();

position: Vec3f = .{ .x = 0, .y = 0, .z = 2 },
target: Vec3f = .{ .x = 0, .y = 0, .z = 0 },
up: Vec3f = Vec3f.axisY(),
width: f32 = 1,
height: f32 = 1,
near: f32 = 0.1,
far: f32 = 100,
view_matrix: Mat4f = Mat4f.identity,
proj_matrix: Mat4f = Mat4f.identity,
matrix: Mat4f = Mat4f.identity,

pub fn init(position: Vec3f, width: f32, height: f32, near: f32, far: f32) Camera {
    return .{
        .position = position,
        .width = width,
        .height = height,
        .near = near,
        .far = far,
    };
}

pub fn updateMatrix(self: *Camera) void {
    self.view_matrix = Mat4f.looAt(self.position, self.target, self.up);
    self.proj_matrix = Mat4f.ortho(self.width, self.height, self.near, self.far);
    self.matrix = self.proj_matrix.mul(self.view_matrix);
}

test {
    var c = Camera{};
    c.updateMatrix();
}
