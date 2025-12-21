#pragma header
//BLOOM SHADER BY BBPANZU, MODIFIED FOR MOBILE BY RALSEIIISMOL
const float amount = 1.0;
// GAUSSIAN BLUR SETTINGS
uniform float dim;
uniform float Directions;
uniform float Quality;
uniform float Size; 

#define Pi 6.28318530718 // Pi*2

void main() { 
    vec2 Radius = Size / openfl_TextureSize.xy;
    vec2 uv = openfl_TextureCoordv.xy;
    
    vec4 Color = texture2D(bitmap, uv);
    
    for(float d = 0.0; d < Pi; d += Pi / Directions) {
        for(float i = 1.0 / Quality; i <= 1.0; i += 1.0 / Quality) {
            float ex = (cos(d) * Size * i) / openfl_TextureSize.x;
            float why = (sin(d) *Size * i) / openfl_TextureSize.y;
            Color += texture2D(bitmap, uv + vec2(ex, why));
        }
    }
    
    Color /= (dim * Quality) * Directions - 15.0;
    vec4 bloom = (texture2D(bitmap, uv) / dim) + Color;
    
    gl_FragColor = bloom;
}

