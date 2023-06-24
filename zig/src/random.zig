const std = @import("std");

var instance: ?std.rand.DefaultPrng = null;

pub fn int(comptime T: type) T {
    if (instance == null) {
        instance = std.rand.DefaultPrng.init(0);
    }

    return instance.?.random().int(T);
}

pub fn intRange(comptime T: type, min: T, max: T) T {
    if (instance == null) {
        instance = std.rand.DefaultPrng.init(0);
    }

    return instance.?.random().intRangeAtMost(T, min, max);
}
