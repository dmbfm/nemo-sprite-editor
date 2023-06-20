const TextureDescriptor = @import("texture_descriptor.zig").TextureDescriptor;
const Texture = @import("texture.zig").Texture;
const CommandQueue = @import("command_queue.zig").CommandQueue;
const Library = @import("library.zig").Library;
const Buffer = @import("buffer.zig").Buffer;
const RenderPipelineDescriptor = @import("render_pipeline_descriptor.zig").RenderPipelineDescriptor;
const RenderPipelineState = @import("render_pipeline_state.zig").RenderPipelineState;

pub const Device = opaque {
    const Error = error{
        DeviceInitError,
        NewTextureError,
        NewCommandQueue,
        NewDefaultLibrary,
        NewBuffer,
        NewRenderPipelineState,
    };

    extern fn release(self: *Device) void;
    extern fn Device_init() ?*Device;
    extern fn Device_newCommandQueue(self: *Device) ?*CommandQueue;
    extern fn Device_newDefaultLibrary(self: *Device) ?*Library;
    extern fn Device_newBufferWithLength(self: *Device, length: usize) ?*Buffer;
    extern fn Device_newBufferWithBytes(self: *Device, bytes: [*c]const u8, length: usize) ?*Buffer;
    extern fn Device_newRenderPipelineStateWithDescriptor(self: Device, desc: *RenderPipelineDescriptor) ?*RenderPipelineState;
    extern fn Device_getName(self: *Device, out: [*c]u8, max_len: usize) c_int;
    extern fn Device_newTextureWithDescriptor(self: *Device, desc: *TextureDescriptor) ?*Texture;

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

    pub fn newDefaultLibrary(self: *Device) Error!*Library {
        var result = Device_newDefaultLibrary(self);
        if (result == null) {
            return Error.NewDefaultLibrary;
        }
        return result.?;
    }

    pub fn newBufferWithLength(self: *Device, length: usize) Error!*Buffer {
        var result = Device_newBufferWithLength(self, length);
        if (result == null) {
            return Error.NewBuffer;
        }
        return result.?;
    }

    pub fn newBufferWithBytes(self: *Device, bytes: []const u8) Error!*Buffer {
        var result = Device_newBufferWithBytes(self, bytes.ptr, bytes.len);
        if (result == null) {
            return Error.NewBuffer;
        }
        return result.?;
    }

    pub fn newRenderPipelineStateWithDescriptor(self: *Device, desc: *RenderPipelineDescriptor) Error!*RenderPipelineState {
        var result = Device_newRenderPipelineStateWithDescriptor(self, desc);
        if (result == null) {
            return Error.NewRenderPipelineState;
        }
        return result.?;
    }

    pub fn newTextureWithDescriptor(self: *Device, desc: *TextureDescriptor) Error!*Texture {
        var tex = Device_newTextureWithDescriptor(self, desc);
        if (tex == null) {
            return Error.NewTextureError;
        }
        return tex.?;
    }
};
