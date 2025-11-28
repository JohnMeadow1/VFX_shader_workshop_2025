shader_type canvas_item;

uniform vec3 ambient_color:source_color;
uniform vec3 diffuse_color:source_color;
uniform vec3 specular_color:source_color;
uniform float specular_power:hint_range(0.0, 2000.0, 0.1) = 20.0;
uniform float specular_intensity:hint_range(0.0, 1.0, 0.01) = 1.0;

uniform vec3 light_direction = vec3(0.0,0.0,1.0);

vec3 get_nomal(vec2 uv){
	float z = sqrt(1.0 - (pow(uv.x,2.0) + pow(uv.y,2.0)));
	return vec3(uv.x, uv.y, z);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 get_light(vec3 normal, float time){
	vec3 camera_direction = vec3(0.0, 0.0, 1.0);
	vec3 half_vector = normalize(light_direction + camera_direction);
	float diffuse = max(dot(normal, light_direction), 0.0);
	float specular = max(dot(normal, half_vector), 0.0);
	specular = pow(specular, specular_power);
	specular *= dot(normal, light_direction);
	specular *= specular_intensity;

	//return ambient_color + diffuse_color * diffuse * hsv2rgb(vec3(diffuse+fract(time),1.0,1.0));
	return ambient_color + diffuse_color * diffuse + specular_color * specular;
}


void fragment() {
	vec2 UV_entered = UV * 2.0 - 1.0;
	vec3 normal = get_nomal(UV_entered);
	normal = normalize(normal);

	vec3 color = get_light(normal, TIME * 0.3);

	float fade = length(UV_entered);
	COLOR.rgb = color;
	COLOR.a = smoothstep(1.0, 0.9999, fade);
}
