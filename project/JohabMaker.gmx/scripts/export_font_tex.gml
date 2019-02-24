///export_font_tex(dir, rendergrid, renderbg, bgcol)
/*
    Exports font texture
*/

var dir = argument0, rendergrid = argument1, renderbg = argument2, bgcol = argument3;

// Build font texture
build_font_tex_ext(rendergrid, bgcol, renderbg);

// Save font texture
surface_save(fntTex, dir);

// Build font texture again
build_font_tex();
