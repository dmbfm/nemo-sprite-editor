const std = @import("std");

pub const Vec2f = Vec2(f32);
pub const Vec3f = Vec3(f32);
pub const Vec4f = Vec4(f32);

pub const Vec2d = Vec2(f64);
pub const Vec3d = Vec3(f64);
pub const Vec4d = Vec4(f64);

pub const Mat4f = Mat4(f32);
pub const Mat4d = Mat4(f64);

pub const Quaternionf = Quaternion(f32);
pub const Quaterniond = Quaternion(f64);

pub fn Vec2(comptime T: type) type {
    if (!std.meta.trait.isFloat(T)) {
        @compileError("Expected f32 of f64");
    }

    return extern struct {
        x: T = 0,
        y: T = 0,

        const Self = @This();

        pub fn init(x: T, y: T) Self {
            return Self{ .x = x, .y = y };
        }

        pub fn add(a: Self, b: Self) Self {
            return .{
                .x = a.x + b.x,
                .y = a.y + b.y,
            };
        }

        pub fn sub(a: Self, b: Self) Self {
            return .{
                .x = a.x - b.x,
                .y = a.y - b.y,
            };
        }

        pub fn mul(a: Self, b: T) Self {
            return .{
                .x = a.x * b,
                .y = a.y * b,
            };
        }

        pub fn div(a: Self, b: T) Self {
            return .{
                .x = a.x / b,
                .y = a.y / b,
            };
        }

        pub fn dot(a: Self, b: Self) T {
            return a.x * b.x + a.y * b.y;
        }

        pub fn length(a: Self) T {
            return std.math.sqrt(a.x * a.x + a.y * a.y);
        }

        pub fn distance(a: Self, b: Self) T {
            return a.sub(b).length();
        }

        pub fn normalize(a: Self) Self {
            var len: T = a.length();

            if (len == 0) {
                return a;
            }

            return a.mul(@as(T, 1.0) / @as(T, len));
        }

        pub fn equal(a: Self, b: Self) bool {
            return a.x == b.x and a.y == b.y;
        }

        pub fn approxEqual(a: Self, b: Self, eps: T) bool {
            return std.math.approxEqAbs(T, a.x, b.x, eps) and
                std.math.approxEqAbs(T, a.y, b.y, eps);
        }

        pub fn axisX() Self {
            return .{ .x = 1, .y = 0 };
        }

        pub fn axisY() Self {
            return .{ .x = 0, .y = 1 };
        }

        pub fn toOwnedSlice(a: Self, alloctor: std.mem.Allocator) ![]T {
            var r = try alloctor.alloc(T, 2);

            r[0] = a.x;
            r[1] = a.y;

            return r;
        }
    };
}

pub fn Vec3(comptime T: type) type {
    if (!std.meta.trait.isFloat(T)) {
        @compileError("Expected f32 or f64");
    }

    return extern struct {
        x: T = 0,
        y: T = 0,
        z: T = 0,

        const Self = @This();

        pub fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }

        pub fn random(rand_impl: std.rand.Random, min: T, max: T) Self {
            return Self{
                .x = min + rand_impl.float(T) * (max - min),
                .y = min + rand_impl.float(T) * (max - min),
                .z = min + rand_impl.float(T) * (max - min),
            };
        }

        pub fn add(a: Self, b: Self) Self {
            return .{
                .x = a.x + b.x,
                .y = a.y + b.y,
                .z = a.z + b.z,
            };
        }

        pub fn sub(a: Self, b: Self) Self {
            return .{
                .x = a.x - b.x,
                .y = a.y - b.y,
                .z = a.z - b.z,
            };
        }

        pub fn mul(a: Self, b: T) Self {
            return .{
                .x = a.x * b,
                .y = a.y * b,
                .z = a.z * b,
            };
        }

        pub fn div(a: Self, b: T) Self {
            return .{
                .x = a.x / b,
                .y = a.y / b,
                .z = a.z / b,
            };
        }

        pub fn dot(a: Self, b: Self) T {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }

        pub fn cross(a: Self, b: Self) Self {
            return .{
                .x = a.y * b.z - a.z * b.y,
                .y = a.z * b.x - a.x * b.z,
                .z = a.x * b.y - a.y * b.x,
            };
        }

        pub fn length(a: Self) T {
            return std.math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
        }

        pub fn distance(a: Self, b: Self) T {
            return a.sub(b).length();
        }

        pub fn normalize(a: Self) Self {
            var len = a.length();
            if (len == 0) {
                return a;
            }
            return a.div(len);
        }

        pub fn equal(a: Self, b: Self) bool {
            return a.x == b.x and a.y == b.y and a.z == b.z;
        }

        pub fn approxEqual(a: Self, b: Self, eps: T) bool {
            return std.math.approxEqAbs(T, a.x, b.x, eps) and
                std.math.approxEqAbs(T, a.y, b.y, eps) and
                std.math.approxEqAbs(T, a.z, b.z, eps);
        }

        pub fn axisX() Self {
            return .{ .x = 1.0, .y = 0, .z = 0 };
        }

        pub fn axisY() Self {
            return .{ .x = 0.0, .y = 1.0, .z = 0 };
        }

        pub fn axisZ() Self {
            return .{ .x = 0.0, .y = 0, .z = 1.0 };
        }

        pub fn toOwnedSlice(a: Self, alloctor: std.mem.Allocator) ![]T {
            var r = try alloctor.alloc(T, 3);

            r[0] = a.x;
            r[1] = a.y;
            r[2] = a.z;

            return r;
        }
    };
}

