shader_type canvas_item;

const int maxsize = 5;
uniform vec4 from[maxsize] : source_color;
uniform vec4 new[maxsize] : source_color;
uniform float tolerance: hint_range(0.0, 1.0);


vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void fragment()
{
	float _tol = tolerance * tolerance;
	bool edited=false;
	vec4 tex = texture(TEXTURE, UV);
	vec3 source_hsv = rgb2hsv(tex.rgb);
	for(int loop_i=0;loop_i<maxsize;loop_i++){
		if(edited){break;}
		vec3 initial_hsv = rgb2hsv(from[loop_i].rgb);
		vec3 hsv_shift = rgb2hsv(new[loop_i].rgb) - initial_hsv;
		
		float hue = initial_hsv.r;
		
		// the .r here represents HUE, .g is SATURATION, .b is LUMINANCE
		if (hue - source_hsv.r >= -_tol && hue - source_hsv.r <= +_tol)
		{
			vec3 final_hsv = source_hsv + hsv_shift;
			tex.rgb = hsv2rgb(final_hsv);
			edited=true;
		}
		
	}
	COLOR = tex;
}