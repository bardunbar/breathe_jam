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

float fbm(vec2 x, float time, float height_mult) {
	float height = 0.0;
	float amplitude = 0.2 * height_mult;
	//float amplitude = 0.0;
	float frequency = 0.3;
	float wave_height = 0.7f * height_mult;
	//float wave_height = 0.0f;
	float wave_length = 0.50f;
	float time_dist = time;
	for(float i = 1.f; i < 3.f; i = i + 1.f)
	{
		height += sin((x.y * frequency * i) + time_dist) * i * amplitude;
		height += cos((x.x * -frequency * i) + time_dist) * i * amplitude;
		frequency += 0.1f;
		amplitude -= 0.07f * height_mult;
		time_dist = cos(time_dist);
	}
	//height += noise((x + (time * -0.1)) * frequency) * amplitude;
	height += cos(x.x * wave_length + time) * wave_height;
	return height;
}