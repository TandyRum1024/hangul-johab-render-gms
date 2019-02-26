///build_sprite_from_tex(fname)
/*
    Builds sprite from current font texture & save it to file
*/

// create base sprite
build_font_tex_ext(false, 0, 0);
var _spr = sprite_create_from_surface(fntTex, 0, 0, gridWid * charWid, gridHei * charHei, false, false, 0, 0);
build_font_tex();

// add subimages
/*
for (var Y=0; Y<gridHei; Y++)
{
    for (var X=0; X<gridWid; X++)
    {
        if (X == 0 && Y == 0)
            continue;
        sprite_add_from_surface(_spr, fntTex, X * charWid, Y * charHei, charWid, charHei, false, false);
    }
}
*/

var _path = working_directory + "/tmp/" + argument0;
sprite_save_strip(_spr, _path);
sprite_delete(_spr);

return _path;
