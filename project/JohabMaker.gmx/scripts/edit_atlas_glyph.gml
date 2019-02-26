#define edit_atlas_glyph
///edit_atlas_glyph(sprite, glyphindex, surface)
/*
    Edits the part of sprite atlas with given surface
    returns new sprite and deletes the given sprite argument
*/

var _atlas = argument0, _idx = argument1, _surf = argument2;
var _atlaswid, _atlashei;

// check atlas sprite exits
if (sprite_exists(_atlas))
{
    _atlaswid = sprite_get_width(_atlas);
    _atlashei = sprite_get_height(_atlas);
}
else
{
    _atlaswid = charWid * charLen;
    _atlashei = charHei;
}

// check surface exits
var atlasTemp = surface_create(_atlaswid, _atlashei);

// Edit temp atlas texture
surface_set_target(atlasTemp);

// Clearing temp atlas texture & Copying previous atlas texture
draw_clear_alpha(0, 0);

if (sprite_exists(_atlas))
    draw_sprite_ext(_atlas, 0, 0, 0, 1, 1, 0, c_white, 1); // copy

// Editing surface
var _u = charWid * (_idx % gridWid); // Get UV positions for editing area
var _v = charHei * (_idx div gridWid); // - basically we're rebuilding [X, Y] positions from index

draw_set_blend_mode(bm_subtract); // use blend mode to "clear" the editing area
iui_rect_alpha(_u, _v, charWid, charHei, c_black, 1);
draw_set_blend_mode(bm_normal);
draw_surface(_surf, _u, _v); // and copy our surface into desired area
surface_reset_target();
//


// Assign sprite
if (sprite_exists(_atlas))
    sprite_delete(_atlas);
_atlas = sprite_create_from_surface(atlasTemp, 0, 0, _atlaswid, _atlashei, false, false, 0, 0);


surface_free(atlasTemp);
return _atlas;

#define edit_atlas_glyph_alt
///edit_atlas_glyph_alt(sprite, glyphindex, surface)
/*
    Edits the part of sprite atlas with given surface
    returns new sprite and deletes the given sprite argument
*/

var _atlas = argument0, _idx = argument1, _surf = argument2;
var _atlaswid, _atlashei;

// check atlas sprite exits
if (sprite_exists(_atlas))
{
    _atlaswid = sprite_get_width(_atlas);
    _atlashei = sprite_get_height(_atlas);
}
else
{
    _atlaswid = charWid * charLen;
    _atlashei = charHei;
}

// check surface exits
var atlasTemp = surface_create(_atlaswid, _atlashei);

// Edit temp atlas texture
surface_set_target(atlasTemp);

// Clearing temp atlas texture & Copying previous atlas texture
draw_clear_alpha(0, 0);

if (sprite_exists(_atlas))
{
    draw_set_blend_mode(bm_add);
    draw_enable_alphablend(false);
    draw_sprite_ext(_atlas, 0, 0, 0, 1, 1, 0, c_white, 1); // copy
    draw_enable_alphablend(true);
    draw_set_blend_mode(bm_normal);
}

// Editing surface
var _u = charWid * (_idx % gridWid); // Get UV positions for editing area
var _v = charHei * (_idx div gridWid); // - basically we're rebuilding [X, Y] positions from index

draw_set_blend_mode(bm_subtract); // use blend mode to "clear" the editing area
iui_rect_alpha(_u, _v, charWid, charHei, c_black, 1);
draw_set_blend_mode(bm_normal);
draw_surface(_surf, _u, _v); // and copy our surface into desired area
surface_reset_target();
//


// Assign sprite
if (sprite_exists(_atlas))
    sprite_delete(_atlas);
_atlas = sprite_create_from_surface(atlasTemp, 0, 0, _atlaswid, _atlashei, false, false, 0, 0);

surface_free(atlasTemp);
return _atlas;