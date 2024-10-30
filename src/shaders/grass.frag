#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Input data from tessellation evaluation shader
layout(location = 0) in vec3 teWorldPos;
layout(location = 1) in vec3 teNormal;
layout(location = 2) in float height;

// Output color
layout(location = 0) out vec4 outColor;

void main() {
    float ambient = 0.5;
    vec3 lightDir = normalize(vec3(0.5, 1.0, 0.5));
    float brightness = ambient + max(dot(teNormal, lightDir), 0.0);

    vec3 rootColor = vec3(0.1, 0.5, 0.1);
    vec3 tipColor = vec3(0.3, 0.8, 0.3);
    float heightFactor = clamp(teWorldPos.y / height, 0.0, 1.0);
    vec3 color = mix(rootColor, tipColor, heightFactor) * brightness;

    outColor = vec4(color, 1.0);
}
