///load_font(fontDir, size)
/*
    Exec this when you change the font
*/

fntPath = argument0;

if (font_exists(fntCurrent))
    font_delete(fntCurrent);

// REMEMBER : font_add with .ttf will add """ALL""" the glyphs in the font
fntCurrent = font_add(fntPath, argument1, false, false, 666, 666); // weird flex but ok
fntName = font_get_fontname(fntCurrent);
fntSize = argument1;

// reset_char_surfaces();
// build_glyph_surface_preview(-1);
show_debug_message("resetting all character data...");
reset_char_data_all();

// Resize surfaces
surface_resize(glyphTex, charWid, charHei);
surface_resize(maskOverlay, charWid, charHei);
surface_resize(maskPreview, charWid, charHei);
surface_resize(maskTemp, charWid, charHei);

show_debug_message("building character surface...");
build_char_surface_all();
updateFontSurf = true;
