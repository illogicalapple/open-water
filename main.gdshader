shader_type spatial;
uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2:repeat_enable;
void vertex(){
	vec2 pos =VERTEX.xz+vec2(TIME/10.0,TIME/1.0);
	vec4 noise1data=texture(noise1,pos/100.0);
	vec4 noise2data=texture(noise2,pos/100.0);
	float height=noise1data.r*noise2data.r;
	VERTEX.y+=clamp(height*5.0,2,5);
	height=clamp(height,0.1,0.6);
	COLOR.rgb=vec3(0,height*0.5*0.5,height*0.5);
	COLOR.gb+=vec2(0.1,0.2);
	
}
void fragment() {
	ALBEDO=COLOR.rgb;
	// Place fragment code here.
}
