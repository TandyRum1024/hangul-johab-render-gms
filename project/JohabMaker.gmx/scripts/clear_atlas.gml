///clear_atlas()
/*
    Resets & clears the atlas
*/

var _atlaswid = charWid * gridWid;
var _atlashei = charHei * gridHei;
show_debug_message("NEW ATLAS [WID : " + string(_atlaswid) + " / HEI : " + string(_atlashei) + "]");

// check atlas surface
var atlasTemp = surface_create(_atlaswid, _atlashei);

// make empty atlas surface
surface_set_target(atlasTemp);
draw_clear_alpha(0, 0);
surface_reset_target();

// assign / make new atlases
if (sprite_exists(bakedAtlas))
    sprite_delete(bakedAtlas);
bakedAtlas = sprite_create_from_surface(atlasTemp, 0, 0, _atlaswid, _atlashei, false, false, 0, 0);

surface_set_target(atlasTemp);
draw_clear_alpha(0, 0);
draw_clear(c_white);
surface_reset_target();
if (sprite_exists(maskAtlas))
    sprite_delete(maskAtlas);
maskAtlas = sprite_create_from_surface(atlasTemp, 0, 0, _atlaswid, _atlashei, false, false, 0, 0);

surface_free(atlasTemp);
