shader_type spatial;
render_mode world_vertex_coords;
uniform float height_scale = 0.5;

float test(vec2 p) {
	return cos(p.x) * sin(p.y);
}

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}

float noise(vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  vec2 a = vec2(1.0, 0.0);
  return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x),
         mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 x) {
	float height = 0.0;
	float amplitude = 0.75;
	float frequency = 0.50;
	float wave_height = 0.7f;
	float wave_length = 0.50f;
	height += noise((x + (TIME * -0.1)) * frequency) * amplitude;
	height += cos(x.x * wave_length + TIME) * wave_height;
	return height;
}

void vertex() {
	// Called for every vertex the material is visible on.
	float height = fbm((VERTEX.xz));
	//float height = fbm((VERTEX.xz * 0.5) + (TIME * 0.1f));
	VERTEX.y += height;
	//COLOR.rgb = vec3(0.1f, 0.4f, 1.f) * clamp(height + 0.5f, 0.0f, 1.f);
	COLOR.rgb = vec3(0.1f, 0.4f, 1.f);
	
	vec2 e = vec2(0.01f, 0.0f);
	vec3 normal = normalize(vec3(fbm(VERTEX.xz - e) - fbm(VERTEX.xz + e), 2.0 * e.x, fbm(VERTEX.xz - e.yx) - fbm(VERTEX.xz + e.yx)));
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
