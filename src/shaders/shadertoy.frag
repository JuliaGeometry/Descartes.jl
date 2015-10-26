{{GLSL_VERSION}}

void mainImage( out vec4 fragColor, in vec2 fragCoord );

out vec4 fragment_color;

void main()
{
	mainImage(fragment_color, gl_FragCoord.xy);
}