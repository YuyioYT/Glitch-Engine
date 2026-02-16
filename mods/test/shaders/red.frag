#pragma header



uniform float uActive;
void main()
{

    vec2 uv = openfl_TextureCoordv;

    // sample the input image
    vec4 col = flixel_texture2D(bitmap, uv);

    
	if (uActive == 1.0)
	{
		col.b = 0.0;
		col.g = 0.0;
	}

    gl_FragColor = col;
}
