shader_type canvas_item;

render_mode blend_add;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.rgb *= 2.0; // Adjust this multiplier to increase emission.
    COLOR = color;
}
