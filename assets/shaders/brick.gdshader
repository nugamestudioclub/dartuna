shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform sampler2D brick_albedo : source_color;
uniform sampler2D brick_normal : hint_roughness_normal;

varying vec3 world_pos;
varying vec3 world_normal;


void vertex() {
	// Called for every vertex the material is visible on.
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = abs(NORMAL);
}

void fragment() {
	// Called for every pixel the material is visible on.
	 vec2 brick_uv;
    
    if (world_normal.z > world_normal.y && world_normal.z > world_normal.x) {
        brick_uv = world_pos.zy; // Wall is facing Left/Right (X axis)
    } else if (world_normal.x > world_normal.z && world_normal.x > world_normal.y) {
        brick_uv = world_pos.xy; // Wall is facing Front/Back (Z axis)
    } else {
        brick_uv = world_pos.xz; // Flat surface facing Up/Down (Y axis)
    }
	brick_uv = vec2(brick_uv.x/4.0,brick_uv.y/4.0);
    // Apply the brick coordinates to your textures
    ALBEDO = texture(brick_albedo, brick_uv * 0.5).rgb;
    NORMAL_MAP = texture(brick_normal, brick_uv * 0.5).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
