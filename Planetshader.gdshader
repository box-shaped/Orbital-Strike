shader_type canvas_item;
render_mode blend_mix;


// Varyings
uniform vec4 color :source_color;






void fragment() {
// ColorConstant:3
	vec4 n_out3p0 = color;


// Output:0
	COLOR.rgb = vec3(n_out3p0.xyz);



}