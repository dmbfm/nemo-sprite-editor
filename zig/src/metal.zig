const std = @import("std");
const c = @import("metal/c.zig");

pub const Error = error{
    DeviceInitError,
    NewCommandQueueError,
    NewDefaultLibraryError,
    NewBufferError,
    NewRenderPipelineState,
    NewRenderPipelineDescriptor,
    NewFunction,
    NewVertexDescriptor,
    NewCommandBuffer,
    NewRenderCommandEncoder,
};

pub const VertexStepFunction = enum(u64) {
    constant = 0,
    per_vertex = 1,
    per_instance = 2,
    //MTLVertexStepFunctionPerPatch API_AVAILABLE(macos(10.12), ios(10.0)) = 3,
    //MTLVertexStepFunctionPerPatchControlPoint API_AVAILABLE(macos(10.12), ios(10.0)) = 4,
};
pub const VertexFormat = enum(u64) {
    Invalid = 0,
    UChar2 = 1,
    UChar3 = 2,
    UChar4 = 3,
    Char2 = 4,
    Char3 = 5,
    Char4 = 6,
    UChar2Normalized = 7,
    UChar3Normalized = 8,
    UChar4Normalized = 9,
    Char2Normalized = 10,
    Char3Normalized = 11,
    Char4Normalized = 12,
    UShort2 = 13,
    UShort3 = 14,
    UShort4 = 15,
    Short2 = 16,
    Short3 = 17,
    Short4 = 18,
    UShort2Normalized = 19,
    UShort3Normalized = 20,
    UShort4Normalized = 21,
    Short2Normalized = 22,
    Short3Normalized = 23,
    Short4Normalized = 24,
    Half2 = 25,
    Half3 = 26,
    Half4 = 27,
    Float = 28,
    Float2 = 29,
    Float3 = 30,
    Float4 = 31,
    Int = 32,
    Int2 = 33,
    Int3 = 34,
    Int4 = 35,
    UInt = 36,
    UInt2 = 37,
    UInt3 = 38,
    UInt4 = 39,
};

// NOTE: not complete!
pub const PixelFormat = enum(u64) {
    Invalid = 0,
    A8Unorm = 1,
    R8Unorm = 10,
    R8Unorm_sRGB = 11,
    R8Snorm = 12,
    R8Uint = 13,
    R8Sint = 14,
    R16Unorm = 20,
    R16Snorm = 22,
    R16Uint = 23,
    R16Sint = 24,
    R16Float = 25,
    RG8Unorm = 30,
    RG8Unorm_sRGB = 31,
    RG8Snorm = 32,
    RG8Uint = 33,
    RG8Sint = 34,
    R32Uint = 53,
    R32Sint = 54,
    R32Float = 55,
    RG16Unorm = 60,
    RG16Snorm = 62,
    RG16Uint = 63,
    RG16Sint = 64,
    RG16Float = 65,
    RGBA8Unorm = 70,
    RGBA8Unorm_sRGB = 71,
    RGBA8Snorm = 72,
    RGBA8Uint = 73,
    RGBA8Sint = 74,
    BGRA8Unorm = 80,
    BGRA8Unorm_sRGB = 81,
    RGB10A2Unorm = 90,
    RGB10A2Uint = 91,
    RG11B10Float = 92,
    RGB9E5Float = 93,
    RG32Uint = 103,
    RG32Sint = 104,
    RG32Float = 105,
    RGBA16Unorm = 110,
    RGBA16Snorm = 112,
    RGBA16Uint = 113,
    RGBA16Sint = 114,
    RGBA16Float = 115,
    RGBA32Uint = 123,
    RGBA32Sint = 124,
    RGBA32Float = 125,
};

pub const PrimitiveType = enum(u64) {
    point = 0,
    line = 1,
    line_strip = 2,
    triangle = 3,
    triangle_strip = 4,
};

pub const ClearColor = c.ClearColor;

