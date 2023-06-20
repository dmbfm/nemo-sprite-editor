//
//  nemo_view_context.m
//  nemosprite
//
//  Created by Daniel Fortes on 19/06/23.
//

#import <Foundation/Foundation.h>
#include <Metal/Metal.h>
#include "nemo_view_context.h"
#include "nemo_view.h"

#if __has_feature(objc_arc)
    #error "This file should be compiled wihtout ARC."
#endif

const void *NemoViewContext_currentDrawable(NemoViewContext *self) {
    return (void *)[(NemoView *)self->view currentDrawable];
}

const void *NemoViewContext_currentRenderPassDescriptor(NemoViewContext *self) {
    return (void *)[(NemoView *)self->view currentRenderPassDescriptor];
}

void NemoViewContext_setClearColor(NemoViewContext *self, ClearColor c) {
    [(NemoView *)self->view setClearColor:MTLClearColorMake(c.r, c.g, c.b, c.a)];
}