pub fn Vec4(comptime T: type) type {
    if (!std.meta.trait.isFloat(T)) {
        @compileError("Expected f32 or f64");
    }

    return extern struct {
        x: T = 0,
        y: T = 0,
        z: T = 0,
        w: T = 0,

        const Self = @This();

        pub fn init(x: T, y: T, z: T, w: T) Self {
            return Self{ .x = x, .y = y, .z = z, .w = w };
        }

        pub fn add(a: Self, b: Self) Self {
            return .{
                .x = a.x + b.x,
                .y = a.y + b.y,
                .z = a.z + b.z,
                .w = a.w + b.w,
            };
        }

        pub fn sub(a: Self, b: Self) Self {
            return .{
                .x = a.x - b.x,
                .y = a.y - b.y,
                .z = a.z - b.z,
                .w = a.w - b.w,
            };
        }

        pub fn mul(a: Self, b: T) Self {
            return .{
                .x = a.x * b,
                .y = a.y * b,
                .z = a.z * b,
                .w = a.w * b,
            };
        }

        pub fn div(a: Self, b: T) Self {
            return .{
                .x = a.x / b,
                .y = a.y / b,
                .z = a.z / b,
                .w = a.w / b,
            };
        }

        pub fn dot(a: Self, b: Self) T {
            return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
        }

        pub fn length(a: Self) T {
            return std.math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z + a.w * a.w);
        }

        pub fn distance(a: Self, b: Self) T {
            return a.sub(b).length();
        }

        pub fn normalize(a: Self) Self {
            var len = a.length();
            if (len == 0) {
                return a;
            }
            return a.div(len);
        }

        pub fn equal(a: Self, b: Self) bool {
            return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w;
        }

        pub fn approxEqual(a: Self, b: Self, eps: T) bool {
            return std.math.approxEqAbs(T, a.x, b.x, eps) and
                std.math.approxEqAbs(T, a.y, b.y, eps) and
                std.math.approxEqAbs(T, a.z, b.z, eps) and
                std.math.approxEqAbs(T, a.w, b.w, eps);
        }

        pub fn axisX() Self {
            return .{ .x = 1, .y = 0, .z = 0, .w = 0 };
        }

        pub fn axisY() Self {
            return .{ .x = 0, .y = 1, .z = 0, .w = 0 };
        }

        pub fn axisZ() Self {
            return .{ .x = 0, .y = 0, .z = 1, .w = 0 };
        }

        pub fn axisW() Self {
            return .{ .x = 0, .y = 0, .z = 0, .w = 1 };
        }

        pub fn toOwnedSlice(a: Self, alloctor: std.mem.Allocator) ![]T {
            var r = try alloctor.alloc(T, 4);

            r[0] = a.x;
            r[1] = a.y;
            r[2] = a.z;
            r[3] = a.w;

            return r;
        }
    };
}

