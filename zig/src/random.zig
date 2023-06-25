const std = @import("std");

var instance: ?std.rand.DefaultPrng = null;

fn random() std.rand.Random {
    if (instance == null) {
        instance = std.rand.DefaultPrng.init(0);
    }

    return instance.?.random();
}

pub fn int(comptime T: type) T {
    return random().int(T);
}

pub fn intRange(comptime T: type, min: T, max: T) T {
    return random().intRangeAtMost(T, min, max);
}

pub fn float(comptime T: type) T {
    return random().float(T);
}

pub fn floatRange(comptime T: type, min: T, max: T) T {
    var x = float(T);

    return (max - min) * x + min;
}
