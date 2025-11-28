shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod_bias:hint_range(0.0, 5.0, 0.1) = 2.1;
uniform float z_length:hint_range(0.0, 2.0, 0.01) = 0.1;

void fragment() {
	vec2 texture_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
	vec3 normal;
	normal.x = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-1.0, 0.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(1.0, 0.0) * texture_size, lod_bias).a;
	normal.y = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, 1.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -1.0) * texture_size, lod_bias).a;
	normal.x += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-2.0, 0.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(2.0, 0.0) * texture_size, lod_bias).a;
	normal.y += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, 2.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -2.0) * texture_size, lod_bias).a;
	normal.x += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-4.0, 0.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(4.0, 0.0) * texture_size, lod_bias).a;
	normal.y += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, 4.0) * texture_size, lod_bias).a - texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -4.0) * texture_size, lod_bias).a;
	normal.z = z_length;

	COLOR.rgb = normalize(normal) + vec3(0.5, 0.5, 0.0);
	//COLOR.a = 1.0-COLOR.b;
	//COLOR.a = texture(TEXTURE, SCREEN_UV).a;
	COLOR.a = smoothstep(0.0, 1.0, 1.0-COLOR.b + texture(TEXTURE, SCREEN_UV).a);
}
