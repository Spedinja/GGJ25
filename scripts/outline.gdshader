shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform float feather : hint_range(0, 1) = 0.5; // New uniform for feathering

void vertex() {
    VERTEX += (UV * 2.0 - 1.0) * width;
}

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
    for (float i = -ceil(width); i <= ceil(width); i++) {
        float x = abs(i) > width ? width * sign(i) : i;
        float offset;

        offset = width;

        for (float j = -ceil(offset); j <= ceil(offset); j++) {
            float y = abs(j) > offset ? offset * sign(j) : j;
            vec2 xy = uv + texture_pixel_size * vec2(x, y);

            if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a <= 0.0) == false) {
                return true;
            }
        }
    }
    return false;
}

void fragment() {
    vec2 uv = UV;
    vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
    uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;

    if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
        COLOR.a = 0.0;
    } else {
        COLOR = texture(TEXTURE, uv);
    }

    if ((COLOR.a > 0.0) == false && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
        vec2 center_uv = UV;
        float distance_to_edge = length(center_uv - uv) / width;
        float fade_factor = smoothstep(1.0, 1.0 - feather, distance_to_edge);

        COLOR.rgb = mix(COLOR.rgb, color.rgb, color.a * fade_factor);
        COLOR.a += (1.0 - COLOR.a) * color.a * fade_factor;
    }
}