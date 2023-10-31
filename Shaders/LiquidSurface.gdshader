shader_type spatial;
render_mode cull_front;

uniform float glass_thickness;// : hint_range(0.0f, 0.02f, 0.0001f);

uniform vec3 surface_colour;

uniform float width;
uniform float height;

uniform float fill_amount;// : hint_range(-2, 2, 0.0001);

uniform float wave_intensity = 0.05f;

uniform sampler2D wave_noise;

uniform vec2 coeff;

varying float liquid_level;

varying vec3 pos;

void vertex() {
	VERTEX -= glass_thickness * NORMAL;
	
	pos = mat3(MODEL_MATRIX) * VERTEX;
}

void fragment() {
	float d = dot(vec3(MODEL_MATRIX[0][1], MODEL_MATRIX[1][1], MODEL_MATRIX[2][1]), vec3(0.0f, 1.0f, 0.0f));
	float m = mix(width, height, abs(d));
	
	liquid_level = (fill_amount) * m + wave_intensity * length(coeff) * (texture(wave_noise, 2.0*pos.xz + 0.5*TIME * vec2(1.0, 1.0)).r - 0.5f
									+ texture(wave_noise, 2.0*pos.xz - 0.5*TIME * vec2(1.0, 1.0)).g - 0.5f)
									+ dot(pos.xz, coeff);
	
	NORMAL = vec3(0.0f, 1.0f, 0.0f);
	
	if (pos.y > liquid_level) {
		discard;
	}
	
	ALBEDO = surface_colour;
	EMISSION = surface_colour * 5.0f;
}