pub fn Quaternion(comptime T: type) type {
    return extern struct {
        a: T = 0,
        b: T = 0,
        c: T = 0,
        d: T = 0,

        const Self = @This();

        pub fn init(a: T, b: T, c: T, d: T) Self {
            return .{
                .a = a,
                .b = b,
                .c = c,
                .d = d,
            };
        }

        pub fn identity() Self {
            return .{ .a = 1 };
        }

        pub fn add(q1: Self, q2: Self) Self {
            return .{
                .a = q1.a + q2.a,
                .b = q1.b + q2.b,
                .c = q1.c + q2.c,
                .d = q1.d + q2.d,
            };
        }

        pub fn sub(q1: Self, q2: Self) Self {
            return .{
                .a = q1.a - q2.a,
                .b = q1.b - q2.b,
                .c = q1.c - q2.c,
                .d = q1.d - q2.d,
            };
        }

        pub fn mulScalar(q: Self, x: T) Self {
            return .{
                .a = x * q.a,
                .b = x * q.b,
                .c = x * q.c,
                .d = x * q.d,
            };
        }

        pub fn mul(q1: Self, q2: Self) Self {
            return .{
                .a = q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
                .b = q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
                .c = q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
                .d = q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a,
            };
        }

        pub fn scalar(q: Self) T {
            return q.a;
        }

        pub fn vector(q: Self) Vec3(T) {
            return Vec3(T).init(q.b, q.c, q.d);
        }

        pub fn conjugate(q: Self) Self {
            return .{
                .a = q.a,
                .b = -q.b,
                .c = -q.c,
                .d = -q.d,
            };
        }

        pub fn length(q: Self) T {
            return std.math.sqrt(q.mul(q.conjugate()).a);
        }

        pub fn distance(q1: Self, q2: Self) T {
            return q1.sub(q2).length();
        }

        pub fn normalize(q: Self) Self {
            return q.mulScalar(1 / q.length());
        }

        pub fn axisAngleFast(u: Vec3(T), angle: T) Self {
            var c = std.math.cos(angle / 2.0);
            var s = std.math.sin(angle / 2.0);

            return .{
                .a = c,
                .b = u.x * s,
                .c = u.y * s,
                .d = u.z * s,
            };
        }

        pub fn axisAngle(u: Vec3(T), angle: T) Self {
            var c = std.math.cos(angle / 2.0);
            var s = std.math.sin(angle / 2.0);

            var unorm = u.normalize();

            return .{
                .a = c,
                .b = unorm.x * s,
                .c = unorm.y * s,
                .d = unorm.z * s,
            };
        }

        pub fn rotationMatrixFastOut(q: Self, out: *Mat4(T)) void {
            var qr = q.a;
            var qi = q.b;
            var qj = q.c;
            var qk = q.d;

            //var qq = @Vector(4, T);
            var qi2 = qi * qi;
            var qj2 = qj * qj;
            var qk2 = qk * qk;
            var qij = qi * qj;
            var qkr = qk * qr;
            var qik = qi * qk;
            var qir = qi * qr;
            var qjr = qj * qr;
            var qjk = qj * qk;

            out.data[0] = 1 - 2 * (qj2 + qk2);
            out.data[1] = 2 * (qij + qkr);
            out.data[2] = 2 * (qik - qjr);
            out.data[3] = 0;

            out.data[4] = 2 * (qij - qkr);
            out.data[5] = 1 - 2 * (qi2 + qk2);
            out.data[6] = 2 * (qjk + qir);
            out.data[7] = 0;

            out.data[8] = 2 * (qik + qjr);
            out.data[9] = 2 * (qjk - qir);
            out.data[10] = 1 - 2 * (qi2 + qj2);
            out.data[11] = 0;

            out.data[12] = 0;
            out.data[13] = 0;
            out.data[14] = 0;
            out.data[15] = 0;
        }

        pub fn rotationMatrixFast(q: Self) Mat4(T) {
            var qr = q.a;
            var qi = q.b;
            var qj = q.c;
            var qk = q.d;

            //var qq = @Vector(4, T);
            var qi2 = qi * qi;
            var qj2 = qj * qj;
            var qk2 = qk * qk;
            var qij = qi * qj;
            var qkr = qk * qr;
            var qik = qi * qk;
            var qir = qi * qr;
            var qjr = qj * qr;
            var qjk = qj * qk;

            return Mat4(T).initValues(
                1 - 2 * (qj2 + qk2),
                2 * (qij - qkr),
                2 * (qik + qjr),
                0,
                2 * (qij + qkr),
                1 - 2 * (qi2 + qk2),
                2 * (qjk - qir),
                0,
                2 * (qik - qjr),
                2 * (qjk + qir),
                1 - 2 * (qi2 + qj2),
                0,
                0,
                0,
                0,
                1,
            );
        }

        // zig-fmt: off
        pub fn rotationMatrix(q: Self) Mat4(T) {
            //var len = q.length();
            var len2 = q.a * q.a + q.b * q.b + q.c * q.c + q.d * q.d;
            //var len2 = q.mul(q.conjugate()).a;
            var s = 1.0 / len2;

            var qr = q.a;
            var qi = q.b;
            var qj = q.c;
            var qk = q.d;

            return Mat4(T).initValues(
                1 - 2 * s * (qj * qj + qk * qk),
                2 * s * (qi * qj - qk * qr),
                2 * s * (qi * qk + qj * qr),
                0,
                2 * s * (qi * qj + qk * qr),
                1 - 2 * s * (qi * qi + qk * qk),
                2 * s * (qj * qk - qi * qr),
                0,
                2 * s * (qi * qk - qj * qr),
                2 * s * (qj * qk + qi * qr),
                1 - 2 * s * (qi * qi + qj * qj),
                0,
                0,
                0,
                0,
                1,
            );
        }
        // zig-fmt: off

        // Creates a quaternion from euler anglex x, y and z, representing external rotations
        // in the ZXY order.
        pub fn euler(x: T, y: T, z: T) Self {
            return Self.axisAngle(Vec3(T).axisY(), y).mul(Self.axisAngle(Vec3(T).axisX(), x).mul(Self.axisAngle(Vec3(T).axisZ(), z)));
        }

        pub fn equal(q1: Self, q2: Self) bool {
            return q1.a == q2.a and
                q1.b == q2.b and
                q1.c == q2.c and
                q1.d == q2.d;
        }

        pub fn approxEqual(q1: Self, q2: Self, eps: T) bool {
            return std.math.approxEqAbs(T, q1.a, q2.a, eps) and
                std.math.approxEqAbs(T, q1.b, q2.b, eps) and
                std.math.approxEqAbs(T, q1.c, q2.c, eps) and
                std.math.approxEqAbs(T, q1.d, q2.d, eps);
        }
    };
}

