shader_type canvas_item;

uniform float offset: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 color = texture(TEXTURE, vec2(UV.x, UV.y - offset));
	color.a *= 1.0 - sin(offset * PI * 0.9);
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
