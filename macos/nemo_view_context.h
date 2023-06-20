//
//  nemo_view_context.h
//  nemosprite
//
//  Created by Daniel Fortes on 19/06/23.
//

#ifndef nemo_view_context_h
#define nemo_view_context_h

#include "metal_bindings.h"

typedef struct NemoViewContext {
    void *view;
    double mouse_x;
    double mouse_y;
} NemoViewContext;

const void *NemoViewContext_currentDrawable(NemoViewContext *self);
const void *NemoViewContext_currentRenderPassDescriptor(NemoViewContext *self);
void NemoViewContext_setClearColor(NemoViewContext *self, ClearColor);

#endif /* nemo_view_context_h */
