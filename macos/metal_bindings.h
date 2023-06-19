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


typedef void *ID;
typedef ID Device;
typedef ID Drawable;
typedef ID CommandQueue;
typedef ID CommandBuffer;
typedef ID RenderPassDescriptor;
typedef ID Library;
typedef ID Buffer;
typedef ID RenderPipelineState;
typedef ID RenderPipelineDescriptor;
typedef ID Texture;
typedef ID TextureDescriptor;
typedef ID RenderCommandEncoder;

void release(void *);

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

void CommandBuffer_commit(CommandBuffer self);
void CommandBuffer_presentDrawable(CommandBuffer self, Drawable drawable);
void CommandBuffer_addCompletedHandler(CommandBuffer self, void (*cb)(CommandBuffer));
void CommandBuffer_setLabel(CommandBuffer self, const char *label);

#endif /* metal_bindings_h */
