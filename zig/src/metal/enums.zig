pub const TriangleFillMode = enum(u64) {
    MTLTriangleFillModeFill = 0,
    MTLTriangleFillModeLines = 1,
};

pub const CullMode = enum(u64) {
    MTLCullModeNone = 0,
    MTLCullModeFront = 1,
    MTLCullModeBack = 2,
};

pub const Winding = enum(u64) {
    MTLWindingClockwise = 0,
    MTLWindingCounterClockwise = 1,
};

pub const LoadAction = enum(u64) {
    MTLLoadActionDontCare = 0,
    MTLLoadActionLoad = 1,
    MTLLoadActionClear = 2,
};

pub const StoreAction = enum(u64) {
    MTLStoreActionDontCare = 0,
    MTLStoreActionStore = 1,
    MTLStoreActionMultisampleResolve = 2,
    MTLStoreActionStoreAndMultisampleResolve = 3,
    MTLStoreActionUnknown = 4,
    MTLStoreActionCustomSampleDepthStore = 5,
};

pub const BlendOperation = enum(u64) {
    MTLBlendOperationAdd = 0,
    MTLBlendOperationSubtract = 1,
    MTLBlendOperationReverseSubtract = 2,
    MTLBlendOperationMin = 3,
    MTLBlendOperationMax = 4,
};

pub const BlendFactor = enum(u64) {
    MTLBlendFactorZero = 0,
    MTLBlendFactorOne = 1,
    MTLBlendFactorSourceColor = 2,
    MTLBlendFactorOneMinusSourceColor = 3,
    MTLBlendFactorSourceAlpha = 4,
    MTLBlendFactorOneMinusSourceAlpha = 5,
    MTLBlendFactorDestinationColor = 6,
    MTLBlendFactorOneMinusDestinationColor = 7,
    MTLBlendFactorDestinationAlpha = 8,
    MTLBlendFactorOneMinusDestinationAlpha = 9,
    MTLBlendFactorSourceAlphaSaturated = 10,
    MTLBlendFactorBlendColor = 11,
    MTLBlendFactorOneMinusBlendColor = 12,
    MTLBlendFactorBlendAlpha = 13,
    MTLBlendFactorOneMinusBlendAlpha = 14,
    MTLBlendFactorSource1Color = 15,
    MTLBlendFactorOneMinusSource1Color = 16,
    MTLBlendFactorSource1Alpha = 17,
    MTLBlendFactorOneMinusSource1Alpha = 18,
};

pub const WriteMask = enum(u64) {
    MTLColorWriteMaskNone = 0,
    MTLColorWriteMaskRed = 0x1 << 3,
    MTLColorWriteMaskGreen = 0x1 << 2,
    MTLColorWriteMaskBlue = 0x1 << 1,
    MTLColorWriteMaskAlpha = 0x1 << 0,
    MTLColorWriteMaskAll = 0xf,
};

pub const Mutability = enum(u64) {
    MTLMutabilityDefault = 0,
    MTLMutabilityMutable = 1,
    MTLMutabilityImmutable = 2,
};

pub const VertexStepFunction = enum(u64) {
    constant = 0,
    per_vertex = 1,
    per_instance = 2,
    //MTLVertexStepFunctionPerPatch API_AVAILABLE(macos(10.12), ios(10.0)) = 3,
    //MTLVertexStepFunctionPerPatchControlPoint API_AVAILABLE(macos(10.12), ios(10.0)) = 4,
};
pub const VertexFormat = enum(u64) {
    Invalid = 0,
    UChar2 = 1,
    UChar3 = 2,
    UChar4 = 3,
    Char2 = 4,
    Char3 = 5,
    Char4 = 6,
    UChar2Normalized = 7,
    UChar3Normalized = 8,
    UChar4Normalized = 9,
    Char2Normalized = 10,
    Char3Normalized = 11,
    Char4Normalized = 12,
    UShort2 = 13,
    UShort3 = 14,
    UShort4 = 15,
    Short2 = 16,
    Short3 = 17,
    Short4 = 18,
    UShort2Normalized = 19,
    UShort3Normalized = 20,
    UShort4Normalized = 21,
    Short2Normalized = 22,
    Short3Normalized = 23,
    Short4Normalized = 24,
    Half2 = 25,
    Half3 = 26,
    Half4 = 27,
    Float = 28,
    Float2 = 29,
    Float3 = 30,
    Float4 = 31,
    Int = 32,
    Int2 = 33,
    Int3 = 34,
    Int4 = 35,
    UInt = 36,
    UInt2 = 37,
    UInt3 = 38,
    UInt4 = 39,
};

// NOTE: not complete!
pub const PixelFormat = enum(u64) {
    Invalid = 0,
    A8Unorm = 1,
    R8Unorm = 10,
    R8Unorm_sRGB = 11,
    R8Snorm = 12,
    R8Uint = 13,
    R8Sint = 14,
    R16Unorm = 20,
    R16Snorm = 22,
    R16Uint = 23,
    R16Sint = 24,
    R16Float = 25,
    RG8Unorm = 30,
    RG8Unorm_sRGB = 31,
    RG8Snorm = 32,
    RG8Uint = 33,
    RG8Sint = 34,
    R32Uint = 53,
    R32Sint = 54,
    R32Float = 55,
    RG16Unorm = 60,
    RG16Snorm = 62,
    RG16Uint = 63,
    RG16Sint = 64,
    RG16Float = 65,
    RGBA8Unorm = 70,
    RGBA8Unorm_sRGB = 71,
    RGBA8Snorm = 72,
    RGBA8Uint = 73,
    RGBA8Sint = 74,
    BGRA8Unorm = 80,
    BGRA8Unorm_sRGB = 81,
    RGB10A2Unorm = 90,
    RGB10A2Uint = 91,
    RG11B10Float = 92,
    RGB9E5Float = 93,
    RG32Uint = 103,
    RG32Sint = 104,
    RG32Float = 105,
    RGBA16Unorm = 110,
    RGBA16Snorm = 112,
    RGBA16Uint = 113,
    RGBA16Sint = 114,
    RGBA16Float = 115,
    RGBA32Uint = 123,
    RGBA32Sint = 124,
    RGBA32Float = 125,
};

pub const PrimitiveType = enum(u64) {
    point = 0,
    line = 1,
    line_strip = 2,
    triangle = 3,
    triangle_strip = 4,
};
