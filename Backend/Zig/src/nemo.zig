const std = @import("std");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

var gpa: GeneralPurposeAllocator(.{}) = undefined;
var nemo_list: std.ArrayList(Nemo) = undefined;

pub const Nemo = struct {};

export fn nemoGlobalInit() c_int {
    gpa = GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    nemo_list = std.ArrayList(Nemo).initCapacity(allocator, 10) catch {
        return -1;
    };

    return 0;
}

export fn nemoGlobalDeinit() c_int {
    _ = gpa.detectLeaks();
    _ = gpa.deinit();

    return 0;
}

test {}
