//
//  nemo_editor_window.c
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

#include "Include/nemo_editor_window.h"

double nemo_NemoEditorWindow_mouseX(nemo_NemoEditorWindow *self) {
    return self->mouse.x;
}

double nemo_NemoEditorWindow_mouseY(nemo_NemoEditorWindow *self) {
    return self->mouse.y;
}

const void *nemo_NemoEditorWindow_currentRenderPassDescriptor(nemo_NemoEditorWindow *self) {
    return self->current_render_pass_descriptor_callback(self->platform_data);
}

const void *nemo_NemoEditorWindow_currentDrawable(nemo_NemoEditorWindow *self) {
    return self->current_drawable_callback(self->platform_data);
}

void nemo_NemoEditorWindow_setClearColor(nemo_NemoEditorWindow *self, ClearColor color) {
    self->clear_color = color;
}


