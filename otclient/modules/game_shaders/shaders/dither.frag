uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
//uniform float u_Time;

// Setup dither matrix (open to experimentation)
uniform int matrix[9] = int[](  230,    51,     128,
                                25,     102,    179, 
                                154,    205,    77);
// Setup screen size
uniform vec2 resolution = vec2(750, 600);

// Variables, to tweak as per requirement (with a few example options)
uniform vec4 ditherColor = vec4(196, 122, 192, 255)/255; // Blues: (150, 61, 90), (86, 3, 173); Reds: (166, 66, 83), (1,0,0), (200, 111, 201); Greens: (4, 138, 129) 
uniform float ditherThreshold = 0.4; // 0.3 - 0.5
uniform float brightnessOffset = 0.16;

void main(void)
{
    // Sample main color
    vec4 color = texture2D(u_Tex0, v_TexCoord);

    // Get mod value from coordinates (3X3 matrix here, so by 3 in this case), to make indices for the current fragment w.r.t dither matrix 
    int x = int(mod(v_TexCoord.x*resolution.x, 3.0));
    int y = int(mod(v_TexCoord.y*resolution.y, 3.0));
    
    // Get matrix value for the current pixel
    float matrixValue = float(matrix[x+y*3])/255.0;

    // Get grayscale value of current pixel (Based on Luma Brightness Vector)
    float lumaGrey = dot(color, vec4(0.299, 0.587, 0.114, 0));
    
    // Create the final dither mask value for current pixel by setting a step based on the retrieved matrix value as edge
    lumaGrey = step(matrixValue, lumaGrey + ditherThreshold) + brightnessOffset;

    // Mix the color with the dither mask
    color = color * (lumaGrey.xxxx) + ditherColor * (1 - lumaGrey.xxxx);

    gl_FragColor = color;
}