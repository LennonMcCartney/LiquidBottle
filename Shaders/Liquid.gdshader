shader_type spatial;
render_mode cull_disabled;

uniform float glass_thickness : hint_range(0.0f, 0.02f, 0.0001f);

uniform vec3 liquid_colour : source_color;

uniform float width;
uniform float height;

varying float liquid_level;

uniform float fill_amount : hint_range(-2, 2, 0.0001);

varying vec3 pos;

void vertex() {
	VERTEX -= glass_thickness * NORMAL;
	
	pos = mat3(MODEL_MATRIX)*VERTEX;
}

void fragment() {
	float d = dot(vec3(MODEL_MATRIX[0][1], MODEL_MATRIX[1][1], MODEL_MATRIX[2][1]), vec3(0.0f, 1.0f, 0.0f));
	float m = mix(width, height, abs(d));
	
	liquid_level = (fill_amount) * m;
	
	if (pos.y > liquid_level) {
		discard;
	}
	
	ALBEDO = liquid_colour;
	EMISSION = liquid_colour * 5.0f;
}
