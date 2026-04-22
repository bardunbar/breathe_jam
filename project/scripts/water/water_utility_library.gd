class_name Water_Utility_Library extends Node 

static var water_time = 0.0

static var cur_water_speed = 1.0
static var start_water_speed = 1.0
static var target_water_speed = 1.0
static var alpha_water_speed = 1.0

static var cur_water_wave_height = 1.0
static var start_water_wave_height = 1.0
static var target_water_wave_height = 1.0
static var alpha_water_wave_height = 1.0

static func ready() -> void:
	water_time = 0.0

static func process(delta: float) -> void:
	water_time += (delta * cur_water_speed)
	alpha_water_speed = clamp(delta + alpha_water_speed, 0.0, 1.0)
	cur_water_speed = lerp(start_water_speed, target_water_speed, alpha_water_speed)
	alpha_water_wave_height = clamp(delta + alpha_water_wave_height, 0.0, 1.0)
	cur_water_wave_height = lerp(start_water_wave_height, target_water_wave_height, alpha_water_wave_height)

static func hash_func(p: Vector2) -> float:
	p *= 17.17
	var r = Vector2(14.91, 67.31)
	var dot = p.dot(r)
	var hash_funcmult = sin(dot) * 4791.9511
	var rem = fmod(hash_funcmult, 1.0)
	return rem
	
static func noise(x: Vector2) -> float:
	var p = floor(x)
	var f = Vector2(fmod(x.x, 1.0), fmod(x.y, 1.0))
	f = f * f * ((Vector2.ONE* 3.0) - (2.0 * f))
	var a = Vector2(1.0, 0.0)
	var v1 = hash_func(p + Vector2(a.y, a.y))
	var v2 = hash_func(p + Vector2(a.x, a.y))
	var l1 = lerp(v1, v2, f.x)
	var v3 = hash_func(p + Vector2(a.y, a.x))
	var v4 = hash_func(p + Vector2(a.x, a.x))
	var l2 = lerp(v3, v4, f.x)
	
	#split this up and debug
	var l3 = lerp(l1, l2, f.y)
	return l3

static func fbm(x: Vector2) -> float:
	var height = 0.0
	var amplitude = 0.2 * cur_water_wave_height
	var frequency = 0.3
	var wave_height = 0.7 * cur_water_wave_height
	var wave_length = 0.5
	var time_dist = water_time;
	for i in range(1,3):
		height += sin((x.y * frequency * i) + time_dist) * i * amplitude
		height += cos((x.x * -frequency * i) + time_dist) * i * amplitude
		frequency += 0.1
		amplitude -= 0.07 * cur_water_wave_height
		time_dist = cos(time_dist)
	#height += noise((x + (Vector2.ONE * (water_time * -0.1))) * frequency) * amplitude
	height += cos(x.x * wave_length + water_time) * wave_height
	return height

static func get_height(xz_pos: Vector2) -> float:
	return fbm(xz_pos)

static func change_wave_height(new_wave_height: float) -> void:
	start_water_wave_height = cur_water_wave_height
	target_water_wave_height = new_wave_height
	alpha_water_wave_height = 0.0
	
static func change_water_speed(new_water_speed: float) -> void:
	start_water_speed = cur_water_speed
	target_water_speed = new_water_speed
	alpha_water_speed = 0.0
