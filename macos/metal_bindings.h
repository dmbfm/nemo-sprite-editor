//
//  metal_bindings.h
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#ifndef metal_bindings_h
#define metal_bindings_h

#import <Metal/Metal.h>

/*******************************************************************************
 * Defines
 ******************************************************************************/

#define MB_OK  0
#define MB_ERR 1
#define MB_MAX_VERTEX_ATTRIBUTES 31
#define MB_MAX_ARG_BUFFERS 31
#define MB_MAX_RENDER_TARGETS 8

typedef uint8_t MBBool;

#define MB_TRUE   ((MBBool) 1) 
#define MB_FALSE  ((MBBool) 0)

/*******************************************************************************
 * Struct definitions
 ******************************************************************************/

typedef struct TextureDescriptor {
    MTLTextureDescriptor *desc;
} TextureDescriptor;

typedef struct Drawable {
    id<MTLDrawable> drawable;
} Drawable;

typedef struct Texture {
    id<MTLTexture> texture;
} Texture;

typedef struct RenderCommandEncoder {
    id<MTLRenderCommandEncoder> encoder;
} RenderCommandEncoder;

typedef struct CommandBuffer {
    id<MTLCommandBuffer> buffer;
} CommandBuffer;

typedef struct CommandQueue {
    id<MTLCommandQueue> queue;
} CommandQueue;

typedef struct Buffer {
    id<MTLBuffer> buffer;
} Buffer;

typedef struct Device {
    id<MTLDevice> device;
} Device;

typedef struct Library {
    id<MTLLibrary> library;
} Library;

typedef struct Function {
    id<MTLFunction> function;
} Function;

typedef struct VertexDescriptor {
    MTLVertexDescriptor *desc;
} VertexDescriptor;

typedef struct RenderPipelineDescriptor {
    MTLRenderPipelineDescriptor *desc;
} RenderPipelineDescriptor;

typedef struct RenderPipelineState {
    id<MTLRenderPipelineState> state;
} RenderPipelineState;

typedef struct RenderPassDescriptor {
    MTLRenderPassDescriptor *desc;
} RenderPassDescriptor;

/*******************************************************************************
 * MTLDevice
 ******************************************************************************/

int deviceInit(Device *self);
void deviceDeinit(Device *self);
int deviceNewCommandQueue(Device *self, CommandQueue *out);
int deviceNewDefaultLibrary(Device *self, Library *out);
int deviceNewBufferWithLength(Device *self, size_t length, Buffer *out); 
int deviceNewBufferWithBytes(Device *self, const void *bytes, size_t length, Buffer *out);
int deviceNewRenderPipelineStateWithDescriptor(Device *self, RenderPipelineDescriptor *desc, RenderPipelineState *out);
int deviceGetName(Device *self, char *out, size_t max_len);
int deviceNewTextureWithDescriptor(Device *self, TextureDescriptor *desc, Texture *out);

/*******************************************************************************
 * MTLLibrary
 ******************************************************************************/

int libraryNewFunctionWithName(Library *self, const char *name, Function *out);
void libraryDeinit(Library *self);

/*******************************************************************************
 * MTLFunction
 ******************************************************************************/

void functionDeinit(Function *self);

/*******************************************************************************
 * MTLBuffer
 ******************************************************************************/

void bufferDeinit(Buffer *self);
void *bufferContents(Buffer *self);
uint64_t bufferLength(Buffer *self);

/*******************************************************************************
 * MTLVertexDescriptor
 ******************************************************************************/

int vertexDescriptorInit(VertexDescriptor *self);
void vertexDescriptorDeinit(VertexDescriptor *self);
void vertexDescriptorAttributeFormat(VertexDescriptor *self, int index, uint64_t format);
void vertexDescriptorAttributeOffset(VertexDescriptor *self, int index, uint64_t offset);
void vertexDescriptorAttributeBufferIndex(VertexDescriptor *self, int index, uint64_t buffer_index);
void vertexDescriptorLayoutStepFunction(VertexDescriptor *self, int index, uint64_t step_function);
void vertexDescriptorLayoutStepRate(VertexDescriptor *self, int index, uint64_t step_rate);
void vertexDescriptorLayoutStride(VertexDescriptor *self, int index, uint64_t stride);

