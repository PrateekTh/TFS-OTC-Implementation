# Writing Custom Shaders for OTC

The provided assignment video:

While approaching this trial, I tried to see it from several angles, on how to approach this problem. The main components include:

- The outline effect around the player
- The trails following behind the player

Apart from creating shaders that result in these effects, since both of these effects were applied only to the player, I needed to find a way to **bind** shaders to only the player. When I researched the forums and source code of OTC for this, the conclusion that came up was that OTC supports map shaders (and supposedly item shaders), the module to which was removed. Still, I needed to bind shaders to the player, in my case, and in this quest I came across [this](https://github.com/mehah/forgottenserver-optimized/commit/fd3c39aab64de281e733539e6a18bb994a9cba26#diff-5a026da090b6664f91c5f3bc4a9d0844cff966ef6fa5785d258b3aa47b370a2c) commit in mehah's TFS optimisation, which works efficiently with mehah's `OTClient:Redemption`

So now, I had **two** choices (due to time), I could either _reproduce the changes_ from this commit into TFS, and figure out the corresponding changes in the client source code and recompile, or _try to achieve the desired effect using map shaders_. Since I really like writing shaders (as can be seen from previous repositories), I took it up as a challenge, and decided to implement the effects using the map-binded shaders, which are canon in the current OTC Build. Also, the dash effect was something that I would need to replicate, and coordinate the implementation between server and client. Since the question mentioned to pay attention to the shaders, I decided to focus on creating them.

I created separate shaders for the outline and trail effects (they can be directly binded to a player if a client supports it _(like mehah's client)_, and will work seamlessly in such clients too), to showcase it, and eventually a few more shaders because it is quite fun!!

## Initial setup

To get a starting point of how shaders work in OTC and where to write them, I cloned the shaders module from this branch of OTC, which seems to have been completely abandoned.

The main challenge, now that I had undertaken it, was for me to modify the main result texture to achieve the desired results. This is referred to as "Screenspace" in general 3D and graphics terms, and the effects and shaders applied at this stage are generally called Post-processing effects/shaders. Since I only wished for the player to be affected by my shader, but only had to use the final texture, it would take masks, and a witty use of them to make effects.

## Trail Shader

[Link to Code](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_shaders/shaders/trail.frag)

The trail shader basically refers to the repeating sprite of the player, each instance of which I will be referring to as a "trail".
The impementation can be found in the `trail.frag` file, in the `game_shaders` module. As with the spells assignment, the code contains the detailed explanation for each step, and I will cover the approach here:

- Sample the main color from the defined main texture uniform `u_Tex0` and coordinates `v_TexCoord`
- Calculate a vector pointing to the player, by adjusting the screen coordinates.
- Create a mask based on this distance, which will help to skip calculating trails for pixels/fragments outside the mask. Add the x (after suitably modifying it) as gradient to it, which will be used to fade the trail, since the alpha channel cannot be used.
- Create another vector, which contains an offset from the main coordinates, for rendering the current trail.
- Calculate the magnitude of difference of colors of the trail(as a way to separate the player from the background). Multiplying this value with our main mask from earlier gives us a mask of the trail, and if set in a loop, we get multiple trails, in a decreasing gradient.
- Mix the current trail with main color texture at each step of the loop.

I believe this provides a decent result, based on the requirement. The `shaders.lua` file can be modified to switch shaders based on various triggers, and hence, the dash effect will be complete.

The main difficulty, as can be seen from the implementation, was due to the inavailability of the player on a separate "layer" (which would essentially be the same as the ability to bind shaders to just the player sprite):

- In wake of it being available, we would just have to **copy** the relevant pixels/fragments in a loop, without having to worry about masks.
- I feel that the effect has a lot of potential in **full screen** too, as we could radially increase/decrease the trail effect of all objects close to the player, an effect that many games of today use for similar situations.
- Another problem is the **inavailability of player variables**, since the shader is bound to the map. I tried writing the direction information to the Opacity uniform from the shaders.lua file, after going through the source code, but the `setOpacity` function is nil for some reason, that I could not debug. Directional support can be simply added by multiplying an extra variable to the x and y offsets, and lightly modifying the shader.

Here is the implementation of the trail shader:

https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/c52d4524-173a-4f61-aadb-6add76c6294b

## Outline Shader

[Link to Code](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_shaders/shaders/outline.frag)

For the outline, I applied a sobel filter across all the pixels, and modified it to allow for more customisation.

A [Sobel filter](https://en.wikipedia.org/wiki/Sobel_operator) is one of the basic, yet prominent kernel based techniques to detect outlines and edges, and was a part of my coursework in Computer Graphics, as a part the degree of Computer Science. It involes iterating a fixed kernel over each pixel, which helps detect the change in contrast between adjacent sets of pixels.

The basic approach is as follows:

- Create the `make_kernel` function, which return an array consisting of the colors of all adjacent pixels in a 3x3 matrix around the current pixel.
- Calculate the sobel `height` and `width` values, and find the collective magnitude
- Assign a color to the outline (I added color varying trignometrically based on time).
- Mix the color and the sobel filter using Linear Interpolation.

Results:

https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/6b4813a7-38db-4028-a745-00592e13a03a

For a player only shader, the sobel filter will be applied to the alpha channel only, instead of the entire color, to detect edges.

## Other Shaders

After working on the above two shaders, I felt a bit more confident and better well versed in writing shaders for OTC, and thus made a few more shaders. For each of the following, the explanation can be found in the linked code files.

### Dither Shader

[Link to Code](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_shaders/shaders/dither.frag)

A dithering post process effect, with a kernel based implementation. The video compression affects the quality a lot, hence I will add the an image instead.
![image](https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/a55cff9e-f2ea-434b-88de-ce1ae7eac5c4)

### Time Stop Effect

[Link to Code](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_shaders/shaders/zawarudo.frag)

This effect is inspired by DIO's abilities from JoJo's Bizzare Adventure. Please refer to [this video](https://youtu.be/sWk9qsxEWKg?si=uLWY_0T8rvW0zPHM), for the reference.

https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/24a14d4a-a2f0-412c-9374-1ffcba29efa5

## Conclusion

I have always had an affinity for creating great visuals and visual styles, not exactly in context of realism, but rather as expression. Shaders prove to be an excellent channel(or buffer, I should say) for that, and also a solid middle ground between my technical and creative ventures. Thus, I feel this part was definitely the most fun part of the project for me, no matter the difficulty!