pub fn Mat4(comptime T: type) type {
    return extern struct {
        data: [16]T = [_]T{0} ** 16,

        const Self = @This();

        // zig-fmt: off
        pub const identity = Self{ .data = .{
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        } };
        // zig-fmt: on

        pub fn init() Self {
            return .{};
        }

        // zig fmt: off
        pub fn initValues(
            m00: T, m01: T, m02: T, m03: T, 
            m10: T, m11: T, m12: T, m13: T, 
            m20: T, m21: T, m22: T, m23: T, 
            m30: T, m31: T, m32: T, m33: T) Self {
            return .{
                .data = .{
                    m00, m10, m20, m30,
                    m01, m11, m21, m31,
                    m02, m12, m22, m32,
                    m03, m13, m23, m33,
                },
            };
        }


        pub fn initColumns(c0: Vec4(T), c1: Vec4(T), c2: Vec4(T), c3: Vec4(T)) Self {
            return .{ .data = .{
                c0.x, c0.y, c0.z, c0.w,
                c1.x, c1.y, c1.z, c1.w,
                c2.x, c2.y, c2.z, c2.w,
                c3.x, c3.y, c3.z, c3.w,
            }};
        }

        pub fn initRows(r0: Vec4(T), r1: Vec4(T), r2: Vec4(T), r3: Vec4(T)) Self {
            return .{ .data = .{
                r0.x, r1.x, r2.x, r3.x,
                r0.y, r1.y, r2.y, r3.y,
                r0.z, r1.z, r2.z, r3.z,
                r0.w, r1.w, r2.w, r3.w,
            }};
        }


        pub inline fn setValues(m: *Self, 
            m00: T, m01: T, m02: T, m03: T, 
            m10: T, m11: T, m12: T, m13: T, 
            m20: T, m21: T, m22: T, m23: T, 
            m30: T, m31: T, m32: T, m33: T,
            ) void {

            m.data[0] = m00;
            m.data[1] = m10;
            m.data[2] = m20;
            m.data[3] = m30;
            m.data[4] = m01;
            m.data[5] = m11;
            m.data[6] = m21;
            m.data[7] = m31;
            m.data[8] = m02;
            m.data[9] = m12;
            m.data[10] = m22;
            m.data[11] = m32;
            m.data[12] = m03;
            m.data[13] = m13;
            m.data[14] = m23;
            m.data[15] = m33;
        }

        pub fn transpose(m: Self) Self {
            return .{ .data = . {
                m.data[0], m.data[4], m.data[8], m.data[12],
                m.data[1], m.data[5], m.data[9], m.data [13],
                m.data[2], m.data[6], m.data[10], m.data[14],
                m.data[3], m.data[7], m.data[11], m.data[15],
            }};
        }
 
        pub inline fn element(m: Self, comptime line: usize, comptime column: usize) !*T {
            const idx = 4 * line + column;

            if (idx >= 16) {
                return error.IndexOutOfRange;
            }

            return &m.data[idx];
        }       

        //pub fn identity() Self {
        //    return .{ .data = .{ 
        //        1, 0, 0, 0,
        //        0, 1, 0, 0,
        //        0, 0, 1, 0,
        //        0, 0, 0, 1,
        //    }};
        //}

        pub fn add(a: Self, b: Self) Self {
            var m = Self{};

            inline for (0..16) |i| {
                m.data[i] = a.data[i] + b.data[i];
            }

            return m;
        }

        pub fn sub(a: Self, b: Self) Self {
            var m = Self{};

            inline for (0..16) |i| {
                m.data[i] = a.data[i] - b.data[i];
            }

            return m;
        }

        pub fn mul(a: Self, b: Self) Self {
            var m = Self{};

            inline for (0..4) |i| {
                inline for (0..4) |j| {
                    m.data[4 * j + i] = 0;
                    inline for (0..4) |k| {
                        m.data[4 * j + i] += a.data[4 * k + i] * b.data[4 * j + k];
                    }
                }
            }

            return m;
        }

        pub fn det(a: Self) T {
            const m11 = *(a.element(0, 0) catch { });
            const m12 = *(a.element(0, 1) catch { });
            const m13 = *(a.element(0, 2) catch { });
            const m14 = *(a.element(0, 3) catch { });

            const m21 = *(a.element(1, 0) catch { });
            const m22 = *(a.element(1, 1) catch { });
            const m23 = *(a.element(1, 2) catch { });
            const m24 = *(a.element(1, 3) catch { });

            const m31 = *(a.element(2, 0) catch { });
            const m32 = *(a.element(2, 1) catch { });
            const m33 = *(a.element(2, 2) catch { });
            const m34 = *(a.element(2, 3) catch { });

            const m41 = *(a.element(3, 0) catch { });
            const m42 = *(a.element(3, 1) catch { });
            const m43 = *(a.element(3, 2) catch { });
            const m44 = *(a.element(3, 3) catch { });

            return m11 * m22 * m33 * m44 + m11 * m23 * m34 * m42 + m11 * m24 * m32 * m43 
                 - m11 * m24 * m33 * m42 - m11 * m23 * m32 * m44 - m11 * m22 * m34 * m43
                 - m12 * m21 * m33 * m44 - m13 * m21 * m34 * m42 - m14 * m21 * m32 * m43
                 + m14 * m21 * m33 * m42 + m13 * m21 * m32 * m44 + m12 * m21 * m34 * m43
                 + m12 * m23 * m31 * m44 + m13 * m24 * m31 * m42 + m14 * m22 * m31 * m43
                 - m14 * m23 * m31 * m42 - m13 * m22 * m31 * m44 - m12 * m24 * m31 * m43
                 - m12 * m23 * m34 * m41 - m13 * m24 * m32 * m41 - m14 * m22 * m33 * m41
                 + m14 * m23 * m32 * m41 + m13 * m22 * m34 * m41 + m12 * m24 * m33 * m41;
        }

        pub fn mulScalar(a: Self, x: T) Self {
            var m = Self{};

            inline for (0..16) |i| {
                m.data[i] = x * a.data[i];
            }

            return m;
        }
        
        pub fn divScalar(a: Self, x: T) Self {
            var m = Self{};

            inline for (0..16) |i| {
                m.data[i] = a.data[i] / x;
            }

            return m;
        }
 
        pub fn translation(v: Vec3(T)) Self {
            return Self.initValues(
                1, 0, 0, v.x,
                0, 1, 0, v.y,
                0, 0, 1, v.z,
                0, 0, 0, 1,
            );
        }

        pub fn scale(v: Vec3(T)) Self {
            return Self.initValues(
                v.x,   0,   0, 0,
                0,   v.y,   0, 0,
                0,     0, v.z, 0,
                0,     0,   0, 1,
            );
        }

        pub fn rotateX(angle: T) Self {
            var s = std.math.sin(angle);
            var c = std.math.cos(angle);

            return Self.initValues( 
                1, 0,  0, 0,
                0, c, -s, 0,
                0, s,  c, 0,
                0, 0,  0, 1,
            );
        }

        pub fn rotateY(angle: T) Self {
            var s = std.math.sin(angle);
            var c = std.math.cos(angle);

            return Self.initValues(
                 c, 0, s, 0,
                 0, 1, 0, 0,
                -s, 0, c, 0,
                 0, 0, 0, 1,
            );
        }

        pub fn rotateZ(angle: T) Self {
            var s = std.math.sin(angle);
            var c = std.math.cos(angle);

            return Self.initValues(
                c, -s, 0, 0,
                s,  c, 0, 0,
                0,  0, 1, 0,
                0,  0, 0, 1,
            );
        }

        pub fn rotateAxisAngle(u: Vec3(T), angle: T) Self {
            var s = std.math.sin(angle);
            var c = std.math.cos(angle);
            u = u.normalize();

            return Self.initValues(
                c + u.x * u.x * (1 - c),       u.x * u.y * (1 - c) - u.z * s,  u.x * u.z * (1 - c) + u.y * s, 0,
                u.y * u.z * (1 - c) + u.z * s,       c + u.y * u.y * (1 - c),  u.y * u.z * (1 - c) - u.x * s, 0,
                u.z * u.x * (1 - c) - u.y * s, u.z * u.y * (1 - c) + u.x * s,        c + u.z * u.z * (1 - c), 0,
                                            0,                             0,                              0, 1,
            );
        }

        /// Returns a look at matrix with camera positioned at `eye`
        /// looking at `target` with a given `up` direction.
        pub fn looAt(eye: Vec3(T), target: Vec3(T), up: Vec3(T)) Self {
            var upnorm = up.normalize();
            var zprime = eye.sub(target).normalize();
            var xprime = upnorm.cross(zprime);
            var yprime = zprime.cross(xprime);

            return Self.initValues(
                xprime.x, xprime.y, xprime.z, -xprime.dot(eye),
                yprime.x, yprime.y, yprime.z, -yprime.dot(eye),
                zprime.x, zprime.y, zprime.z, -zprime.dot(eye),
                       0,        0,        0,                1,
            );
        }

        /// Returns an orthographic projection matrix from a right-handed 
        /// coordinate system onto metal's NDC system, which is a left-handed
        /// coordinate system with a clip cuboid with corners from (-1, -1, 0)
        /// to (1, 1, 1).
        pub fn ortho(width: T, height: T, near: T, far: T) Self {
            return Self.initValues(
                1.0 / width,            0,                   0,                     0,
                          0, 1.0 / height,                   0,                     0, 
                          0,            0, -1.0 / (far - near), - near / (far - near),
                          0,            0,                   0,                     1,
            );
        }


        pub fn equal(a: Self, b: Self) bool {
            var eql = true;

            inline for (0..16) |i| {
                eql = eql and a.data[i] == b.data[i];
                if (!eql) {
                    return false;
                }
            }

            return true;
        }

        pub fn approxEqual(a: Self, b: Self, eps: T) bool {
            var eql = true;

            inline for (0..16) |i| {
                eql = eql and std.math.approxEqAbs(T, a.data[i], b.data[i], eps);
                if (!eql) {
                    return false;
                }
            }

            return true;
        }

        pub fn toSlice(m: Self) []T {
            return &m.data;
        }

        pub fn toOwnedSlice(m: Self, allocator: std.mem.Allocator) ![]T {
            var slice = try allocator.alloc(T, 16);
            @memcpy(slice, &m.data);
            return slice;
        }

        // zig fmt: on
    };
}

