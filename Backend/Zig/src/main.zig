const std = @import("std");
const mtl = @import("metal.zig");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const DynamicPool = @import("dynamic-pool.zig").DynamicPool;
const Nemo = @import("nemo.zig");
const Window = @import("window.zig").Window;

var gpa: GeneralPurposeAllocator(.{}) = undefined;
var nemo_pool: DynamicPool(Nemo) = undefined;

export fn nemoBackendInit() c_int {
    gpa = GeneralPurposeAllocator(.{}){};

    nemo_pool = DynamicPool(Nemo).init(gpa.allocator());

    return 0;
}

export fn nemoBackendDeinit() c_int {
    nemo_pool.deinit();
    _ = gpa.detectLeaks();
    _ = gpa.deinit();

    return 0;
}

export fn nemoBackendCreateInstance(window: *Window) u64 {
    var handle = nemo_pool.alloc() catch return 0;
    var instance: *Nemo = nemo_pool.get(handle).?;

    instance.init(window) catch {
        nemo_pool.free(handle);
        return 0;
    };

    return handle;
}

export fn nemoBackendDestroyInstance(handle: u64) void {
    var instance: *Nemo = nemo_pool.get(handle).?;
    instance.deinit();
    nemo_pool.free(handle);
}

export fn nemoGetMetalDevice(handle: u64) *mtl.Device {
    var instance: *Nemo = nemo_pool.get(handle).?;
    return instance.getMetalDevice();
}

export fn nemoFrame(handle: u64) c_int {
    var instance: *Nemo = nemo_pool.get(handle).?;
    instance.frame() catch {
        return -1;
    };

    return 0;
}

test {}