pub const Device = struct {
    device: c.Device = undefined,
    name_buf: [512]u8 = undefined,
    name_len: usize = 0,

    pub fn init() !Device {
        var self: Device = .{};

        if (c.deviceInit(&self.device) != c.MBOK) {
            return Error.DeviceInitError;
        }

        self.name_len = @intCast(usize, c.deviceGetName(&self.device, &self.name_buf[0], self.name_buf.len));

        return self;
    }

    pub fn deinit(self: *Device) void {
        c.deviceDeinit(&self.device);
    }

    pub fn name(self: *Device) []const u8 {
        return self.name_buf[0..self.name_len];
    }

    pub fn newCommandQueue(self: *Device) Error!CommandQueue {
        var command_queue = CommandQueue{};

        if (c.deviceNewCommandQueue(&self.device, &command_queue.queue) != c.MBOK) {
            return Error.NewCommandQueueError;
        }

        return command_queue;
    }

    pub fn newDefaultLibrary(self: *Device) Error!Library {
        var library = Library{};

        if (c.deviceNewDefaultLibrary(&self.device, &library.library) != c.MBOK) {
            return Error.NewDefaultLibraryError;
        }

        return library;
    }

    pub fn newBufferWithLength(self: *Device, length: usize) Error!Buffer {
        var buffer = Buffer{};

        if (c.deviceNewBufferWithLength(&self.device, length, &buffer.buffer) != c.MBOK) {
            return Error.NewBufferError;
        }

        return buffer;
    }

    pub fn newBufferWithBytes(self: *Device, bytes: []const u8) Error!Buffer {
        var buffer = Buffer{};

        if (c.deviceNewBufferWithBytes(&self.device, @ptrCast(*const anyopaque, bytes.ptr), bytes.len, &buffer.buffer) != c.MBOK) {
            return Error.NewBufferError;
        }

        return buffer;
    }

    pub fn newRenderPipelineStateWithDescriptor(self: *Device, desc: *RenderPipelineDescriptor) Error!RenderPipelineState {
        var state = RenderPipelineState{};

        if (c.deviceNewRenderPipelineStateWithDescriptor(&self.device, &desc.desc, &state.state) != c.MBOK) {
            return Error.NewRenderPipelineState;
        }

        return state;
    }
};

pub const Drawable = struct {
    drawable: c.Drawable = undefined,
};

pub const CommandBuffer = struct {
    buffer: c.CommandBuffer = undefined,

    pub fn renderCommandEncoderWithDescriptor(self: *CommandBuffer, desc: *RenderPassDescriptor) Error!RenderCommandEncoder {
        var encoder = RenderCommandEncoder{};

        if (c.commandBufferRenderCommandEncoderWithDescriptor(&self.buffer, &desc.desc, &encoder.enc) != c.MBOK) {
            return Error.NewRenderCommandEncoder;
        }

        return encoder;
    }

    pub fn commit(self: *CommandBuffer) void {
        c.commandBufferCommit(&self.buffer);
    }

    pub fn presentDrawable(self: *CommandBuffer, drawable: Drawable) void {
        c.commandBufferPresentDrawable(&self.buffer, drawable.drawable);
    }
};

pub const CommandQueue = struct {
    queue: c.CommandQueue = undefined,

    pub fn deinit(self: *CommandQueue) void {
        c.commandQueueDeinit(&self.queue);
    }

    pub fn setLabel(self: *CommandQueue, label: [:0]const u8) void {
        c.commandQueueSetLabel(&self.queue, label.ptr);
    }

    pub fn commandBuffer(self: *CommandQueue) Error!CommandBuffer {
        var buffer = CommandBuffer{};

        if (c.commandQueueCommandBuffer(&self.queue, &buffer.buffer) != c.MBOK) {
            return Error.NewCommandBuffer;
        }

        return buffer;
    }
};

