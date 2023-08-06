shader_type spatial;
uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2:repeat_enable;
uniform vec3 offset;
void vertex(){
	//vec2 pos =VERTEX.xz+vec2(time/10.0,time/1.0);
	vec2 pos =VERTEX.xz+offset.xz+vec2(200,200);
	vec2 pos2=vec2(pos.x+1.0,pos.y+1.0);
	vec4 noise1data=texture(noise1,pos/1600.0);
	vec4 noise2data=texture(noise2,pos/1600.0);
	
	vec4 diff1=texture(noise1,pos2/1600.0);
	vec4 diff2=texture(noise2,pos2/1600.0);
	float differencecount=(diff1.r+diff2.r);
	float height=noise1data.r+noise2data.r;
	VERTEX.y+=height*20.0;
	float difference=(differencecount-height);
	COLOR.rgb=vec3(0.0,clamp(0.2+difference,0.1,0.8),0.0);
	
}
void fragment() {
	ALBEDO=COLOR.rgb;
	// Place fragment code here.
}

