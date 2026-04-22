shader_type spatial;
#include "res://shaders/water_function_lib.gdshaderinc"
render_mode world_vertex_coords;
uniform float wave_height = 1.0;
uniform float water_time = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
	float height = fbm((VERTEX.xz), water_time, wave_height);
	//float height = fbm((VERTEX.xz * 0.5) + (TIME * 0.1f));
	VERTEX.y += height;
	//COLOR.rgb = vec3(0.1f, 0.4f, 1.f) * clamp(height + 0.5f, 0.0f, 1.f);
	COLOR.rgb = vec3(0.1f, 0.4f, 1.f);
	
	vec2 e = vec2(0.01f, 0.0f);
	vec3 normal = normalize(vec3(fbm(VERTEX.xz - e, water_time, wave_height) - fbm(VERTEX.xz + e, water_time, wave_height), 2.0 * e.x, fbm(VERTEX.xz - e.yx, water_time, wave_height) - fbm(VERTEX.xz + e.yx, water_time, wave_height)));
	//COLOR.r = normal.x;
	//COLOR.gb = vec2(0.f, 0.f);
	NORMAL = normal;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = COLOR.rgb;
	//ALBEDO = vec3(dot(vec3(0.f, 1.f, 0.f), NORMAL), 1.f, 1.f);
	ALPHA = clamp(dot(vec3(0.f, 1.f, 0.f), NORMAL), 0.2f, 0.95f);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
