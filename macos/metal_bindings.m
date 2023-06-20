//
//  metal_bindings.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include "metal_bindings.h"

#if __has_feature(objc_arc)
    #error "This file should be compiled wihtout ARC."
#endif

#define RETURN_RETAIN(x) \
    if ((x)) {\
        return (void *) [(x) retain];\
    }\
    return 0

#define RELEASE(x) \
    if (x) { \
        [(NSObject *)(x) release];\
    }

void release(void *ptr) {
    if (ptr) {
        [(NSObject *)ptr release];
    }
}

Device Device_init(void) {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    RETURN_RETAIN(device);
}

int Device_getName(Device self, char *out, size_t max_size) {
    id<MTLDevice> device = (id<MTLDevice>) self;
    NSString *name = [device name];
    const char *c = [name UTF8String];
    int i = 0;
    for (; i < (max_size-1); i++) {
        if (c[i] == 0) {
            break;
        }
        out[i] = c[i];
    }
    out[i] = 0;

    return i;
}

CommandQueue Device_newCommandQueue(Device self) {
    id<MTLCommandQueue> queue = [(id<MTLDevice>) self newCommandQueue];
    RETURN_RETAIN(queue);
}

Library Device_newDefaultLibrary(Device self) {
    id<MTLLibrary> result = [(id<MTLDevice>) self newDefaultLibrary];
    RETURN_RETAIN(result);
}

Buffer Device_newBufferWithLength(Device self, size_t length) {
    id<MTLBuffer> result = [((id<MTLDevice>) self) newBufferWithLength:(NSUInteger)length 
                                                           options:MTLResourceCPUCacheModeDefaultCache];
    RETURN_RETAIN(result);
}

Buffer Device_newBufferWithBytes(Device self, const void *bytes, size_t length) {
    id<MTLBuffer> result = [(id<MTLDevice>) self newBufferWithBytes:bytes 
                                             length:(NSUInteger)length 
                                            options:MTLResourceCPUCacheModeDefaultCache];
    RETURN_RETAIN(result);
}

RenderPipelineState Device_newRenderPipelineStateWithDescriptor(Device self, RenderPipelineDescriptor desc) {
    NSError *err = nil;
    id<MTLRenderPipelineState> state =  [(id<MTLDevice>) self newRenderPipelineStateWithDescriptor:(MTLRenderPipelineDescriptor *)desc 
                                                                error:&err];
    if (err != nil) {
        NSLog(@"[deviceNewRenderPipelineStateWithDescriptor] ERROR: %@", [err localizedDescription]);
    }

    RETURN_RETAIN(state);
}

Texture Device_newTextureWithDescriptor(Device self, TextureDescriptor desc) {
    id<MTLTexture> texture =  [(id<MTLDevice>) self newTextureWithDescriptor:(MTLTextureDescriptor *)desc];
    RETURN_RETAIN(texture);
}

CommandBuffer CommandQueue_commandBuffer(CommandQueue self) {
    id<MTLCommandBuffer> r = [(id<MTLCommandQueue>) self commandBuffer];
    RETURN_RETAIN(r);
}

void CommandBuffer_commit(CommandBuffer self) {
    [(id<MTLCommandBuffer>) self commit];
}

void CommandBuffer_presentDrawable(CommandBuffer self, Drawable drawable) {
    [(id<MTLCommandBuffer>) self presentDrawable:(id<MTLDrawable>) drawable];
}

void CommandBuffer_addCompletedHandler(CommandBuffer self, void (*cb)(CommandBuffer)) {
    [(id<MTLCommandBuffer>)self addCompletedHandler:^(id<MTLCommandBuffer> buffer){
        cb((CommandBuffer) buffer);
    }];
}

void CommandBuffer_setLabel(CommandBuffer self, const char *label) {
    [(id<MTLCommandBuffer>) self setLabel:[NSString stringWithUTF8String:label]];
}

RenderCommandEncoder CommandBuffer_renderCommandEncoderWithDescriptor(CommandBuffer self, RenderPassDescriptor desc) {
    id<MTLRenderCommandEncoder> r = [(id<MTLCommandBuffer>)self renderCommandEncoderWithDescriptor:(MTLRenderPassDescriptor *)desc];
    // Dont't retain command encoders
    //RETURN_RETAIN(r);
    return r;
}

/******************************************************************************
 * MTLRenderPipelineDescriptor
 ******************************************************************************/

RenderPipelineDescriptor RenderPipelineDescriptor_init(void) {
    MTLRenderPipelineDescriptor *desc = [[MTLRenderPipelineDescriptor alloc] init];
    RETURN_RETAIN(desc);
}

