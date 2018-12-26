///ui_label(screen_x, screen_y, size, str, col)
/*
    draw rectangle in screen units [0...1]
*/

var _absx = argument0 * WIN_WID, _absy = argument1 * WIN_HEI;
var _scale = UI_SCALE * argument2;

iui_label_transform(_absx, _absy, argument3, _scale, _scale, 0, argument4, 1);
