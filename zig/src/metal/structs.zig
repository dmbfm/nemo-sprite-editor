pub const ClearColor = struct {
    r: u64 = 0,
    g: u64 = 0,
    b: u64 = 0,
    a: u64 = 0,

    pub fn init(r: u64, g: u64, b: u64, a: u64) ClearColor {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};