void RenderPipelineDescriptor_setLabel(RenderPipelineDescriptor self, const char *label) {
    [(MTLRenderPipelineDescriptor *) self setLabel:[NSString stringWithUTF8String:label]];
}

void RenderPipelineDescriptor_reset(RenderPipelineDescriptor self) {
    [(MTLRenderPipelineDescriptor *) self reset];
}

void RenderPipelineDescriptor_setVertexFunction(RenderPipelineDescriptor self, Function value) {
    [(MTLRenderPipelineDescriptor *) self setVertexFunction:(id<MTLFunction>) value];
}

void RenderPipelineDescriptor_setFragmentFunction(RenderPipelineDescriptor self, Function value) {
    [(MTLRenderPipelineDescriptor *) self setFragmentFunction:(id<MTLFunction>) value];
}

void RenderPipelineDescriptor_setVertexDescriptor(RenderPipelineDescriptor self, VertexDescriptor value) {
    [(MTLRenderPipelineDescriptor *) self setVertexDescriptor:(MTLVertexDescriptor *)value];
}

void RenderPipelineDescriptor_setVertexBufferMutability(RenderPipelineDescriptor self, int index, MBEnum mutability) {
    ((MTLRenderPipelineDescriptor *)self).vertexBuffers[index].mutability = mutability;
}

void RenderPipelineDescriptor_setFragmentBufferMutability(RenderPipelineDescriptor self, int index, MBEnum mutability) {
    ((MTLRenderPipelineDescriptor *)self).fragmentBuffers[index].mutability = mutability;
}

void RenderPipelineDescriptor_setColorAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].pixelFormat = value;
}

void RenderPipelineDescriptor_setColorAttachmentWriteMask(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].writeMask = value;
}

void RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(RenderPipelineDescriptor self, int index, MBBool value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].blendingEnabled = (value != 0);
}

void RenderPipelineDescriptor_setColorAttachmentAlphaBlendOperation(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].alphaBlendOperation = value;
}

void RenderPipelineDescriptor_setColorAttachmentRgbBlendOperation(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].rgbBlendOperation = value;
}

void RenderPipelineDescriptor_setColorAttachmentDestinationAlphaBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].destinationAlphaBlendFactor = value;
}

void RenderPipelineDescriptor_setColorAttachmentDestinationRgbBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].destinationRGBBlendFactor = value;
}

void RenderPipelineDescriptor_setColorAttachmentSourceAlphaBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].sourceAlphaBlendFactor = value;
}

void RenderPipelineDescriptor_setColorAttachmentSourceRgbBlendFactor(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].sourceRGBBlendFactor = value;
}

void RenderPipelineDescriptor_setDepthAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).depthAttachmentPixelFormat = value;
}

void RenderPipelineDescriptor_setStencilAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).stencilAttachmentPixelFormat = value;
}

/******************************************************************************
 * MTLRenderPassDescriptor
 ******************************************************************************/

RenderPassDescriptor RenderPassDescriptor_init(void) {
    MTLRenderPassDescriptor *desc = [[MTLRenderPassDescriptor alloc] init];
    RETURN_RETAIN(desc);
}

void RenderPassDescriptor_setColorAttachmentClearColor(RenderPassDescriptor self, int index, ClearColor val) {
    ((MTLRenderPassDescriptor *) self).colorAttachments[index].clearColor = 
        MTLClearColorMake(val.r, val.g, val.b, val.a);
}

void RenderPassDescriptor_setDepthAttachmentClearDepth(RenderPassDescriptor self, double value) {
    ((MTLRenderPassDescriptor *)self).depthAttachment.clearDepth = value;
}

void RenderPassDescriptor_setStencilAttachmentClearStencil(RenderPassDescriptor self, double value) {
    ((MTLRenderPassDescriptor *)self).stencilAttachment.clearStencil = value;
}

void RenderPassDescriptor_setColorAttachmentTexture(RenderPassDescriptor self, int index, Texture val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].texture = val;
}

void RenderPassDescriptor_setColorAttachmentLevel(RenderPassDescriptor self, int index, uint64_t val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].level = val;
}

void RenderPassDescriptor_setColorAttachmentSlice(RenderPassDescriptor self, int index, uint64_t val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].slice = val;
}

void RenderPassDescriptor_setColorAttachmentLoadAction(RenderPassDescriptor self, int index, MBEnum val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].loadAction = val;
}

