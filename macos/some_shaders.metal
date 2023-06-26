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
    float4 color;
};

vertex
VertexOutput vertex_main( VertexInput in [[ stage_in ]], constant float4x4 &proj_view_mat [[ buffer(22) ]], uint vid [[ vertex_id ]] ) {
    VertexOutput out;
    out.position = proj_view_mat * float4(in.position, 1);
    //out.position += float4(0.1 * vid, 0, 0, 0);
    out.texcoord = in.texcoord;
    return out;
}

fragment
float4 frag_main(VertexOutput in [[ stage_in ]],
                 constant FragmentUniformData &uniforms [[ buffer(11)]]) {
    return uniforms.color;
}



