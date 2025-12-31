#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform vec3 backColor;

void mainImage()
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    
    if (color.a >= 0 && color.a != 1.0)
    {
        color = vec4(backColor.r, backColor.g, backColor.b, 1.0);
    }
    else
    {
        color = vec4(0, 0, 0, 0.0);
    }

    
    
	fragColor = color;
}