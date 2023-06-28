const PixelFormat = @import("enums.zig").PixelFormat;
const Region = @import("structs.zig").Region;

pub const Texture = opaque {
    const Error = error{
        NewTextureWithFormatError,
    };

    extern fn release(self: *Texture) void;
    extern fn Texture_replaceRegion(self: *Texture, region: Region, mipmap_level: u64, bytes: [*c]const u8, bytes_per_row: u64) void;
    extern fn Texture_replaceRegionSlice(self: *Texture, region: Region, mipmap_level: u64, slice: u64, bytes: [*c]const u8, bytes_per_row: u64, bytes_per_image: u64) void;
    extern fn Texture_getBytes(self: *Texture, out: [*c]u8, bytes_per_row: u64, region: Region, mipmap_level: u64) void;
    extern fn Texture_getBytesSlice(self: *Texture, out: [*c]u8, bytes_per_row: u64, bytes_per_image: u64, region: Region, mipmap_level: u64, slice: u64) void;
    extern fn Texture_newTextureWithFormat(self: *Texture, format: u64) ?*Texture;
    extern fn Texture_width(self: *Texture) u64;
    extern fn Texture_height(self: *Texture) u64;

    pub fn deinit(self: *Texture) void {
        release(self);
    }

    pub fn replaceRegion(self: *Texture, region: Region, mipmap_level: u64, bytes: []const u8, bytes_per_row: usize) void {
        Texture_replaceRegion(self, region, mipmap_level, bytes.ptr, @intCast(u64, bytes_per_row));
    }

    pub fn replaceRegionSlice(self: *Texture, region: Region, mipmap_level: u64, bytes: []const u8, bytes_per_row: usize, bytes_per_image: usize) void {
        Texture_replaceRegionSlice(self, region, mipmap_level, bytes.ptr, @intCast(u64, bytes_per_row), @intCast(u64, bytes_per_image));
    }

    pub fn getBytes(self: *Texture, out_buffer: []u8, bytes_per_row: usize, region: Region, mipmap_level: u64) void {
        Texture_getBytes(self, out_buffer.ptr, @intCast(u64, bytes_per_row), region, mipmap_level);
    }

    pub fn newTextureWithFormat(self: *Texture, format: PixelFormat) Error!*Texture {
        var result = Texture_newTextureWithFormat(self, format);
        if (result == null) {
            return Error.NewTextureWithFormatError;
        }
        return result.?;
    }

    pub fn width(self: *Texture) usize {
        return @intCast(usize, Texture_width(self));
    }

    pub fn height(self: *Texture) usize {
        return @intCast(usize, Texture_height(self));
    }
};
