uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Setting screen resolution for the sobel filter. Altering affects thickness and resolution of the outline
uniform float width = 2000;
uniform float height = 1600;

//Threshold, to reduce noise, and account for fine tuning of areas where outlines are required
uniform float sobel_Threshold = 2.4;

//sobel filter kernel
void make_kernel(inout vec4 n[9], sampler2D tex, vec2 coord)
{
	float w = 1.0 / width;
	float h = 1.0 / height;

	n[0] = texture2D(tex, coord + vec2( -w, -h));
	n[1] = texture2D(tex, coord + vec2(0.0, -h));
	n[2] = texture2D(tex, coord + vec2(  w, -h));
	n[3] = texture2D(tex, coord + vec2( -w, 0.0));
	n[4] = texture2D(tex, coord);
	n[5] = texture2D(tex, coord + vec2(  w, 0.0));
	n[6] = texture2D(tex, coord + vec2( -w, h));
	n[7] = texture2D(tex, coord + vec2(0.0, h));
	n[8] = texture2D(tex, coord + vec2(  w, h));
}

void main(void) 
{	
	// Implement a sobel filter
	vec4 n[9];
	make_kernel( n, u_Tex0, v_TexCoord);
	vec4 sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
  	vec4 sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8]);
	vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));

	vec4 color = texture2D(u_Tex0, v_TexCoord);

	// Implement thresholding to reduce noise
	if (dot(sobel, vec4(1,1,1,0))>2.4){
		sobel = vec4(1,1,1,1);
	} else {
		sobel = vec4(0,0,0,0);
	}

	// Set a color for the outline (Set a time based trigonometically varying rgb color here)
	vec4 outlineColor = vec4(sin(u_Time * 2), cos(u_Time*2), sin(u_Time*5),1);

	// Mask and apply outline color (lerp)
	gl_FragColor = color * (1-sobel) + sobel * outlineColor;

	// // To view only outlines
	// gl_FragColor = vec4(sobel.rgb,1.0);
}
