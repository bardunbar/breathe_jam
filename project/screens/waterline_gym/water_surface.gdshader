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
  float amplitude = 0.5;
  float frequency = 3.0;
  for (int i = 0; i < 6; i++){
    height += noise(x * frequency) * amplitude;
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return height;
}

void vertex() {
	// Called for every vertex the material is visible on.
	float height = test((VERTEX.xz));
	//float height = fbm((VERTEX.xz * 0.5) + (TIME * 0.1f));
	VERTEX.y += height;
	COLOR.rgb = vec3(0.1f, 0.2f, 1.f) * height;
	
	//vec2 e = vec2(0.01, 0.0);
	//vec3 normal = normalize(vec3(fbm(VERTEX.xz - e) - fbm(VERTEX.xz + e), 2.0 * e.x, fbm(VERTEX.xz - e.yx) - fbm(VERTEX.xz + e.yx)));
	//NORMAL = normal;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = COLOR.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
