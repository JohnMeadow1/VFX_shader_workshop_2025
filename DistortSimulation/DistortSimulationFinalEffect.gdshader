shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D wave_sim:repeat_disable, filter_linear_mipmap;
uniform sampler2D ship:repeat_disable, filter_linear_mipmap;
uniform sampler2D noise:repeat_enable, filter_linear_mipmap;
uniform vec3 tint_color:source_color = vec3(0.0, 0.15, 0.3);
uniform sampler2D tint_gradient:filter_linear;
uniform float distorion_scale:hint_range(0.01, 2.0, 0.01) = 0.4;
uniform float distortion_power:hint_range(0.01, 2.0, 0.01) = 1.0;
uniform float blur_value:hint_range(0.0, 7.0, 0.1) = 0.0;
uniform float chromatic_aberations:hint_range(1.0, 40.0, 1.0) = 3.0;

vec3 get_normal(vec2 uv) {
	float z = sqrt(1.0 - ( pow(uv.x, 2.0) + pow(uv.y, 2.0) ));
	return  vec3(uv.x, uv.y, z);
}

vec2 sphere_to_UV(vec3 sphere_point) {
	vec3 n = normalize(sphere_point);
	return vec2(atan(n.x, n.y) / TAU + 0.5, n.z * 0.5 + 0.5);
}

void fragment() {
	vec4 blob_normal = texture(TEXTURE, UV);
	vec2 correction = 0.0001 / vec2(dFdx(UV.x), dFdy(UV.y));
	float ship_mask = blob_normal.a*blob_normal.a;
	
	vec3 hit_wave = texture(wave_sim , UV ).rgb;

	vec2 nosie_uv = texture(noise , UV ).rg;
	vec2 uv_cordintes = sphere_to_UV(blob_normal.rgb) + nosie_uv * 0.2;
	float uv_cordintes_cycling = uv_cordintes.y + TIME * 0.1;
	vec2 wave_coords = vec2(uv_cordintes.x, uv_cordintes_cycling) * distorion_scale;
	float noise_value = texture(noise , wave_coords ).r;
	float noise_value2 = texture(noise , UV ).r;
	vec2 wave = vec2( dFdxCoarse(noise_value), dFdyCoarse(noise_value) ) + vec2( dFdxCoarse(hit_wave.b), dFdyCoarse(hit_wave.b) );
	float wave_magnitude = clamp((wave.x+wave.y) * 20.0, -1.0, 1.0) ;


	vec2 uv_sphere_offset = SCREEN_UV.xy + wave * distortion_power * correction;
	vec4 color_screen_blured = textureLod(screen_texture, uv_sphere_offset, blur_value);
	vec4 color_screen_blured_2 = color_screen_blured;
	
	color_screen_blured_2.rgb += dFdx(color_screen_blured.rgb) * vec3(chromatic_aberations, 0.0, -chromatic_aberations);
	color_screen_blured_2.rgb += dFdy(color_screen_blured.rgb) * vec3(chromatic_aberations, 0.0, -chromatic_aberations);


	vec3 color_mix = color_screen_blured_2.rgb * (1.0-wave_magnitude);
	color_mix +=   color_screen_blured.rgb  * (wave_magnitude);

	vec3 tint_grad = texture(tint_gradient, vec2(hit_wave.b, 0.5) ).rgb;
	COLOR.rgb = vec3(color_mix) + tint_color * wave_magnitude + tint_grad;

	COLOR.a = ship_mask;

}