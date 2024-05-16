uniform float u_Time;       // Time function
uniform sampler2D u_Tex0;   // The main texture sampler (full screen in this case)
varying vec2 v_TexCoord;    // Screen tex coordinates [0 - 1] on each axis

// Variables to tweak
uniform float duration = 0.8; // this is not in seconds

void main()
{
    vec4 color = texture2D(u_Tex0, v_TexCoord);
    
    // Vector pointing to the center of the screen
    vec2 dir = v_TexCoord - 0.5;

    // Adjusting the Vector to set center on the player's head
    dir.x += 0.055;
    dir.y -= 0.08;

    // Calculate euclidean distance from the set center
    float dist = sqrt(dir.x*dir.x + dir.y*dir.y);
    
    // Adjust distance variable as per gradient requirements
    dist = pow((1-dist),3);

    // Set a repeating (cosine) time-based step with the modified distance gradient as the edge
    float edgeMask = step(dist, cos(u_Time * duration));

    // Mix between the main color and it's negative (1-color) using a Lerp (Linear Interpolation), based on the edgeMask
    gl_FragColor = color * (edgeMask) + (1- color)*(1 - edgeMask);
}