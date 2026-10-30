shader_type canvas_item;

uniform vec2 size = vec2(500.0, 400.0);
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
        
        vec2 center_uv = round(SCREEN_UV*500.0)/500.0;
        
		
        COLOR = textureLod(screen_texture, center_uv, 0.0);
}