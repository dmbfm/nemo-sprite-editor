const std = @import("std");

r: u8,
g: u8,
b: u8,

const Self = @This();

pub fn init(r: u8, g: u8, b: u8) Self {
    return .{ .r = r, .g = g, .b = b };
}
