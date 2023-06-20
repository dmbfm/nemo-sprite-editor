//
//  metal_bindings.h
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#ifndef metal_bindings_h
#define metal_bindings_h

#include <stddef.h>
#include <stdint.h>

// #import <Metal/Metal.h>
// #import <MetalKit/MetalKit.h>

typedef uint8_t MBBool;
typedef uint64_t MBEnum;

#define DF_TRUE  ((MBBool) 1);
#define DF_FALST ((MBBool) 0);

typedef void *ID;
typedef ID Device;
typedef ID Drawable;
typedef ID CommandQueue;
typedef ID CommandBuffer;
typedef ID RenderPassDescriptor;
typedef ID Library;
typedef ID Function;
typedef ID Buffer;
typedef ID RenderPipelineState;
typedef ID RenderPipelineDescriptor;
typedef ID Texture;
typedef ID TextureDescriptor;
typedef ID RenderCommandEncoder;
typedef ID VertexDescriptor;

void release(void *);

typedef struct ClearColor {
    double r;
    double g;
    double b;
    double a;
} ClearColor;

typedef struct MB_Viewport {
    double x;
    double y;
    double w;
    double h;
    double znear;
    double zfar;
} MB_Viewport;

typedef struct MB_ScissorRect {
    double x;
    double y;
    double w;
    double h;
} MB_ScissorRect;

typedef struct MB_Origin {
    uint64_t x;
    uint64_t y;
    uint64_t z;
} MB_Origin;

typedef struct MB_Size {
    uint64_t width;
    uint64_t height;
    uint64_t depth;
} MB_Size;

typedef struct MB_Region {
    MB_Origin origin;
    MB_Size size;
} MB_Region;

/******************************************************************************
 * MTLDevice
 ******************************************************************************/

Device              Device_init(void);
CommandQueue        Device_newCommandQueue(Device self);
Library             Device_newDefaultLibrary(Device self);
Buffer              Device_newBufferWithLength(Device self, size_t length); 
Buffer              Device_newBufferWithBytes(Device self, const void *bytes, size_t length);
RenderPipelineState Device_newRenderPipelineStateWithDescriptor(Device self, RenderPipelineDescriptor desc);
int                 Device_getName(Device self, char *out, size_t max_len);
Texture             Device_newTextureWithDescriptor(Device self, TextureDescriptor desc);

/******************************************************************************
 * MTLCommandQueue
 ******************************************************************************/

CommandBuffer CommandQueue_commandBuffer(CommandQueue self);

/******************************************************************************
 * MTLCommandBuffer
 ******************************************************************************/

void                 CommandBuffer_commit(CommandBuffer self);
void                 CommandBuffer_presentDrawable(CommandBuffer self, Drawable drawable);
void                 CommandBuffer_addCompletedHandler(CommandBuffer self, void (*cb)(CommandBuffer));
void                 CommandBuffer_setLabel(CommandBuffer self, const char *label);
RenderCommandEncoder CommandBuffer_renderCommandEncoderWithDescriptor(CommandBuffer self, RenderPassDescriptor desc);

/******************************************************************************
 * MTLRenderPipelineDescriptor
 ******************************************************************************/

