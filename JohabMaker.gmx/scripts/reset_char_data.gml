#define reset_char_data
///reset_char_data(ind)
/*
    Updates character data & resets character attribs of single character
*/

var ind = argument0;

// reset char data
var _data = charData[| ind];
var _baked, _mask;

if (is_undefined(_data) || !is_array(_data)) // No data?
{
    _baked = -1;
    _mask = -1;
}
else
{
    _baked = _data[@ CHAR.BAKED];
    _mask = _data[@ CHAR.MASK];
}

// reset surface data
if (!surface_exists(_baked))
    _baked = surface_create(charWid, charHei);
surface_set_target(_baked);
draw_clear_alpha(0, 0);
surface_reset_target();

if (!surface_exists(_mask))
    _mask = surface_create(charWid, charHei);
surface_set_target(_mask);
draw_clear(c_white);
surface_reset_target();

// Build char data
var _arr = -1;
_arr[CHAR.SOURCE] = "";
_arr[CHAR.BAKED] = _baked;
_arr[CHAR.MASK] = _mask;
_arr[CHAR.X] = 0;
_arr[CHAR.Y] = 0;
charData[| ind] = _arr;

#define reset_char_data_all
///reset_char_data_all()
/*
    Updates character data & resets character attribs of all characteres
*/

// reset char data
var _charlen = ds_list_size(charData);
for (var i=0; i<_charlen; i++)
{
    var _data = charData[| i];
    
    if (!is_array(_data))
        continue;
    
    if (surface_exists(_data[@ CHAR.BAKED])) surface_free(_data[@ CHAR.BAKED]);
    if (surface_exists(_data[@ CHAR.MASK])) surface_free(_data[@ CHAR.MASK]);
}
ds_list_clear(charData);

// update char data
update_font_attribs();
_charlen = gridWid * gridHei;

// Build char data
for (var i=0; i<_charlen; i++)
{
    reset_char_data(i);
}