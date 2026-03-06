shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float bands : hint_range(1.0, 10.0) = 3.0;
uniform float light_intensity : hint_range(0.0, 2.0) = 1.0;

varying vec3 world_normal;
varying vec3 world_position;

void vertex() {
    world_normal = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec3 normal = normalize(world_normal);
    
    // Directional light direction (adjust as needed)
    vec3 light_dir = normalize(vec3(0.5, 1.0, 0.3));
    
    float NdotL = dot(normal, light_dir);
    NdotL = max(0.0, NdotL);
    
    // Band the lighting for toon effect
    NdotL = floor(NdotL * bands) / bands;
    
    // Ambient + diffuse lighting
    vec3 ambient = vec3(0.3);
    vec3 diffuse = vec3(0.7) * NdotL * light_intensity;
    
    vec3 color = albedo.rgb * (ambient + diffuse);
    
    ALBEDO = color;
    ALPHA = albedo.a;
}
