#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Tessellation control shader inputs from vertex shader
in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

out gl_PerVertex {
    vec4 gl_Position;
} gl_out[];

// Pass-through variables to tessellation evaluation shader
layout(location = 0) in vec4 inPosition[]; // Input position of the grass blade
layout(location = 1) in vec4 inControlPoint[]; // Bezier control point
layout(location = 2) in vec4 inEndPoint[]; // Endpoint of the grass blade
layout(location = 3) in vec4 inUp[]; // Up vector for the grass blade

layout(location = 0) out vec4 outPosition[]; // Output position of the grass blade
layout(location = 1) out vec4 outControlPoint[]; // Bezier control point
layout(location = 2) out vec4 outEndPoint[]; // Endpoint of the grass blade
layout(location = 3) out vec4 outUp[]; // Up vector for the grass blade

void main() {
    // Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

    outPosition[gl_InvocationID] = inPosition[gl_InvocationID];
    outControlPoint[gl_InvocationID] = inControlPoint[gl_InvocationID];
    outEndPoint[gl_InvocationID] = inEndPoint[gl_InvocationID];
    outUp[gl_InvocationID] = inUp[gl_InvocationID];

    // Set level of tessellation
    // Use a fixed tessellation level for simplicity, can be adjusted based on distance or other factors
    gl_TessLevelInner[0] = 10.0;
    gl_TessLevelInner[1] = 10.0;
    gl_TessLevelOuter[0] = 10.0;
    gl_TessLevelOuter[1] = 10.0;
    gl_TessLevelOuter[2] = 10.0;
    gl_TessLevelOuter[3] = 10.0;
}

