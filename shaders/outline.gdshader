shader_type canvas_item;

uniform float outline_threshold : hint_range(0.0, 0.1) = 0.01;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.5, 3.0) = 1.0;

void fragment() {
    vec2 texel_size = 1.0 / SCREEN_PIXEL_SIZE;
    
    // Sample depth from neighboring pixels (4-directional kernel)
    float depth_center = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float depth_up = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, -texel_size.y * outline_width)).r;
    float depth_down = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, texel_size.y * outline_width)).r;
    float depth_left = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-texel_size.x * outline_width, 0.0)).r;
    float depth_right = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(texel_size.x * outline_width, 0.0)).r;
    
    // Calculate depth differences
    float depth_diff = max(
        max(abs(depth_center - depth_up), abs(depth_center - depth_down)),
        max(abs(depth_center - depth_left), abs(depth_center - depth_right))
    );
    
    // Sample normals for edge highlighting
    vec3 normal_center = texture(NORMAL_TEXTURE, SCREEN_UV).rgb;
    vec3 normal_up = texture(NORMAL_TEXTURE, SCREEN_UV + vec2(0.0, -texel_size.y * outline_width)).rgb;
    vec3 normal_down = texture(NORMAL_TEXTURE, SCREEN_UV + vec2(0.0, texel_size.y * outline_width)).rgb;
    vec3 normal_left = texture(NORMAL_TEXTURE, SCREEN_UV + vec2(-texel_size.x * outline_width, 0.0)).rgb;
    vec3 normal_right = texture(NORMAL_TEXTURE, SCREEN_UV + vec2(texel_size.x * outline_width, 0.0)).rgb;
    
    // Normal difference for edge detection
    float normal_diff = max(
        max(dot(normal_center, normal_up), dot(normal_center, normal_down)),
        max(dot(normal_center, normal_left), dot(normal_center, normal_right))
    );
    
    // Combine depth and normal edge detection
    bool is_edge = depth_diff > outline_threshold || normal_diff < 0.9;
    
    vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    
    // Apply outline
    if (is_edge) {
        color = outline_color.rgb;
    }
    
    COLOR = vec4(color, 1.0);
}
