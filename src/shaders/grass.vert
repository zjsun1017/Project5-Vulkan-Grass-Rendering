#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec4 inPosition; // Input position of the grass blade
layout(location = 1) in vec4 inControlPoint; // Bezier control point
layout(location = 2) in vec4 inEndPoint; // Endpoint of the grass blade
layout(location = 3) in vec4 inUp; // Up vector for the grass blade

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// Outputs to tessellation control shader
out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) out vec4 outPosition; // Output position of the grass blade
layout(location = 1) out vec4 outControlPoint; // Bezier control point
layout(location = 2) out vec4 outEndPoint; // Endpoint of the grass blade
layout(location = 3) out vec4 outUp; // Up vector for the grass blade

void main() {

    // Pass the transformed positions to the tessellation control shader
    outPosition = model * vec4(inPosition.xyz, 1.0f);
    outControlPoint = model * vec4(inControlPoint.xyz, 1.0f);
    outEndPoint = model * vec4(inEndPoint.xyz, 1.0f);
    outUp = model * vec4(inUp.xyz, 1.0f);

    // Set gl_Position to the world position for the vertex
    gl_Position = outPosition;

    // Copy packed "w" info of each vertex
    // v0.w holds orientation, v1.w holds height, v2.w holds width, and up.w holds the stiffness coefficient
    outPosition.w = inPosition.w;
    outControlPoint.w = inControlPoint.w;
    outEndPoint.w = inEndPoint.w;
    outUp.w = inUp.w;
}