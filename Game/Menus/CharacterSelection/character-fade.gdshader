shader_type canvas_item;

uniform float offset: hint_range(0.0, 1.0, 0.01);
uniform float brightness: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float flashing: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 flash_color: source_color;

void fragment() {
	vec4 color = texture(TEXTURE, vec2(UV.x, UV.y - offset));
	color.a *= 1.0 - sin(offset * PI * 0.9);
	color.rgb *= brightness;
	color.rgb = mix(color, flash_color, flashing).rgb;
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