RenderPipelineDescriptor RenderPipelineDescriptor_init(void);
void RenderPipelineDescriptor_setLabel(RenderPipelineDescriptor self, const char *label);
void RenderPipelineDescriptor_reset(RenderPipelineDescriptor self);
void RenderPipelineDescriptor_setVertexFunction(RenderPipelineDescriptor self, Function value);
void RenderPipelineDescriptor_setFragmentFunction(RenderPipelineDescriptor self, Function value);
void RenderPipelineDescriptor_setVertexDescriptor(RenderPipelineDescriptor self, VertexDescriptor value);
void RenderPipelineDescriptor_setVertexBufferMutability(RenderPipelineDescriptor self, int index, MBEnum mutability);
void RenderPipelineDescriptor_setFragmentBufferMutability(RenderPipelineDescriptor self, int index, MBEnum mutability);
void RenderPipelineDescriptor_setColorAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentWriteMask(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(RenderPipelineDescriptor self, int index, MBBool value);
void RenderPipelineDescriptor_setColorAttachmentAlphaBlendOperation(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentRgbBlendOperation(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentDestinationAlphaBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentDestinationRgbBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentSourceAlphaBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setColorAttachmentSourceRgbBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setDepthAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value);
void RenderPipelineDescriptor_setStencilAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value);


/******************************************************************************
 * MTLRenderPassDescriptor
 ******************************************************************************/


RenderPassDescriptor RenderPassDescriptor_init(void);
void RenderPassDescriptor_setColorAttachmentClearColor(RenderPassDescriptor self, int index, ClearColor val);

void RenderPassDescriptor_setColorAttachmentTexture(RenderPassDescriptor self, int index, Texture val);
void RenderPassDescriptor_setColorAttachmentLevel(RenderPassDescriptor self, int index, uint64_t val);
void RenderPassDescriptor_setColorAttachmentSlice(RenderPassDescriptor self, int index, uint64_t val);
void RenderPassDescriptor_setColorAttachmentLoadAction(RenderPassDescriptor self, int index, MBEnum val);
void RenderPassDescriptor_setColorAttachmentStoreAction(RenderPassDescriptor self, int index, MBEnum val);
void RenderPassDescriptor_setDepthAttachmentClearDepth(RenderPassDescriptor self, double value);
void RenderPassDescriptor_setStencilAttachmentClearStencil(RenderPassDescriptor self, double value);

/******************************************************************************
 * MTLRenderCommandEncoder
 ******************************************************************************/

void RenderCommandEncoder_setRenderPipelineState(RenderCommandEncoder self, RenderPipelineState state);
void RenderCommandEncoder_setTriangleFillMode(RenderCommandEncoder self, MBEnum val);
void RenderCommandEncoder_setFrontFaceWinding(RenderCommandEncoder self, MBEnum val);
void RenderCommandEncoder_setCullMode(RenderCommandEncoder self, MBEnum val);
//void RenderCommandEncoder_setDepthStencilState(RenderCommandEncoder self, DepthStencilState val);
void RenderCommandEncoder_setViewport(RenderCommandEncoder self, MB_Viewport val);
void RenderCommandEncoder_setScissorRect(RenderCommandEncoder self, MB_ScissorRect val);
void RenderCommandEncoder_setBlendColor(RenderCommandEncoder self, float r, float g, float b, float a);
void RenderCommandEncoder_setVertexBuffer(RenderCommandEncoder self, Buffer buffer, uint64_t offset, uint64_t index);
void RenderCommandEncoder_setVertexBytes(RenderCommandEncoder self, const void *bytes, uint64_t length, uint64_t index);

/******************************************************************************
 * MTLBuffer
 ******************************************************************************/

void* Buffer_contents(Buffer self);


/******************************************************************************
 * MTLVertexDescriptor
 ******************************************************************************/

VertexDescriptor VertexDescriptor_init(void);
void VertexDescriptor_reset(VertexDescriptor self);
void VertexDescriptor_setAttributeFormat(VertexDescriptor self, int index, MBEnum value);
void VertexDescriptor_setAttributeOffet(VertexDescriptor self, int index, uint64_t value);
void VertexDescriptor_setAttributeBufferIndex(VertexDescriptor self, int index, uint64_t value);
void VertexDescriptor_setLayoutStride(VertexDescriptor self, int index, uint64_t value);
void VertexDescriptor_setLayoutStepFunction(VertexDescriptor self, int index, MBEnum value);
void VertexDescriptor_setLayoutStepRate(VertexDescriptor self, int index, uint64_t value);

/******************************************************************************
 * MTLTextureDescriptor
 ******************************************************************************/

TextureDescriptor TextureDescriptor_init(void);
TextureDescriptor TextureDescriptor_texture2DDescriptorWithPixelFormat(MBEnum pixel_format, uint64_t width, uint64_t height, MBBool mipmapped);
void              TextureDescriptor_setPixelFormat(TextureDescriptor self, MBEnum value);
void              TextureDescriptor_setWidth(TextureDescriptor self, uint64_t value);
void              TextureDescriptor_setHeight(TextureDescriptor self, uint64_t value);
void              TextureDescriptor_setMipmapLevelCount(TextureDescriptor self, uint64_t value);
void              TextureDescriptor_setCpuCacheMode(TextureDescriptor self, MBEnum value);
void              TextureDescriptor_setStorageMode(TextureDescriptor self, MBEnum value);


/******************************************************************************
 * MTLTexture
 ******************************************************************************/

void Texture_replaceRegion(Texture self, MB_Region region, uint64_t mipmap_level, const void *bytes, uint64_t bytes_per_row);
void Texture_replaceRegionSlice(Texture self, MB_Region region, uint64_t mipmap_level, uint64_t slice, const void *bytes, uint64_t bytes_per_row, uint64_t bytes_per_image);
void Texture_getBytes(Texture self, void *out, uint64_t bytes_per_row, MB_Region region, uint64_t mipmap_level);
void Texture_getBytesSlice(Texture self, void *out, uint64_t bytes_per_row, uint64_t bytes_per_image, MB_Region region, uint64_t mipmap_level, uint64_t slice);
Texture Texture_newTextureWithFormat(Texture self, MBEnum format);
uint64_t Texture_width(Texture self);
uint64_t Texture_height(Texture self);

/******************************************************************************
 * MTLLibrary
 ******************************************************************************/

Function Library_newFunctionWithName(Library self, const char *name);



#endif /* metal_bindings_h */
