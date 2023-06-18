//
//  some_shaders.metal
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#include <metal_stdlib>
using namespace metal;

vertex
float4 vertex_main() {
    return float4(0, 0, 0, 1);
}

fragment
float4 frag_main() {
    return float4(1, 0, 0, 1);
}
