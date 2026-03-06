shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

// Base color
uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Toon shading parameters
uniform int cuts : hint_range(2, 8) = 4;
uniform float wrap : hint_range(-1.0, 1.0) = 0.2;

// Lighting intensity
uniform float shadow_intensity : hint_range(0.0, 1.0) = 0.6;  // How dark shadows get
uniform float highlight_boost : hint_range(0.8, 1.5) = 1.0;   // Boost lit areas (1.0 = no boost)

// Ambient light (minimum brightness)
uniform float ambient_strength : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	ALBEDO = albedo.rgb;
}

void light() {
	// Calculate diffuse lighting
	float NdotL = dot(NORMAL, LIGHT);
	
	// Remap from -1..1 to 0..1 and apply wrap (shifts shadow boundary)
	NdotL = NdotL * 0.5 + 0.5 + wrap;
	NdotL = clamp(NdotL, 0.0, 1.0);
	
	// Apply toon banding - creates distinct steps
	float bands = float(cuts);
	float toon_value = floor(NdotL * bands) / (bands - 1.0);
	toon_value = clamp(toon_value, 0.0, 1.0);
	
	// Map toon value to shadow/highlight range
	// This creates more contrast: shadows are darker, highlights are brighter
	float min_light = ambient_strength;
	float max_light = highlight_boost;
	float final_intensity = mix(min_light, max_light, toon_value);
	
	// Apply shadow intensity (makes dark bands darker)
	if (toon_value < 0.5) {
		final_intensity *= mix(shadow_intensity, 1.0, toon_value * 2.0);
	}
	
	// Calculate final color
	vec3 diffuse = ALBEDO * LIGHT_COLOR * final_intensity * ATTENUATION;
	
	DIFFUSE_LIGHT += diffuse;
}
