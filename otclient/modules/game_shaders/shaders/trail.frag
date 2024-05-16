uniform sampler2D u_Tex0; // The main texture (full screen )
varying vec2 v_TexCoord; // Screen tex coordinates [0 - 1] on each axis
//uniform float u_Opacity; // For direction control

// Constants for swizzling 
uniform float ZERO = 0;
uniform float ONE = 1;

void main(void)
{
    // Set main color
    vec4 color = texture2D(u_Tex0, v_TexCoord);

    // Vector pointing to the center of the screen
    vec2 dir = v_TexCoord - 0.5;
    dir.x += 0.04;
    dir.y -= 0.04;

    // Variables for rendering trails
    vec4 trailMask;                 // Trail Mask
    float differenceFactor;         // Factor to check difference between source and trail color
    vec2 targetTex = vec2(v_TexCoord.x - 0.27, v_TexCoord.y);   //Initial Offset for the target location of a trail
    vec4 trailColor;                // To store the 
    float mixFactor = 0.6;          // (for Linear interpolation (lerp)) could vary it on per shader basis, else make into a uniform

    // Create a mask, within the required area, with a gradient based on distance (could just initialise to ZERO, instead of else statements)
    vec4 mask = ZERO.xxxx;
    if (dir.x > 0.01 && dir.x <0.3){                                            // Select X range
        if ( dir.y > -0.03 && dir.y < 0.055){                                   // Select Y range
            dir.x = pow((1-dir.x), 8);                                          // Reset dir.x to get a desirable gradient shape
            mask = vec4(dir.xxx, 1);                                            // Set the mask to the gradient
            for(int i = 0; i<6; i++){                               
                targetTex.x = targetTex.x + 0.045;                              // Keep adding offset for each trail location
                trailColor = texture2D(u_Tex0, targetTex);                      // Sample texture with the shifted coordinates
                differenceFactor = abs(dot((color-trailColor), ONE.xxxx));      // Calculate the magnitude difference of colors between source and target
                trailMask = mask*differenceFactor;                              // Set the current trail mask based on the difference
                // Mix trailColor with main color, with a two step lerp, using mixFactor and trailMask
                color = color * (1-trailMask) + trailMask * (color * mixFactor.xxxx + trailColor* (1 - mixFactor.xxxx)); 
            }
        }
    }
    //gl_FragColor = trailMask; // To see the final trail mask only
    gl_FragColor = color;
}