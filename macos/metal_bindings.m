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

RenderPipelineDescriptor RenderPipelineDescriptor_init() {
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

void RenderPipelineDescriptor_setVertexBufferMultability(RenderPipelineDescriptor self, int index, MBEnum multability) {
    ((MTLRenderPipelineDescriptor *)self).vertexBuffers[index].mutability = multability;
}

void RenderPipelineDescriptor_setFragmentBufferMultability(RenderPipelineDescriptor self, int index, MBEnum multability) {
    ((MTLRenderPipelineDescriptor *)self).fragmentBuffers[index].mutability = multability;
}

void RenderPipelineDescriptor_setColorAttachmentPixelFormat(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].pixelFormat = value;
}

void RenderPipelineDescriptor_setColorAttachmentWriteMask(RenderPipelineDescriptor self, int index, MBEnum value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].writeMask = value;
}

void RenderPipelineDescriptor_setColorAttachmentBlendingEnabled(RenderPipelineDescriptor self, int index, MBBool value) {
    ((MTLRenderPipelineDescriptor *) self).colorAttachments[index].blendingEnabled = value;
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

RenderPassDescriptor RenderPassDescriptor_init() {
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

void RenderPassDescriptor_setColorAttachmentStoreaction(RenderPassDescriptor self, int index, MBEnum val) {
    ((MTLRenderPassDescriptor *)self).colorAttachments[index].storeAction = val;
}



