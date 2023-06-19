const TextureDescriptor = @import("texture_descriptor.zig").TextureDescriptor;
const Texture = @import("texture.zig").Texture;
const CommandQueue = @import("command_queue.zig").CommandQueue;

pub const Device = opaque {
    const Error = error{
        DeviceInitError,
        NewTextureError,
        NewCommandQueue,
    };

    extern fn Device_init() ?*Device;
    extern fn release(self: *Device) void;
    extern fn Device_getName(self: *Device, out: [*c]u8, max_len: usize) c_int;
    extern fn Device_newTextureWithDescriptor(self: *Device, desc: *TextureDescriptor) ?*Texture;
    extern fn Device_newCommandQueue(self: *Device) ?*CommandQueue;

    pub fn init() Error!*Device {
        var device = Device_init();

        if (device == null) {
            return Error.DeviceInitError;
        }

        return device.?;
    }

    pub fn deinit(self: *Device) void {
        release(self);
    }

    pub fn name(self: *Device, buffer: []u8) []u8 {
        var len = Device_getName(self, buffer.ptr, buffer.len);
        return buffer[0..@intCast(usize, len)];
    }

    pub fn newCommandQueue(self: *Device) Error!*CommandQueue {
        var queue = Device_newCommandQueue(self);

        if (queue == null) {
            return Error.NewCommandQueue;
        }

        return queue.?;
    }

    pub fn newTextureWithDescriptor(self: *Device, desc: *TextureDescriptor) Error!*Texture {
        var tex = Device_newTextureWithDescriptor(self, desc);
        if (tex == null) {
            return Error.NewTextureError;
        }
        return tex.?;
    }

    // extern fn deviceNewCommandQueue(self: *Device, out: *CommandQueue) c_int;
    // extern fn deviceNewDefaultLibrary(self: *Device, out: *Library) c_int;
    // extern fn deviceNewBufferWithLength(self: *Device, length: usize, out: *Buffer) c_int;
    // extern fn deviceNewBufferWithBytes(self: *Device, bytes: *const anyopaque, length: usize, out: *Buffer) c_int;
    // extern fn deviceNewRenderPipelineStateWithDescriptor(self: *Device, desc: *RenderPipelineDescriptor, out: *RenderPipelineState) c_int;
    // extern fn deviceNewTextureWithDescriptor(self: *Device, desc: *TextureDescriptor, out: *Texture) c_int;
};