const t = std.testing;

test "Vec2 addition" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    var y = Vec2(f32){ .x = 3.0, .y = 4.0 };
    var z = Vec2(f32){ .x = 4.0, .y = 6.0 };

    try t.expect(x.add(y).approxEqual(z, 0.0001));
}

test "Vec2 subtraction" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    var y = Vec2(f32){ .x = 3.0, .y = 4.0 };
    var z = Vec2(f32){ .x = 2.0, .y = 2.0 };

    try t.expect(y.sub(x).approxEqual(z, 0.0001));
}

test "Vec2 scalar multiplication" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    var y = Vec2(f32){ .x = 2.0, .y = 4.0 };

    try t.expect(x.mul(2).approxEqual(y, 0.0001));
}

test "Vec2 scalar division" {
    var x = Vec2(f32){ .x = 2.0, .y = 4.0 };
    var y = Vec2(f32){ .x = 1.0, .y = 2.0 };

    try t.expect(x.div(2).approxEqual(y, 0.0001));
}

test "Vec2 dot product" {
    var x = Vec2(f32){ .x = 2.0, .y = 4.0 };
    var y = Vec2(f32){ .x = 1.0, .y = 2.0 };

    try t.expect(x.dot(y) == 10);
}

test "Vec2 length" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    try t.expect(std.math.approxEqAbs(f32, x.length(), 2.23606797749979, 0.0001));
}

