pub const VertexData = extern struct {
    position: [3]f32,
    texcoord: [2]f32,
};

pub const UniformData = extern struct {
    color: [4]f32,
};
