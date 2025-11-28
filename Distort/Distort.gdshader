shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture, filter_linear_mipmap, repeat_enable;
uniform sampler2D ship_normal:repeat_disable, filter_linear_mipmap;

uniform float distorion_scale:hint_range(0.01, 10.0, 0.01) = 1.0;
uniform float blend:hint_range(0.00, 1.0, 0.01) = 1.0;


vec3 get_normal(vec2 uv) {
	float z = sqrt(1.0 - ( pow(uv.x, 2.0) + pow(uv.y, 2.0) ));
	return  vec3(uv.x, uv.y, z);
}

vec2 sphere_to_UV(vec3 sphere_point) {
	vec3 n = normalize(sphere_point);
	return vec2(atan(n.x, n.y) / TAU + 0.5, n.z * 0.5 + 0.5);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 normal = texture(ship_normal, UV);
	vec2 correction = 0.0001 / vec2(dFdx(UV.x), dFdy(UV.y));


	vec2 uv_sphere_offset = SCREEN_UV.xy + (normal.rg-0.5) * distorion_scale * correction;
	
	vec4 color_screen = texture(screen_texture, uv_sphere_offset);
	COLOR.rgb = color_screen.rgb;
	COLOR.rgb = mix(color.rgb, color_screen.rgb, blend);
	COLOR.a = color.a;
	
}