test "Vec2 normalize" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    try t.expect(std.math.approxEqAbs(
        f32,
        x.normalize().length(),
        1.0,
        0.0001,
    ));
}

test "Vec2 equal" {
    var x = Vec2(f32){ .x = 1.0, .y = 2.0 };
    var y = Vec2(f32){ .x = 2.0, .y = 4.0 };

    try t.expect(x.equal(x));
    try t.expect(!x.equal(y));
}

test "Vec2 toOwnedSlice" {
    var y = Vec2(f32){ .x = 2.0, .y = 4.0 };
    var slice = try y.toOwnedSlice(t.allocator_instance.allocator());
    defer t.allocator_instance.allocator().free(slice);
    var result = [_]f32{ 2.0, 4.0 };
    try t.expect(std.mem.eql(f32, slice, &result));
}

test "Vec3 equal" {
    var x = Vec3(f32){ .x = 1.0, .y = 2.0, .z = 3.0 };
    var y = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };

    try t.expect(x.equal(x));
    try t.expect(!x.equal(y));
}

test "Vec3 approx equal" {
    var x = Vec3(f32){ .x = 1.0, .y = 2.0, .z = 3.0 };
    var y = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };

    try t.expect(x.approxEqual(x, 0.0001));
    try t.expect(!x.approxEqual(y, 0.0001));
}