pub const Library = struct {
    library: c.Library = undefined,

    pub fn deinit(self: *Library) void {
        c.libraryDeinit(&self.library);
    }

    pub fn newFunctionWithName(self: *Library, name: [:0]const u8) Error!Function {
        var f = Function{};

        if (c.libraryNewFunctionWithName(&self.library, @ptrCast([*c]const u8, name), &f.function) != c.MBOK) {
            return Error.NewFunction;
        }

        return f;
    }
};

pub const Function = struct {
    function: c.Function = undefined,

    pub fn deinit(self: *Function) void {
        c.functionDeinit(&self.function);
    }
};

pub const Buffer = struct {
    buffer: c.Buffer = undefined,

    pub fn deinit(self: *Buffer) void {
        c.bufferDeinit(&self.buffer);
    }

    pub fn contents(self: *Buffer) []u8 {
        var ptr = c.bufferContents(&self.buffer);
        var len = c.bufferLength(&self.buffer);

        var slice: []u8 = undefined;
        slice.ptr = ptr;
        slice.len = len;
        return slice;
    }
};

pub const RenderPipelineState = struct {
    state: c.RenderPipelineState = undefined,
};

pub const VertexDescriptor = struct {
    desc: c.VertexDescriptor = undefined,

    pub fn init() Error!VertexDescriptor {
        var self = VertexDescriptor{};

        if (c.vertexDescriptorInit(&self.desc) != c.MBOK) {
            return Error.NewFunction;
        }

        return self;
    }

    pub fn deinit(self: *VertexDescriptor) void {
        c.vertexDescriptorDeinit(&self.desc);
    }

    pub fn setAttributeFormat(self: *VertexDescriptor, index: usize, format: VertexFormat) void {
        c.vertexDescriptorAttributeFormat(
            &self.desc,
            @intCast(c_int, index),
            @enumToInt(format),
        );
    }

    pub fn setAttributeOffset(self: *VertexDescriptor, index: usize, offset: u64) void {
        c.vertexDescriptorAttributeOffset(
            &self.desc,
            @intCast(c_int, index),
            offset,
        );
    }

    pub fn setAttributeBufferIndex(self: *VertexDescriptor, index: usize, buffer_index: u64) void {
        c.vertexDescriptorAttributeBufferIndex(
            &self.desc,
            @intCast(c_int, index),
            buffer_index,
        );
    }

    pub fn setLayoutStride(self: *VertexDescriptor, index: usize, value: u64) void {
        c.vertexDescriptorLayoutStride(&self.desc, @intCast(c_int, index), value);
    }

    pub fn setLayoutStepRate(self: *VertexDescriptor, index: usize, value: u64) void {
        c.vertexDescriptorLayoutStepRate(&self.desc, @intCast(c_int, index), value);
    }

    pub fn setLayoutStepFunction(self: *VertexDescriptor, index: usize, value: VertexStepFunction) void {
        c.vertexDescriptorLayoutStepFunction(&self.desc, @intCast(c_int, index), @enumToInt(value));
    }
};

pub const RenderPipelineDescriptor = struct {
    desc: c.RenderPipelineDescriptor = undefined,

    pub fn init() Error!RenderPipelineDescriptor {
        var self = RenderPipelineDescriptor{};

        if (c.renderPipelineDescriptorInit(&self.desc) != c.MBOK) {
            return Error.NewRenderPipelineDescriptor;
        }

        return self;
    }

    pub fn deinit(self: *RenderPipelineDescriptor) void {
        c.renderPipelineDescriptorDenit(&self.desc);
    }

    pub fn setVertexFunction(self: *RenderPipelineDescriptor, func: *Function) void {
        c.renderPipelineDescriptorSetVertexFunction(&self.desc, &func.function);
    }

    pub fn setFragmentFunction(self: *RenderPipelineDescriptor, func: *Function) void {
        c.renderPipelineDescriptorSetFragmentFunction(&self.desc, &func.function);
    }

    pub fn setColorAttachmentPixelFormat(self: *RenderPipelineDescriptor, index: usize, format: PixelFormat) void {
        c.renderPipelineDescriptorSetColorAttachmentPixelFormat(&self.desc, @intCast(c_int, index), @enumToInt(format));
    }

    pub fn setVertexDescriptor(self: *RenderPipelineDescriptor, desc: *VertexDescriptor) void {
        c.renderPipelineDescriptorSetVertexDescriptor(&self.desc, &desc.desc);
    }
};

