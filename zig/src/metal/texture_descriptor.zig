const enums = @import("enums.zig");

pub const TextureDescriptor = opaque {
    const Self = @This();

    const Error = error{
        NewTextureDescriptorError,
    };

    extern fn release(self: *Self) void;
    extern fn TextureDescriptor_init() ?*Self;
    extern fn TextureDescriptor_texture2DDescriptorWithPixelFormat(format: u64, width: u64, height: u64, mipmapped: u8) ?*Self;
    extern fn TextureDescriptor_setWidth(self: *Self, value: u64) void;
    extern fn TextureDescriptor_setHeight(self: *Self, value: u64) void;
    extern fn TextureDescriptor_setMipmapLevelCount(self: *Self, value: u64) void;
    extern fn TextureDescriptor_setCpuCacheMode(self: *Self, value: u64) void;
    extern fn TextureDescriptor_setStorageMode(self: *Self, value: u64) void;

    pub fn init() Error!*Self {
        var result = TextureDescriptor_init();
        if (result == null) {
            return Error.NewTextureDescriptorError;
        }
        return result.?;
    }

    pub fn init2DDescriptorWithPixelFormat(pixel_format: enums.PixelFormat, width: usize, height: usize, mipmapped: bool) Error!*Self {
        var result = TextureDescriptor_texture2DDescriptorWithPixelFormat(
            @enumToInt(pixel_format),
            @intCast(u64, width),
            @intCast(u64, height),
            @intCast(u8, @boolToInt(mipmapped)),
        );
        if (result == null) {
            return Error.NewTextureDescriptorError;
        }
        return result.?;
    }

    pub fn setWidth(self: *Self, width: usize) void {
        TextureDescriptor_setWidth(self, @intCast(u64, width));
    }

    pub fn setHeight(self: *Self, height: usize) void {
        TextureDescriptor_setHeight(self, @intCast(u64, height));
    }

    pub fn setMipmapLevelCount(self: *Self, value: usize) void {
        TextureDescriptor_setMipmapLevelCount(self, @intCast(u64, value));
    }

    pub fn setCpuCacheMode(self: *Self, value: enums.CPUCacheMode) void {
        TextureDescriptor_setCpuCacheMode(self, @enumToInt(value));
    }

    pub fn setStorageMode(self: *Self, value: enums.StorageMode) void {
        TextureDescriptor_setStorageMode(self, @enumToInt(value));
    }
};
