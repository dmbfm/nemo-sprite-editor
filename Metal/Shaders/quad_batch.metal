//
//  quad_batch.metal
//  nemosprite
//
//  Created by Daniel Fortes on 25/06/23.
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
    uint quad_id;
};

struct FragmentUniformData {
    float3 color;
};

vertex
VertexOutput vertex_quad_batch_main( VertexInput in [[ stage_in ]], constant float4x4 &proj_view_mat [[ buffer(22) ]], uint vid [[ vertex_id ]] ) {
    VertexOutput out;
    out.position = proj_view_mat * float4(in.position, 1);
    out.texcoord = in.texcoord;
    out.quad_id = vid / 6;
    return out;
}

fragment
float4 frag_quad_batch_main(VertexOutput in [[ stage_in ]],
                            constant FragmentUniformData *uniforms [[ buffer(11)]]) {
    float3 color = uniforms[in.quad_id].color;
    return float4(color, 1);
}
