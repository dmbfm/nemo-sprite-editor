pub const Window = opaque {
    extern fn nemo_NemoEditorWindow_mouseX(self: *Window) f64;
    extern fn nemo_NemoEditorWindow_mouseY(self: *Window) f64;

    pub fn getMouseX(self: *Window) f64 {
        return nemo_NemoEditorWindow_mouseX(self);
    }

    pub fn getMouseY(self: *Window) f64 {
        return nemo_NemoEditorWindow_mouseY(self);
    }
};
