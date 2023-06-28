#ifndef nemo_zig_lib_h
#define nemo_zig_lib_h

#include "../../Shared/Include/nemo_editor_window.h"

void nemoInit(nemo_NemoEditorWindow *);
void nemoDeinit(void);
void nemoFrame(nemo_NemoEditorWindow *);
void *nemoMetalDevice(nemo_NemoEditorWindow *);

#endif
