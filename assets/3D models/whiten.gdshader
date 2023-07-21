shader_type spatial;
uniform float whiten=0;
void fragment() {
	ALBEDO=COLOR.rgb+vec3(whiten,whiten,whiten)/2.0;
}