pub const RenderPassDescriptor = struct {
    desc: c.RenderPassDescriptor = undefined,

    pub fn setColorAttachmentClearColor(self: *RenderPassDescriptor, index: usize, color: ClearColor) void {
        c.renderPassDescriptorSetColorAttachmentClearColor(&self.desc, @intCast(c_int, index), color);
    }
};

pub const IndexType = enum(u64) {
    uint16 = 0,
    uint32 = 1,
};

pub const RenderCommandEncoder = struct {
    enc: c.RenderCommandEncoder = undefined,

    const Self = @This();

    pub fn deinit(self: *Self) void {
        c.renderCommandEncoderDeinit(&self.enc);
    }

    pub fn setLabel(self: *Self, label: [:0]const u8) void {
        c.renderCommandEncoderSetLabel(&self.enc, label.ptr);
    }

    pub fn setRenderPipelineState(self: *Self, pipeline_state: *RenderPipelineState) void {
        c.renderCommandEncoderSetRenderPipelineState(&self.enc, &pipeline_state.state);
    }

    pub fn setVertexBuffer(self: *Self, buffer: *Buffer, offset: usize, index: usize) void {
        c.renderCommandEncoderSetVertexBuffer(&self.enc, &buffer.buffer, @intCast(u64, offset), @intCast(u64, index));
    }

    pub fn setVertexBytes(self: *Self, bytes: []const u8, length: usize, index: usize) void {
        c.renderCommandEncoderSetVertexBytes(&self.enc, bytes.ptr, @intCast(u64, length), @intCast(u64, index));
    }

    pub fn setFragmentBuffer(self: *Self, buffer: *Buffer, offset: usize, index: usize) void {
        c.renderCommandEncoderSetFragmentBuffer(&self.enc, &buffer.buffer, @intCast(u64, offset), @intCast(u64, index));
    }

    pub fn setFragmentBytes(self: *Self, bytes: []const u8, length: usize, index: usize) void {
        c.renderCommandEncoderSetFragmentVertexBytes(&self.enc, bytes.ptr, @intCast(u64, length), @intCast(u64, index));
    }

    pub fn drawPrimitives(self: *Self, primitive_type: PrimitiveType, start: usize, count: usize) void {
        c.renderCommandEncoderDrawPrimitives(&self.enc, @enumToInt(primitive_type), @intCast(u64, start), @intCast(u64, count));
    }

    pub fn drawIndexedPrimitives(self: *Self, primitive_type: PrimitiveType, index: usize, count: usize, index_type: IndexType, index_buffer: *Buffer, index_buffer_offset: usize) void {
        c.renderCommandEncoderDrawIndexedPrimitives(
            &self.enc,
            @enumToInt(primitive_type),
            @intCast(u64, index),
            @intCast(u64, count),
            @enumToInt(index_type),
            &index_buffer.buffer,
            @intCast(u64, index_buffer_offset),
        );
    }

    pub fn setFragmentTexture(self: *Self, texture: *Texture, index: usize) void {
        c.renderCommandEncoderSetFragmentTexture(&self.enc, texture.texture, @intCast(u64, index));
    }

    pub fn endEncoding(self: *Self) void {
        c.renderCommandEncoderEndEncoding(&self.enc);
    }
};

pub const Texture = struct {
    texture: c.Texture = undefined,
};
