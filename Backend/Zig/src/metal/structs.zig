pub const ClearColor = extern struct {
    r: f64 = 0,
    g: f64 = 0,
    b: f64 = 0,
    a: f64 = 0,

    pub fn init(r: f64, g: f64, b: f64, a: f64) ClearColor {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};

pub const Viewport = extern struct {
    x: f64 = 0,
    y: f64 = 0,
    w: f64 = 0,
    h: f64 = 0,
    znear: f64 = 0,
    zfar: f64 = 0,

    pub fn init(x: f64, y: f64, w: f64, h: f64) Viewport {
        return .{ .x = x, .y = y, .w = w, .h = h, .znear = 0, .zfar = 1 };
    }
};

pub const ScissorRect = extern struct {
    x: f64 = 0,
    y: f64 = 0,
    w: f64 = 0,
    h: f64 = 0,

    pub fn init(x: f64, y: f64, w: f64, h: f64) ScissorRect {
        return .{ .x = x, .y = y, .w = w, .h = h };
    }
};

pub const Origin = extern struct {
    x: u64 = 0,
    y: u64 = 0,
    z: u64 = 0,
};

pub const Size = extern struct {
    width: u64 = 1,
    height: u64 = 1,
    depth: u64 = 1,
};

pub const Region = extern struct {
    origin: Origin,
    size: Size,

    pub fn init2D(x: u64, y: u64, w: u64, h: u64) Region {
        return .{
            .origin = .{ .x = x, .y = y, .z = 0 },
            .size = .{ .width = w, .height = h, .depth = 1 },
        };
    }
};
