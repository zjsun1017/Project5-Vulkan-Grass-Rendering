#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Input data from tessellation control shader
in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

layout(location = 0) in vec4 tcWorldPos[]; // Input world position from tessellation control shader
layout(location = 1) in vec4 tcControlPoint[]; // Input control point from tessellation control shader
layout(location = 2) in vec4 tcEndPoint[]; // Input end point from tessellation control shader
layout(location = 3) in vec4 tcUp[]; // Input up vector from tessellation control shader

// Outputs to fragment shader
out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) out vec3 teWorldPos; // Pass world position to fragment shader
layout(location = 1) out vec3 teNormal; // Pass normal vector to fragment shader
layout(location = 2) out float height;

void main() {

    // Compute Bezier curve position using the tessellation coordinates
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;
    
    vec3 p0 = tcWorldPos[0].xyz;
    vec3 p1 = tcControlPoint[0].xyz;
    vec3 p2 = tcEndPoint[0].xyz;

    float orientation = tcWorldPos[0].w;
    float width = tcEndPoint[0].w;

    // De Casteljau algorithm for quadratic Bezier curve
    vec3 a = mix(p0, p1, v);
    vec3 b = mix(p1, p2, v);
    vec3 c = mix(a, b, v);

    // Give width to grass blades using ideas from paper
    vec3 t0 = normalize(b - a);
    vec3 t1 = normalize(vec3(cos(orientation), 0.0, sin(orientation)));
    vec3 c0 = c - width * t1;
    vec3 c1 = c + width * t1;
    float t = u + 0.5 * v - u * v;
    vec3 position = mix(c0, c1, t);

    // Output the world position and normal (up vector)
    teWorldPos = position;
    teNormal = normalize(cross(t0, t1));
    height = tcControlPoint[0].w;



    // Transform the position to clip space
    gl_Position = camera.proj * camera.view * vec4(position, 1.0);
}