void RenderPassDescriptor_setColorAttachmentStoreAction(RenderPassDescriptor self, int index, MBEnum val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].storeAction = val;
}

/******************************************************************************
 * MTLRenderCommandEncoder
 ******************************************************************************/

void RenderCommandEncoder_setRenderPipelineState(RenderCommandEncoder self, RenderPipelineState state) {
    [(id<MTLRenderCommandEncoder>)self setRenderPipelineState:(id<MTLRenderPipelineState>)state];
}

void RenderCommandEncoder_setTriangleFillMode(RenderCommandEncoder self, MBEnum val) {
    [(id<MTLRenderCommandEncoder>)self setTriangleFillMode:val];
}

void RenderCommandEncoder_setFrontFaceWinding(RenderCommandEncoder self, MBEnum val) {
    [(id<MTLRenderCommandEncoder>)self setFrontFacingWinding:val];
}

void RenderCommandEncoder_setCullMode(RenderCommandEncoder self, MBEnum val) {
    [(id<MTLRenderCommandEncoder>)self setCullMode:val];
}
//void RenderCommandEncoder_setDepthStencilState(RenderCommandEncoder self, DepthStencilState val);
void RenderCommandEncoder_setViewport(RenderCommandEncoder self, MB_Viewport val) {
    [(id<MTLRenderCommandEncoder>)self setViewport:(MTLViewport){ val.x, val.y, val.w, val.h, val.znear, val.zfar }];
}
void RenderCommandEncoder_setScissorRect(RenderCommandEncoder self, MB_ScissorRect val) {
    [(id<MTLRenderCommandEncoder>)self setScissorRect:(MTLScissorRect){ val.x, val.y, val.w, val.h }];
}

void RenderCommandEncoder_setBlendColor(RenderCommandEncoder self, float r, float g, float b, float a) {
    [(id<MTLRenderCommandEncoder>)self setBlendColorRed:r green:g blue:b alpha:a];
}

void RenderCommandEncoder_setVertexBuffer(RenderCommandEncoder self, Buffer buffer, uint64_t offset, uint64_t index) {
    [(id<MTLRenderCommandEncoder>)self setVertexBuffer:(id<MTLBuffer>)buffer 
                                                offset:(NSUInteger)offset 
                                               atIndex:(NSUInteger)index];
}

void RenderCommandEncoder_setVertexBytes(RenderCommandEncoder self, const void *bytes, uint64_t length, uint64_t index) {
    [(id<MTLRenderCommandEncoder>)self setVertexBytes:bytes length:(NSUInteger)length atIndex:(NSUInteger)index];
}



/******************************************************************************
 * MTLBuffer
 ******************************************************************************/

void* Buffer_contents(Buffer self) {
    return [(id<MTLBuffer>)self contents];
}

/******************************************************************************
 * MTLVertexDescriptor
 ******************************************************************************/

VertexDescriptor VertexDescriptor_init(void) {
    MTLVertexDescriptor *desc = [MTLVertexDescriptor vertexDescriptor];
    RETURN_RETAIN(desc);
}

void VertexDescriptor_reset(VertexDescriptor self) {
    [(MTLVertexDescriptor *)self reset];
}

void VertexDescriptor_setAttributeFormat(VertexDescriptor self, int index, MBEnum value) {
    ((MTLVertexDescriptor *)self).attributes[index].format = value;
}

void VertexDescriptor_setAttributeOffet(VertexDescriptor self, int index, uint64_t value) {
    ((MTLVertexDescriptor *)self).attributes[index].offset = value;
}

void VertexDescriptor_setAttributeBufferIndex(VertexDescriptor self, int index, uint64_t value) {
    ((MTLVertexDescriptor *)self).attributes[index].bufferIndex = value;
}

void VertexDescriptor_setLayoutStride(VertexDescriptor self, int index, uint64_t value) {
    ((MTLVertexDescriptor *)self).layouts[index].stride = value;
}

void VertexDescriptor_setLayoutStepFunction(VertexDescriptor self, int index, MBEnum value) {
    ((MTLVertexDescriptor *)self).layouts[index].stepFunction = value;
}

void VertexDescriptor_setLayoutStepValue(VertexDescriptor self, int index, uint64_t value) {
    ((MTLVertexDescriptor *)self).layouts[index].stepRate = value;
}


/******************************************************************************
 * MTLTextureDescriptor
 ******************************************************************************/

TextureDescriptor TextureDescriptor_init(void) {
    MTLTextureDescriptor *desc = [[MTLTextureDescriptor alloc] init];
    RETURN_RETAIN(desc);
}

