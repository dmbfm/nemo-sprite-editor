const std = @import("std");
const Rgb = @import("Rgb.zig");

colors: [256 * 3]u8 = [_]u8{0} ** 3 * 256,
transparency: [256]bool = [_]bool{false} ** 256,

const Error = error{
    IndexOutOfRange,
    OutputBufferTooSmall,
};

const Palette = @This();

pub fn clone(self: *Palette) Palette {
    return .{
        .colors = self.colors,
        .transparency = self.transparency,
    };
}

pub inline fn set(self: *Palette, index: usize, r: u8, g: u8, b: u8) void {
    self.colors[3 * index] = r;
    self.colors[3 * index + 1] = g;
    self.colors[3 * index + 2] = b;
}

pub inline fn setRgb(self: *Palette, index: usize, value: *Rgb) void {
    self.set(index, value.r, value.g, value.b);
}

pub inline fn getRgb(self: *Palette, index: usize) ?Rgb {
    return Rgb.init(self.colors[3 * index], self.colors[3 * index + 1], self.colors[3 * index + 2]);
}

pub inline fn copy(self: *Palette, index: usize, dest: []u8) void {
    dest[0] = self.colors[3 * index];
    dest[1] = self.colors[3 * index + 1];
    dest[2] = self.colors[3 * index + 2];
}

pub inline fn setTransparency(self: *Palette, index: usize, transparent: bool) void {
    self.transparency[index] = transparent;
}

pub inline fn getTransparency(self: *Palette, index: usize) bool {
    return self.transparency[index];
}
