//
//  metal_bindings.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <Foundation/Foundation.h>
#include "metal_bindings.h"

#if __has_feature(objc_arc)
    #error "This file should be compiled wihtout ARC."
#endif

int deviceInit(Device *self) {
    self->device = MTLCreateSystemDefaultDevice();

    if (self->device == nil) {
        return MB_ERR;
    }

    [self->device retain];

    return MB_OK;
}

void deviceDeinit(Device *self) {
    if (self->device) {
        [self->device release];
    }
}

int deviceGetName(Device *self, char *out, size_t max_size) {
    NSString *name = [self->device name];
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

int deviceNewCommandQueue(Device *self, CommandQueue *out) {
    id<MTLCommandQueue> queue = [self->device newCommandQueue];
    if (queue == nil) {
        out->queue = 0;
        return MB_ERR;
    }

    out->queue = queue;

    return MB_OK;
}


int deviceNewDefaultLibrary(Device *self, Library *out) {
    id<MTLLibrary> library = [self->device newDefaultLibrary];
    if (library == nil) {
        out->library = 0;
        return MB_ERR;
    }

    out->library = library;

    return MB_OK;
}

int deviceNewBufferWithLength(Device *self, size_t length, Buffer *out) {
    id<MTLBuffer> buffer =  [self->device newBufferWithLength: (NSUInteger) length 
                                                      options:MTLResourceCPUCacheModeDefaultCache];

    out->buffer = buffer;

    if (buffer == nil) {
        return MB_ERR;
    }

    [out->buffer retain];
    return MB_OK;
}

int deviceNewBufferWithBytes(Device *self, const void *bytes, size_t length, Buffer *out) {
    id<MTLBuffer> buffer = [self->device newBufferWithBytes:bytes 
                                                     length:(NSUInteger)length 
                                                    options:MTLResourceCPUCacheModeDefaultCache];
    out->buffer = buffer;
    
    if (buffer == nil) {
        return MB_ERR;
    }

    [out->buffer retain];
    return MB_OK;
}

int deviceNewRenderPipelineStateWithDescriptor(Device *self, RenderPipelineDescriptor *desc, RenderPipelineState *out) {
    NSError *err;
    out->state = [self->device newRenderPipelineStateWithDescriptor:desc->desc error:&err];

    if (out->state == nil) {
        NSLog(@"Error: %@", [err localizedDescription]);
        return MB_ERR;
    }

    return MB_OK;
}


int deviceNewTextureWithDescriptor(Device *self, TextureDescriptor *desc, Texture *out) {
    out->texture = [self->device newTextureWithDescriptor:desc->desc];
    if (out->texture == nil) {
        return MB_ERR;
    }

    [out->texture retain];
    return MB_OK;
}

int libraryNewFunctionWithName(Library * self, const char *name, Function *out) {
    id<MTLFunction> func = [self->library newFunctionWithName:[NSString stringWithUTF8String:name]];

    if (!func) {
        out->function = 0;
        return MB_ERR;
    }

    out->function = func;
    return MB_OK;
}

void libraryDeinit(Library *self) {
    if (self->library) {
        [self->library release];
    }
}

void functionDeinit(Function *self) {
    if (self->function) {
        [self->function release];
    }
}

void bufferDeinit(Buffer *self) {
    if (self->buffer) {
        [self->buffer release];
    }
}

void *bufferContents(Buffer *self) {
    return [self->buffer contents];
}

uint64_t bufferLength(Buffer *self) {
    return [self->buffer length];
}

int vertexDescriptorInit(VertexDescriptor *self) {
    self->desc = [[MTLVertexDescriptor alloc] init];

    if (!self->desc) {
        return MB_ERR;
    }

    [self->desc retain];

    return MB_OK;
}

void vertexDescriptorDeinit(VertexDescriptor *self) {
    if (self->desc) {
        [self->desc release];
    }
}

void vertexDescriptorAttributeFormat(VertexDescriptor *self, int index, uint64_t format) {
    self->desc.attributes[index].format = format;
}

void vertexDescriptorAttributeOffset(VertexDescriptor *self, int index, uint64_t val) {
    self->desc.attributes[index].offset = val;
}

void vertexDescriptorAttributeBufferIndex(VertexDescriptor *self, int index, uint64_t val) {
    self->desc.attributes[index].bufferIndex = val;
}

void vertexDescriptorLayoutStride(VertexDescriptor *self, int index, uint64_t val) {
    self->desc.layouts[index].stride = val;
}

void vertexDescriptorLayoutStepFunction(VertexDescriptor *self, int index, uint64_t val) {
    self->desc.layouts[index].stepFunction = val;
}

void vertexDescriptorLayoutStepRate(VertexDescriptor *self, int index, uint64_t val) {
    self->desc.layouts[index].stepRate = val;
}


int renderPipelineDescriptorInit(RenderPipelineDescriptor *self) {
    self->desc = [[MTLRenderPipelineDescriptor alloc] init];

    if (self->desc == nil) {
        return MB_ERR;
    }

    [self->desc retain];
    return MB_OK;
}

void renderPipelineDescriptorDenit(RenderPipelineDescriptor *self) {
    if (self->desc) {
        [self->desc release]; 
    }
}

void renderPipelineDescriptorSetVertexFunction(RenderPipelineDescriptor *desc, Function *val) {
    desc->desc.vertexFunction = val->function;
}

void renderPipelineDescriptorSetFragmentFunction(RenderPipelineDescriptor *desc, Function *val) {
    desc->desc.fragmentFunction = val->function;
}

void renderPipelineDescriptorSetVertexDescriptor(RenderPipelineDescriptor *desc, VertexDescriptor *val) {
    desc->desc.vertexDescriptor = val->desc;
}

void renderPipelineDescriptorSetColorAttachmentPixelFormat(RenderPipelineDescriptor *desc, int index, uint64_t format) {
    desc->desc.colorAttachments[index].pixelFormat = format;
}

void commandQueueDeinit(CommandQueue *self) {
    if (self->queue) {
        [self->queue release];
    }
}

int commandQueueCommandBuffer(CommandQueue *self, CommandBuffer *out) {
    out->buffer = [self->queue commandBuffer];

    if (out->buffer == nil) {
        return MB_ERR;
    }

    return MB_OK;
}

void commandQueueSetLabel(CommandQueue *self, const char *label) {
    self->queue.label = [NSString stringWithUTF8String:label];
}


void renderPassDescriptorSetColorAttachmentClearColor(RenderPassDescriptor *self, int index, MTLClearColor color) {
    self->desc.colorAttachments[index].clearColor = color;
}

int commandBufferRenderCommandEncoderWithDescriptor(CommandBuffer *self, RenderPassDescriptor *desc, RenderCommandEncoder *out) {
    out->encoder = [self->buffer renderCommandEncoderWithDescriptor:desc->desc];

    if (out->encoder == nil) {
        return MB_ERR;
    }

    return MB_OK;
}

void commandBufferCommit(CommandBuffer *self) {
    [self->buffer commit];
}

void commandBufferPresentDrawable(CommandBuffer *self, Drawable *drawable) {
    [self->buffer presentDrawable:drawable->drawable];
}

void renderCommandEncoderDeinit(RenderCommandEncoder *self) {
    if (self->encoder) {
        [self->encoder release];
    }
}

void renderCommandEncoderSetLabel(RenderCommandEncoder *self, const char *label) {
    self->encoder.label = [NSString stringWithUTF8String:label];
}

void renderCommandEncoderSetRenderPipelineState(RenderCommandEncoder *self, RenderPipelineState *state) {
    [self->encoder setRenderPipelineState:state->state];
}

void renderCommandEncoderSetVertexBuffer(RenderCommandEncoder *self, Buffer *buffer, uint64_t offset, uint64_t index) {
    [self->encoder setVertexBuffer: buffer->buffer offset: offset atIndex: index];
}

void renderCommandEncoderSetVertexBytes(RenderCommandEncoder *self, const void *bytes, uint64_t length, uint64_t index) {
    [self->encoder setVertexBytes:bytes length:length atIndex:index];
}

void renderCommandEncoderSetFragmentBuffer(RenderCommandEncoder *self, Buffer *buffer, uint64_t offset, uint64_t index) {
    [self->encoder setFragmentBuffer: buffer->buffer offset: offset atIndex: index];
}

void renderCommandEncoderSetFragmentBytes(RenderCommandEncoder *self, const void *bytes, uint64_t length, uint64_t index) {
    [self->encoder setFragmentBytes:bytes length:length atIndex:index];
}

void renderCommandEncoderEndEncoding(RenderCommandEncoder *self) {
    [self->encoder endEncoding];
}

void renderCommandEncoderDrawPrimitives(RenderCommandEncoder *self, uint64_t type, uint64_t start, uint64_t count) {
    [self->encoder drawPrimitives:type vertexStart:start vertexCount:count];
}

void renderCommandEncoderDrawIndexedPrimitives(RenderCommandEncoder *self, uint64_t type, uint64_t index_count, uint64_t index_type, Buffer *index_buffer, uint64_t index_buffer_offset) {
    [self->encoder drawIndexedPrimitives:type 
                              indexCount:index_count 
                               indexType:index_type 
                             indexBuffer:index_buffer->buffer
                       indexBufferOffset:index_buffer_offset];
}

void renderCommandEncoderSetFragmentTexture(RenderCommandEncoder *self, Texture texture, uint64_t index) {
    [self->encoder setFragmentTexture:texture.texture atIndex:index];
}


int textureDescriptorInit(TextureDescriptor *self) {
    self->desc = [[MTLTextureDescriptor alloc] init];

    if (self->desc == nil) {
        return MB_ERR;
    }

    [self->desc retain];
    return MB_OK;
}

void textureDescriptorDeinit(TextureDescriptor *self) {
    if (self->desc) {
        [self->desc release];
    }
}

int textureDescriptorInit2DWithPixelFormat(TextureDescriptor *self, uint64_t format, uint64_t width, uint64_t height, MBBool mipmapped) {
    self->desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:format 
                                                                    width:width 
                                                                   height:height 
                                                                mipmapped: (mipmapped != MB_FALSE)];
    if (self->desc == nil) {
        return MB_ERR;
    }

    [self->desc retain];
    return MB_OK;
}

void textureDeinit(Texture *self) {
    if (self->texture) {
        [self->texture release];
    }
}
