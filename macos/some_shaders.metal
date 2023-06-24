//
//  some_shaders.metal
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#include <metal_stdlib>
using namespace metal;

struct VertexInput {
    float3 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(1) ]];
};

struct VertexOutput {
    float4 position [[ position ]];
    float2 texcoord;
};

struct FragmentUniformData {
    float3 color;
};

vertex
VertexOutput vertex_main( VertexInput in [[ stage_in ]] ) {
    VertexOutput out;
    out.position = float4(in.position, 1);
    out.texcoord = in.texcoord;
    return out;
}

fragment
float4 frag_main(VertexOutput in [[ stage_in ]], constant FragmentUniformData *uniforms [[ buffer(11)]]) {
    return float4(uniforms->color, 1);
}
