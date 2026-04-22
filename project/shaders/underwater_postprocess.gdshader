shader_type spatial;
#include "res://shaders/water_function_lib.gdshaderinc"
uniform float water_time = 0.0;
uniform float wave_height = 1.0;

// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;

uniform sampler2D depth_texture : hint_depth_texture;

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	// take the screen space coordinates and transform them into normalized device coordinates
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec3 clip = vec3(SCREEN_UV * 2.0 - 1.0, 1.0);
	
	
	// Convert NDC to view space
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	// Because the camera is facing the negative z direction, the position will have a negative z value. In order to get a usable depth value, we have to negate view.z
	float linear_depth = -view.z;

	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec4 world_clip = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(clip, 1.0);
	
	
	vec4 world_frag = INV_VIEW_MATRIX * vec4(VERTEX, 1.f);
	vec3 world_position = world.xyz / world.w;
	vec3 world_clip_position = world_clip.xyz / world_clip.w;
	float height = fbm(world_clip_position.xz, water_time, wave_height);
	
	
	float below_water_mask = 1.f - clamp((world_clip_position.y - height), 0.f, 0.004f) * 250.f;
	//float below_water_mask = clamp((world_clip.y), 0.f, 0.001f) * 1000.f;
	//float below_water_mask = (1.f - clamp((world_clip.y) * 1000.f, 0.f, 1.f));
	//float below_water_mask = 1.f - clamp((world_clip.y), 0.f, 1.f);

	// Visualize linear depth
	//ALBEDO.rgb = vec3(fract(linear_depth));

	ALBEDO.rgb = mix(vec3(0.1f, 0.1f, 0.5f), vec3(0.0), depth);
	//ALBEDO.rgb = world_eclip_position.xyz;
	ALPHA = below_water_mask * 0.5f;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
