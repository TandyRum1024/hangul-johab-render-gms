#define set_char_mask
///set_char_mask(idx, x1, y1, x2, y2)
/*
    RESETS mask & sets rectangle to mask of character given the index
*/

// setup
var idx = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;
var data = charData[| idx];

if (!is_array(data))
    return false;
    
// set mask
var mask = data[@ CHAR.MASK];
surface_set_target(mask);
draw_clear_alpha(0, 0);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 1); // somehow we need to add 1 pixel margin as the rectangle isn't inclusive
surface_reset_target();

#define add_char_mask
///add_char_mask(idx, x1, y1, x2, y2)
/*
    Adds a rectangle to mask of character given the index
*/

// setup
var idx = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;
var data = charData[| idx];

if (!is_array(data))
    return false;
    
// set mask
var mask = data[@ CHAR.MASK];
surface_set_target(mask);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 1);
surface_reset_target();

#define subtract_char_mask
///subtract_char_mask(idx, x1, y1, x2, y2)
/*
    Subtracts a rectangle to mask of character given the index
*/

// setup
var idx = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;
var data = charData[| idx];

if (!is_array(data))
    return false;
    
// set mask
var mask = data[@ CHAR.MASK];
surface_set_target(mask);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 0);
surface_reset_target();

#define clear_char_mask
///clear_char_mask(idx, alpha)
/*
    Clears / fills the mask of character given the index
*/

// setup
var idx = argument0, alpha = argument1;
var data = charData[| idx];

if (!is_array(data))
    return false;
    
// set mask
var mask = data[@ CHAR.MASK];
surface_set_target(mask);
draw_clear_alpha(c_white, alpha);
surface_reset_target();

#define set_char_mask_to
///set_char_mask_to(surf, x1, y1, x2, y2)
/*
    RESETS mask & sets rectangle to mask surface
*/

// setup
var surf = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;

// set mask
surface_set_target(surf);
draw_clear_alpha(0, 0);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 1);
surface_reset_target();

#define add_char_mask_to
///add_char_mask(surf, x1, y1, x2, y2)
/*
    Adds a rectangle to mask surface
*/

// setup
var surf = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;
  
// set mask
surface_set_target(surf);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 1);
surface_reset_target();

#define subtract_char_mask_to
///subtract_char_mask_to(surf, x1, y1, x2, y2)
/*
    Subtracts a rectangle to mask surface
*/

// setup
var surf = argument0, x1 = argument1, y1 = argument2, x2 = argument3, y2 = argument4;

// set mask
surface_set_target(surf);
iui_rect_pos(x1, y1, x2 + 1, y2 + 1, c_white, 0);
surface_reset_target();

#define clear_char_mask_to
///clear_char_mask_to(surf, alpha)
/*
    Clears / fills the mask surface
*/

// setup
var surf = argument0, alpha = argument1;

// set mask
surface_set_target(surf);
draw_clear_alpha(c_white, alpha);
surface_reset_target();