test "Vec3 addition" {
    var x = Vec3(f32){ .x = 1.0, .y = 2.0, .z = 3.0 };
    var y = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var z = Vec3(f32){ .x = 5.0, .y = 7.0, .z = 9.0 };

    try t.expect(x.add(y).approxEqual(z, 0.0001));
}

test "Vec3 subtraction" {
    var x = Vec3(f32){ .x = 1.0, .y = 2.0, .z = 3.0 };
    var y = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var z = Vec3(f32){ .x = -3.0, .y = -3.0, .z = -3.0 };

    try t.expect(x.sub(y).approxEqual(z, 0.0001));
}

test "Vec3 scalar multiplication" {
    var x = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var y = Vec3(f32){ .x = 8.0, .y = 10.0, .z = 12.0 };

    try t.expect(x.mul(2).approxEqual(y, 0.0001));
}

test "Vec3 scalar division" {
    var x = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var y = Vec3(f32){ .x = 8.0, .y = 10.0, .z = 12.0 };

    try t.expect(y.div(2).approxEqual(x, 0.0001));
}

test "Vec3 dot" {
    var x = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var y = Vec3(f32){ .x = 8.0, .y = 10.0, .z = 12.0 };

    try t.expect(x.dot(y) == 154);
}

test "Vec3 length" {
    var x = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };
    var result: f32 = 8.774964387392123;

    try t.expect(std.math.approxEqAbs(
        f32,
        x.length(),
        result,
        0.0001,
    ));
}

test "Vec3 normalize" {
    var x = Vec3(f32){ .x = 4.0, .y = 5.0, .z = 6.0 };

    try t.expect(std.math.approxEqAbs(
        f32,
        x.normalize().length(),
        1,
        0.0001,
    ));
}

test "Vec3 cross" {
    try t.expect(Vec3(f32).axisY().cross(Vec3(f32).axisZ()).equal(Vec3(f32).axisX()));
    try t.expect(Vec3(f32).axisX().cross(Vec3(f32).axisY()).equal(Vec3(f32).axisZ()));
    try t.expect(Vec3(f32).axisZ().cross(Vec3(f32).axisX()).equal(Vec3(f32).axisY()));
}

test "Vec3 toOwnedSlice" {
    var y = Vec3(f32){ .x = 2.0, .y = 4.0, .z = 6.0 };
    var slice = try y.toOwnedSlice(t.allocator_instance.allocator());
    defer t.allocator_instance.allocator().free(slice);
    var result = [_]f32{ 2.0, 4.0, 6.0 };
    try t.expect(std.mem.eql(f32, slice, &result));
}

test "Vec4 equal" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };

    try t.expect(x.equal(x));
}

test "Vec4 approxEqual" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 1.01, .y = 2.01, .z = 3.01, .w = 4.01 };

    try t.expect(x.approxEqual(y, 0.1));
    try t.expect(!x.approxEqual(y, 0.01));
}

test "Vec4 addition" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };
    var z = Vec4(f32){ .x = 6.0, .y = 8.0, .z = 10.0, .w = 12.0 };

    try t.expect(x.add(y).equal(z));
}

test "Vec4 subtraction" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };
    var z = Vec4(f32){ .x = 4.0, .y = 4.0, .z = 4.0, .w = 4.0 };

    try t.expect(y.sub(x).equal(z));
}

test "Vec4 scalar multiplication" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 2.0, .y = 4.0, .z = 6.0, .w = 8.0 };

    try t.expect(x.mul(2).equal(y));
}

test "Vec4 scalar division" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 2.0, .y = 4.0, .z = 6.0, .w = 8.0 };

    try t.expect(y.div(2).equal(x));
}

test "Vec4 dot" {
    var x = Vec4(f32){ .x = 1.0, .y = 2.0, .z = 3.0, .w = 4.0 };
    var y = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };
    var result: f32 = 70;

    try t.expect(x.dot(y) == result);
}

test "Vec4 length" {
    var x = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };
    var result: f32 = 13.19090595827292;

    try t.expect(std.math.approxEqAbs(
        f32,
        x.length(),
        result,
        0.0001,
    ));
}

test "Vec4 normalize" {
    var x = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };

    try t.expect(std.math.approxEqAbs(
        f32,
        x.normalize().length(),
        1,
        0.0001,
    ));
}

test "Vec4 toOwnedSlice" {
    var x = Vec4(f32){ .x = 5.0, .y = 6.0, .z = 7.0, .w = 8.0 };
    var slice = try x.toOwnedSlice(t.allocator_instance.allocator());
    defer t.allocator_instance.allocator().free(slice);
    var result = [_]f32{ 5.0, 6.0, 7.0, 8.0 };
    try t.expect(std.mem.eql(f32, slice, &result));
}

test "Math Ortho" {
    var m = Mat4(f32).ortho(1, 1, 0.1, 10);
    m = Mat4(f32).looAt(Vec3f.init(1, 1, 1), Vec3f.init(0, 0, 0), Vec3f.axisY());
}

