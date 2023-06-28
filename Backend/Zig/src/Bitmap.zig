const std = @import("std");
const Palette = @import("Palette.zig");
const random = @import("random.zig");

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

pub fn writeP3(self: *const Bitmap, writer: anytype) !void {
    _ = writer;
    _ = self;
    // TODO: Implement this
}

pub fn randomize(self: *Bitmap, max_index: u8) void {
    for (self.data, 0..) |_, i| {
        self.data[i] = random.intRange(u8, 0, max_index);
    }
}

pub fn deinit(self: *Bitmap) void {
    self.allocator.free(self.data);
}

test {
    var allocator = std.testing.allocator;
    var b = try Bitmap.init(allocator, 100, 100);
    defer b.deinit();
    b.randomize(255);
    // std.log.warn(" {any} ", .{b.data});
}
