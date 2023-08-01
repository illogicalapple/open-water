shader_type spatial;

uniform sampler2D noise: repeat_enable;

void fragment() {
	ALPHA = 0.5;
	if(texture(noise, UV).r > 0.5) {
		ALBEDO = vec3(2.0, 2.0, 2.0);
	} else {
		ALPHA = 0.0;
	}
}