test "Mat4 multiplication" {
    var a = Mat4(f32).initValues(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
    var b = Mat4(f32).initValues(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    var c = Mat4(f32).initValues(80, 90, 100, 110, 176, 202, 228, 254, 272, 314, 356, 398, 368, 426, 484, 542);

    try t.expect(a.mul(b).approxEqual(c, 0.0001));
}

test "Quaternion equal" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(5, 6, 7, 8);

    try t.expect(q1.equal(q1));
    try t.expect(!q1.equal(q2));
    try t.expect(!q2.equal(q1));
}

test "Quaternion approxEqual" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(1.01, 2.01, 3.01, 4.01);

    try t.expect(q1.approxEqual(q2, 0.1));
    try t.expect(!q1.approxEqual(q2, 0.01));
}

test "Quaternion addition" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(5, 6, 7, 8);
    var q3 = Quaternion(f32).init(6, 8, 10, 12);

    try t.expect(q1.add(q2).equal(q3));
}

test "Quaternion subtraction" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(5, 6, 7, 8);
    var q3 = Quaternion(f32).init(4, 4, 4, 4);

    try t.expect(q2.sub(q1).equal(q3));
}

test "Quaternion scalar multiplication" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(2, 4, 6, 8);

    try t.expect(q1.mulScalar(2).approxEqual(q2, 0.0001));
}

test "Quaternion multiplication" {
    {
        var q1 = Quaternion(f32).init(1, 2, 3, 4);
        var q2 = Quaternion(f32).init(2, 4, 6, 8);
        var q3 = Quaternion(f32).init(-56, 8, 12, 16);

        try t.expect(q1.mul(q2).approxEqual(q3, 0.0001));
        try t.expect(q2.mul(q1).approxEqual(q3, 0.0001));
    }
    {
        var q1 = Quaternion(f32).init(1, 0, 3, 4);
        var q2 = Quaternion(f32).init(2, 4, 0, 8);
        var q3 = Quaternion(f32).init(-30, 28, 22, 4);
        var q4 = Quaternion(f32).init(-30, -20, -10, 28);

        try t.expect(q1.mul(q2).approxEqual(q3, 0.0001));
        try t.expect(q2.mul(q1).approxEqual(q4, 0.0001));
    }
}

test "Quaternion conjugate" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var q2 = Quaternion(f32).init(1, -2, -3, -4);

    try t.expect(q1.conjugate().equal(q2));
}

test "Quaternion vector part" {
    var q1 = Quaternion(f32).init(1, 2, 3, 4);
    var v = Vec3f.init(2, 3, 4);
    try t.expect(q1.vector().equal(v));
}

test "Quaternion length" {
    var q = Quaternion(f32).init(1, 2, 3, 4);
    var len: f32 = 5.47722557505166;

    try t.expect(std.math.approxEqAbs(f32, q.length(), len, 0.0001));
}

test "Quaternion normalize" {
    var q = Quaternion(f32).init(1, 2, 3, 4);

    try t.expect(std.math.approxEqAbs(
        f32,
        q.normalize().length(),
        1,
        0.0001,
    ));
}

test "Quaternion axisAngle" {
    var q = Quaternion(f32).axisAngle(Vec3f.init(1, 1, 1), 0.785398);
    var r = Quaternion(f32).init(
        0.9238795637760319,
        0.22094233911212305,
        0.22094233911212305,
        0.22094233911212305,
    );

    try t.expect(q.approxEqual(r, 0.0001));
}

test "Quaternion rotation matrix" {
    var q = Quaternion(f32).axisAngle(Vec3f.init(1, 1, 1), 0.785398);
    // zig fmt: off
    var m = Mat4(f32).initValues(
        0.8047379311506545, -0.31061718933245597, 0.5058792581818015, 0,
        0.5058792581818015, 0.8047379311506545, -0.31061718933245597, 0,
        -0.31061718933245597, 0.5058792581818015, 0.8047379311506545, 0,
        0, 0, 0, 1,
        );
    // zig fmt: on
    try t.expect(q.rotationMatrix().approxEqual(m, 0.0001));
}

test "Quaternion euler" {
    var angle: f64 = 0.174533;
    var q = Quaternion(f64).euler(0.174533, 0.174533, 0.174533);
    var r = Quaternion(f64).init(0.9892896, 0.09406091, 0.07892647, 0.07892647);
    var m = Mat4(f64).rotateX(angle).mul(Mat4(f64).rotateY(angle).mul(Mat4(f64).rotateZ(angle)));

    try t.expect(q.approxEqual(r, 0.0001));
    try t.expect(q.rotationMatrix().approxEqual(m, 0.1));
}
