shader_type spatial;

uniform sampler2D noise: repeat_enable;

void fragment() {
	ALPHA = 1.0;
	if(texture(noise, UV).r > 0.5) {
		ALBEDO = vec3(1, 1, 1);
	} else {
		ALPHA = 0.0;
	}
}
