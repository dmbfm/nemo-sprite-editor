//
//  nemo_editor_window.h
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

#ifndef nemo_editor_window_h
#define nemo_editor_window_h

#include <stdio.h>
#include <stdint.h>
#include "../../Metal/Bindings/metal_bindings.h"

typedef struct nemo_NemoEditorWindow {
    struct {
        double x;
        double y;
    } mouse;
    
    ClearColor clear_color;
    const void *current_render_pass_descriptor;
    const void *current_drawable;
    
} nemo_NemoEditorWindow;

double nemo_NemoEditorWindow_mouseX(nemo_NemoEditorWindow *self);
double nemo_NemoEditorWindow_mouseY(nemo_NemoEditorWindow *self);
const void *nemo_NemoEditorWindow_currentRenderPassDescriptor(nemo_NemoEditorWindow *self);
const void *nemo_NemoEditorWindow_currentDrawable(nemo_NemoEditorWindow *self);
void nemo_NemoEditorWindow_setClearColor(nemo_NemoEditorWindow *self, ClearColor color);

#endif /* nemo_editor_window_h */
