const Function = @import("function.zig").Function;

pub const Library = opaque {
    const Error = error{
        NewFunctionError,
    };

    extern fn release(self: *Library) void;
    extern fn Library_newFunctionWithName(self: *Library, name: [*:0]const u8) ?*Function;

    pub fn deinit(self: *Library) void {
        release(self);
    }

    pub fn newFunctionWithName(self: *Library, name: [:0]const u8) Error!Function {
        var result = Library_newFunctionWithName(self, name.ptr);
        if (result == null) {
            return Error.NewFunctionError;
        }
        return result.?;
    }
};
