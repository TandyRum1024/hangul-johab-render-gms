///build_char_surface_all()
/*
    Builds all font surfaces
*/

var _data, _atlaswid, _atlashei;

// prep temp surface
if (!surface_exists(glyphTemp))
    glyphTemp = surface_create(charWid, charHei);
else
    surface_resize(glyphTemp, charWid, charHei);

_atlaswid = sprite_get_width(bakedAtlas);
_atlashei = sprite_get_height(bakedAtlas);

var atlasTemp = surface_create(_atlaswid, _atlashei);

// update temp atlas
texture_set_interpolation(true);
surface_set_target(atlasTemp);
draw_clear_alpha(0, 0);
for (var i=0; i<charLen; i++)
{
    _data = charData[| i];
    
    if (_data[@ CHAR.OCCUPIED])
    {
        // show_debug_message("BUILDING : " + string(i));
        var _u = charWid * (i % gridWid); // UV(??) positions to write our freshly built texture into
        var _v = charHei * (i div gridWid);
        
        build_char_surface_to(i, glyphTemp); // build glyph & save it into glyphTemp
        draw_surface(glyphTemp, _u, _v); // and draw that onto our temp atlas
    }
}
surface_reset_target();
texture_set_interpolation(false);

// assign atlas to baked atlas sprite
if (sprite_exists(bakedAtlas))
    sprite_delete(bakedAtlas);
bakedAtlas = sprite_create_from_surface(atlasTemp, 0, 0, _atlaswid, _atlashei, false, false, 0, 0);

surface_free(atlasTemp);
