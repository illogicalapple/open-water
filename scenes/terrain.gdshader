shader_type spatial;
uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2:repeat_enable;
uniform vec3 offset;
void vertex(){
	//vec2 pos =VERTEX.xz+vec2(time/10.0,time/1.0);
	vec2 pos =VERTEX.xz+offset.xz+vec2(200,200);
	
	vec4 noise1data=texture(noise1,pos/400.0);
	vec4 noise2data=texture(noise2,pos/400.0);
	float height=noise1data.r+noise2data.r;
	height /=2.0;
	VERTEX.y+=clamp(height*5.0,2,5);
	height=clamp(height,0.1,0.6);
	COLOR.g=1.0;
	
}
void fragment() {
	ALBEDO=COLOR.rgb;
	// Place fragment code here.
}

