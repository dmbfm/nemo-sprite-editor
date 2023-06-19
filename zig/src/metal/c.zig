const std = @import("std");

pub const MBBool = u8;

pub const NSRect = extern struct {
    x: f64 = 0,
    y: f64 = 0,
    w: f64 = 0,
    h: f64 = 0,
};

pub const ClearColor = extern struct {
    r: f64 = 0,
    g: f64 = 0,
    b: f64 = 0,
    a: f64 = 0,

    pub fn init(r: f64, g: f64, b: f64, a: f64) ClearColor {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};

pub const Device = extern struct {
    device: *anyopaque,
};

pub const CommandQueue = extern struct {
    queue: *anyopaque,
};

pub const Function = extern struct {
    function: *anyopaque,
};

pub const Library = extern struct {
    library: *anyopaque,
};

pub const Buffer = extern struct {
    buffer: *anyopaque,
};

pub const RenderPipelineState = extern struct {
    state: *anyopaque,
};

pub const RenderPipelineDescriptor = extern struct {
    desc: *anyopaque,
};

pub const VertexDescriptor = extern struct {
    desc: *anyopaque,
};

pub const CommandBuffer = extern struct {
    buffer: *anyopaque,
};

pub const RenderPassDescriptor = extern struct {
    desc: *anyopaque,
};

pub const RenderCommandEncoder = extern struct {
    encoder: *anyopaque,
};

pub const Texture = extern struct {
    texture: *anyopaque,
};

pub const TextureDescriptor = extern struct {
    desc: *anyopaque,
};

pub const Drawable = *anyopaque;

pub extern fn deviceInit(self: *Device) c_int;
pub extern fn deviceDeinit(self: *Device) void;
pub extern fn deviceGetName(self: *Device, out: [*c]u8, max_len: usize) c_int;
pub extern fn deviceNewCommandQueue(self: *Device, out: *CommandQueue) c_int;
pub extern fn deviceNewDefaultLibrary(self: *Device, out: *Library) c_int;
pub extern fn deviceNewBufferWithLength(self: *Device, length: usize, out: *Buffer) c_int;
pub extern fn deviceNewBufferWithBytes(self: *Device, bytes: *const anyopaque, length: usize, out: *Buffer) c_int;
pub extern fn deviceNewRenderPipelineStateWithDescriptor(self: *Device, desc: *RenderPipelineDescriptor, out: *RenderPipelineState) c_int;
pub extern fn deviceNewTextureWithDescriptor(self: *Device, desc: *TextureDescriptor, out: *Texture) c_int;

pub extern fn renderPipelineDescriptorInit(self: *RenderPipelineDescriptor) c_int;
pub extern fn renderPipelineDescriptorDenit(self: *RenderPipelineDescriptor) void;
pub extern fn renderPipelineDescriptorSetVertexFunction(self: *RenderPipelineDescriptor, val: *Function) void;
pub extern fn renderPipelineDescriptorSetFragmentFunction(desc: *RenderPipelineDescriptor, val: *Function) void;
pub extern fn renderPipelineDescriptorSetVertexDescriptor(desc: *RenderPipelineDescriptor, val: *VertexDescriptor) void;
pub extern fn renderPipelineDescriptorSetColorAttachmentPixelFormat(desc: *RenderPipelineDescriptor, index: c_int, format: u64) void;

pub extern fn vertexDescriptorInit(self: *VertexDescriptor) c_int;
pub extern fn vertexDescriptorDeinit(self: *VertexDescriptor) void;
pub extern fn vertexDescriptorAttributeFormat(self: *VertexDescriptor, index: c_int, format: u64) void;
pub extern fn vertexDescriptorAttributeOffset(self: *VertexDescriptor, index: c_int, offset: u64) void;
pub extern fn vertexDescriptorAttributeBufferIndex(self: *VertexDescriptor, index: c_int, buffer_index: u64) void;
pub extern fn vertexDescriptorLayoutStepFunction(self: *VertexDescriptor, index: c_int, step_function: u64) void;
pub extern fn vertexDescriptorLayoutStepRate(self: *VertexDescriptor, index: c_int, step_rate: u64) void;
pub extern fn vertexDescriptorLayoutStride(self: *VertexDescriptor, index: c_int, stride: u64) void;

pub extern fn libraryNewFunctionWithName(self: *Library, name: [*:0]const u8, out: *Function) c_int;
pub extern fn libraryDeinit(self: *Library) void;

pub extern fn functionDeinit(self: *Function) void;

pub extern fn bufferDeinit(self: *Buffer) void;
pub extern fn bufferContents(self: *Buffer) [*c]u8;
pub extern fn bufferLength(self: *Buffer) u64;

pub extern fn commandQueueDeinit(self: *CommandQueue) void;
pub extern fn commandQueueSetLabel(self: *CommandQueue, label: [*:0]const u8) void;
pub extern fn commandQueueCommandBuffer(self: *CommandQueue, out: *CommandBuffer) c_int;

pub extern fn renderPassDescriptorSetColorAttachmentClearColor(self: *RenderPassDescriptor, index: c_int, color: ClearColor) void;

pub extern fn commandBufferRenderCommandEncoderWithDescriptor(self: *CommandBuffer, desc: *RenderPassDescriptor, out: *RenderCommandEncoder) c_int;
pub extern fn commandBufferCommit(self: *CommandBuffer) void;
pub extern fn commandBufferPresentDrawable(self: *CommandBuffer, drawable: *Drawable) void;

pub extern fn renderCommandEncoderDeinit(self: *RenderCommandEncoder) void;
pub extern fn renderCommandEncoderSetLabel(self: *RenderCommandEncoder, label: [*:0]const u8) void;
pub extern fn renderCommandEncoderSetRenderPipelineState(self: *RenderCommandEncoder, state: *RenderPipelineState) void;
pub extern fn renderCommandEncoderSetVertexBuffer(self: *RenderCommandEncoder, buffer: *Buffer, offset: u64, index: u64) void;
pub extern fn renderCommandEncoderSetVertexBytes(self: *RenderCommandEncoder, bytes: [*c]const u8, length: u64, index: u64) void;
pub extern fn renderCommandEncoderSetFragmentBuffer(self: *RenderCommandEncoder, buffer: *Buffer, offset: u64, index: u64) void;
pub extern fn renderCommandEncoderSetFragmentBytes(self: *RenderCommandEncoder, bytes: [*c]const u8, length: u64, index: u64) void;
pub extern fn renderCommandEncoderDrawPrimitives(self: *RenderCommandEncoder, primitive_type: u64, start: u64, count: u64) void;
pub extern fn renderCommandEncoderDrawIndexedPrimitives(self: *RenderCommandEncoder, primitive_type: u64, index: u64, count: u64, index_type: u64, index_buffer: *Buffer, index_buffer_offset: u64) void;
pub extern fn renderCommandEncoderSetFragmentTexture(self: *RenderCommandEncoder, texture: Texture, index: u64) void;
pub extern fn renderCommandEncoderEndEncoding(self: *RenderCommandEncoder) void;

pub extern fn textureDescriptorInit(self: *TextureDescriptor) c_int;
pub extern fn textureDescriptorInit2DWithPixelFormat(self: *TextureDescriptor, format: u64, width: u64, height: u64, mipmapped: MBBool) c_int;
pub extern fn textureDescriptorDeinit(self: *TextureDescriptor) void;

pub extern fn textureDeinit(self: *Texture) void;

pub const MBOK: c_int = 0;
pub const MBERR: c_int = 1;