/*******************************************************************************
 * MTLRenderPipelineDescriptor
 ******************************************************************************/

int renderPipelineDescriptorInit(RenderPipelineDescriptor *self);
void renderPipelineDescriptorDenit(RenderPipelineDescriptor *self);
void renderPipelineDescriptorSetVertexFunction(RenderPipelineDescriptor *desc, Function *val);
void renderPipelineDescriptorSetFragmentFunction(RenderPipelineDescriptor *desc, Function *val);
void renderPipelineDescriptorSetVertexDescriptor(RenderPipelineDescriptor *desc, VertexDescriptor *val);
void renderPipelineDescriptorSetColorAttachmentPixelFormat(RenderPipelineDescriptor *desc, int index, uint64_t format);

/*******************************************************************************
 * MTLCommandQueue
 ******************************************************************************/

void commandQueueDeinit(CommandQueue *self);
void commandQueueSetLabel(CommandQueue *self, const char *label);
int commandQueueCommandBuffer(CommandQueue *self, CommandBuffer *out);

/*******************************************************************************
 * MTLRenderPassDescriptor
 ******************************************************************************/

void renderPassDescriptorSetColorAttachmentClearColor(RenderPassDescriptor *self, int index, MTLClearColor color);

/*******************************************************************************
 * MTLCommandBuffer
 ******************************************************************************/

int commandBufferRenderCommandEncoderWithDescriptor(CommandBuffer *self, RenderPassDescriptor *desc, RenderCommandEncoder *out);
void commandBufferCommit(CommandBuffer *self);
void commandBufferPresentDrawable(CommandBuffer *self, Drawable *drawable);


/*******************************************************************************
 * MTLRenderCommandEncoder
 ******************************************************************************/

void renderCommandEncoderDeinit(RenderCommandEncoder *self);
void renderCommandEncoderSetLabel(RenderCommandEncoder *self, const char *label);
void renderCommandEncoderSetRenderPipelineState(RenderCommandEncoder *self, RenderPipelineState *state);
void renderCommandEncoderSetVertexBuffer(RenderCommandEncoder *self, Buffer *buffer, uint64_t offset, uint64_t index);
void renderCommandEncoderSetVertexBytes(RenderCommandEncoder *self, const void *bytes, uint64_t length, uint64_t index);
void renderCommandEncoderSetFragmentBuffer(RenderCommandEncoder *self, Buffer *buffer, uint64_t offset, uint64_t index);
void renderCommandEncoderSetFragmentBytes(RenderCommandEncoder *self, const void *bytes, uint64_t length, uint64_t index);
void renderCommandEncoderDrawPrimitives(RenderCommandEncoder *self, uint64_t type, uint64_t start, uint64_t count);
void renderCommandEncoderDrawIndexedPrimitives(RenderCommandEncoder *self, uint64_t type, uint64_t index_count, uint64_t index_type, Buffer *index_buffer, uint64_t index_buffer_offset);
void renderCommandEncoderSetFragmentTexture(RenderCommandEncoder *self, Texture texture, uint64_t index);
void renderCommandEncoderEndEncoding(RenderCommandEncoder *self);

/*******************************************************************************
 * MTLTextureDescriptor
 ******************************************************************************/

int textureDescriptorInit(TextureDescriptor *self);
int textureDescriptorInit2DWithPixelFormat(TextureDescriptor *self, uint64_t format, uint64_t width,uint64_t height, MBBool mipmapped);
void textureDescriptorDeinit(TextureDescriptor *self);

/*******************************************************************************
 * MTLTexture
 ******************************************************************************/

void textureDeinit(Texture *self);

#endif /* metal_bindings_h */
