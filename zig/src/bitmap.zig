const std = @import("std");
const Palette = @import("Palette.zig");

data: []u8 = undefined,
width: usize,
height: usize,
allocator: std.mem.Allocator,

const Error = error{
    TextureOutputBufferTooSmall,
};

const Bitmap = @This();

pub fn init(allocator: std.mem.Allocator, width: usize, height: usize) !Bitmap {
    var data = try allocator.alloc(u8, width * height);

    return Bitmap{
        .data = data,
        .allocator = allocator,
        .width = width,
        .height = height,
    };
}

pub inline fn validCoordinates(self: Bitmap, x: usize, y: usize) bool {
    comptime {
        return (x < self.width and y < self.height);
    }
}

pub fn setPixel(self: *Bitmap, x: usize, y: usize, value: u8) void {
    if (self.validCoordinates(x, y)) {
        self.data[y * self.width + x] = value;
    }
}

pub fn getPixel(self: *Bitmap, x: usize, y: usize) ?u8 {
    if (self.validCoordinates(x, y)) {
        return self.data[y * self.width + x];
    }
}

pub fn textureData(self: *Bitmap, pal: *const Palette, output: []u8) Error!void {
    if (output.len < self.width * self.height) {
        return Error.TextureOutputBufferTooSmall;
    }

    for (0..(self.width * self.height)) |i| {
        pal.copy(self.data[i], output[(4 * i)..(i + 3)]);

        // TODO: parameter for blending actions here?
        output[4 * i + 3] = if (pal.getTransparency(self.data[i]))
            0
        else
            255;
    }
}

pub fn deinit(self: *Bitmap) void {
    self.allocator.free(self.data);
}
