shader_type spatial;
uniform vec2 offset;
uniform sampler2D noise: repeat_enable;

void fragment() {
	ALPHA = 0.5;
	if(texture(noise, UV+offset/800.0).r > 0.5) {
		ALBEDO = vec3(2.0, 2.0, 2.0);
	} else {
		ALPHA = 0.0;
	}
}
