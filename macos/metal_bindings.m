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

