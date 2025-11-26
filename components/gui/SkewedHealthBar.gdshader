shader_type canvas_item;
render_mode blend_mix;

uniform float skew_pixels = 40.0;

void vertex() {
	VERTEX.x += (UV.y - 0.5) * skew_pixels;
}
