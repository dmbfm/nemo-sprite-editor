#ifndef nemo_zig_lib_h
#define nemo_zig_lib_h

#include <stdint.h>
#include "../../Shared/Include/nemo_editor_window.h"

typedef uint64_t NemoHandle;

// Global backend functions
void nemoBackendInit();
void nemoBackendDeinit();
NemoHandle nemoBackendCreateInstance(nemo_NemoEditorWindow *window);
void nemoBackendDestroyInstance(NemoHandle handle);

// Instance backend functions
void *nemoGetMetalDevice(NemoHandle handle);
int nemoFrame(NemoHandle handle);

#endif
