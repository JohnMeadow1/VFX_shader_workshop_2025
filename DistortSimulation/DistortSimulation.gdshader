shader_type canvas_item;
render_mode blend_disabled;
uniform sampler2D screen_texture:hint_screen_texture, filter_linear_mipmap, repeat_enable;
uniform sampler2D ship:repeat_disable, filter_linear_mipmap;

uniform float propagation:hint_range(0.0, 0.5, 0.01) = 0.25;

void fragment() {
	vec2 texture_size = vec2(textureSize(screen_texture, 0));
	float propagation_tweak = texture(ship, UV).z;
	float factor = 0.0;
	float center_color = texture(screen_texture, UV).b;
	factor += texture(screen_texture, UV + vec2(1.0, 0.0) / texture_size).b;
	factor += texture(screen_texture, UV + vec2(-1.0,0.0) / texture_size).b;
	factor += texture(screen_texture, UV + vec2(0.0, 1.0) / texture_size).b;
	factor += texture(screen_texture, UV + vec2(0.0,-1.0) / texture_size).b;
	factor -= center_color * 4.0;


	float current_color = COLOR.b;
	COLOR.b = center_color * 2.0 - texture(screen_texture, UV).g + propagation * factor * propagation_tweak;
	COLOR.r = texture(screen_texture, UV).g;
	COLOR.g = center_color;
	COLOR.a = max(0.0, COLOR.b);
}