TextureDescriptor TextureDescriptor_texture2DDescriptorWithPixelFormat(MBEnum pixel_format, uint64_t width, uint64_t height, MBBool mipmapped) {
    MTLTextureDescriptor *desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:pixel_format 
                                                                                    width:(NSUInteger)width 
                                                                                   height:(NSUInteger)height 
                                                                                mipmapped:(mipmapped != 0)];
    RETURN_RETAIN(desc);
}

void TextureDescriptor_setPixelFormat(TextureDescriptor self, MBEnum value) {
    [(MTLTextureDescriptor *)self setPixelFormat:value];
}

void TextureDescriptor_setWidth(TextureDescriptor self, uint64_t value) {
    [(MTLTextureDescriptor *)self setWidth:value];
}

void TextureDescriptor_setHeight(TextureDescriptor self, uint64_t value) {
    [(MTLTextureDescriptor *)self setHeight:value];
}

void TextureDescriptor_setMipmapLevelCount(TextureDescriptor self, uint64_t value) {
    [(MTLTextureDescriptor *)self setMipmapLevelCount:value];
}

void TextureDescriptor_setCpuCacheMode(TextureDescriptor self, MBEnum value) {
    [(MTLTextureDescriptor *)self setCpuCacheMode:value];
}

void TextureDescriptor_setStorageMode(TextureDescriptor self, MBEnum value) {
    [(MTLTextureDescriptor *)self setStorageMode:value];
}


/******************************************************************************
 * MTLTexture
 ******************************************************************************/

void Texture_replaceRegion(Texture self, MB_Region region, uint64_t mipmap_level, const void *bytes, uint64_t bytes_per_row) {
    [(id<MTLTexture>)self replaceRegion:(MTLRegion){ { region.origin.x, region.origin.y , region.origin.z  } }
                            mipmapLevel:(NSUInteger)mipmap_level 
                              withBytes:bytes 
                            bytesPerRow:(NSUInteger)bytes_per_row];
}
void Texture_replaceRegionSlice(Texture self, MB_Region region, uint64_t mipmap_level, uint64_t slice, const void *bytes, uint64_t bytes_per_row, uint64_t bytes_per_image) {
    [(id<MTLTexture>) self replaceRegion:(MTLRegion){ { region.origin.x, region.origin.y , region.origin.z  }, { region.size.width, region.size.height, region.size.depth }} 
                             mipmapLevel:(NSUInteger)mipmap_level 
                                   slice:(NSUInteger)slice 
                               withBytes:bytes 
                             bytesPerRow:(NSUInteger)bytes_per_row 
                           bytesPerImage:(NSUInteger)bytes_per_image];
}

void Texture_getBytes(Texture self, void *out, uint64_t bytes_per_row, MB_Region region, uint64_t mipmap_level) {
    [(id<MTLTexture>) self getBytes:out 
                        bytesPerRow:(NSUInteger) bytes_per_row 
                         fromRegion:(MTLRegion) { { region.origin.x, region.origin.y , region.origin.z  }, { region.size.width, region.size.height, region.size.depth }} 
                        mipmapLevel:(NSUInteger) mipmap_level];
}

void Texture_getBytesSlice(Texture self, void *out, uint64_t bytes_per_row, uint64_t bytes_per_image, MB_Region region, uint64_t mipmap_level, uint64_t slice) {
    [(id<MTLTexture>) self getBytes:out 
                        bytesPerRow:(NSUInteger) bytes_per_row
                      bytesPerImage:(NSUInteger) bytes_per_image
                         fromRegion:(MTLRegion){ { region.origin.x, region.origin.y , region.origin.z  }, { region.size.width, region.size.height, region.size.depth }} 
                        mipmapLevel:(NSUInteger) mipmap_level
                              slice:(NSUInteger) slice];
}

Texture Texture_newTextureWithFormat(Texture self, MBEnum format) {
    id<MTLTexture> tex = [(id<MTLTexture>) self newTextureViewWithPixelFormat:format]; 
    RETURN_RETAIN(tex);
}

uint64_t Texture_width(Texture self) {
    return [(id<MTLTexture>) self width];
};

uint64_t Texture_height(Texture self){
    return [(id<MTLTexture>) self height];
};


/******************************************************************************
 * MTLLibrary
 ******************************************************************************/

Function Library_newFunctionWithName(Library self, const char *name) {
    id<MTLFunction> func = [(id<MTLLibrary>) self newFunctionWithName:[NSString stringWithUTF8String:name]];
    RETURN_RETAIN(func);
}

