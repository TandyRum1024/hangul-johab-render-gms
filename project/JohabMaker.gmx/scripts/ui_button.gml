#define ui_button
///ui_button(x, y, w, h, string)
/**
    iui_button()
**/

/// Setup
// box edges
var boxL = argument0, boxT = argument1
var boxR = (boxL + argument2), boxB = (boxT + argument3);

/// Get label and ID.
var stringArray = iui_get_all(argument4);
var ID     = stringArray[0];
var LABEL  = stringArray[1];

/// Button logic
var isClicky = false;

// is hover
if (uiActive && point_in_rectangle(iui_inputX, iui_inputY, boxL, boxT, boxR, boxB))
{
    iui_hotItem = ID;
    
    // ... and is clicked
    if (iui_activeItem == -1 && iui_inputDown)
        iui_activeItem = ID;
}

// is 'Pressed" (AKA The user pressed and released the button)
if (iui_hotItem == ID && iui_activeItem == ID && !iui_inputDown)
    isClicky = true;


/// Button draw
var _labelcol;
var _border = 1;
var isActive = (iui_activeItem == ID);
var isHot    = (iui_hotItem == ID);

if (iuiButtonShadow)
    iui_rect(argument0 + 8, argument1 + 8, argument2, argument3, COL.GRAY);

// Hovering
if (isHot)
{
    // and clicked
    if (isActive)
    {
        iui_rect(argument0, argument1, argument2, argument3, COL.WHITE); // border
        iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.BASE);
        _labelcol = COL.WHITE;
    }
    else // nope
    {
        iui_rect(argument0, argument1, argument2, argument3, COL.WHITE);
        iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.GRAY);
        _labelcol = COL.WHITE;
    }
}
else // Nope
{
    // Default
    iui_rect(argument0, argument1, argument2, argument3, c_black);
    iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.WHITE);
    _labelcol = COL.BASE;
}

// label
iui_align_center();
iui_label(argument0 + (argument2 >> 1), argument1 + (argument3 >> 1), LABEL, _labelcol);
iui_align_pop();

return isClicky;

#define ui_button_icon
///ui_button_icon(x, y, w, h, string, icon, col)
/**
    iui_button() with icon
    PS : string acts like tooltip and ID in this script!!
**/

/// Setup
// box edges
var boxL = argument0, boxT = argument1
var boxR = (boxL + argument2), boxB = (boxT + argument3);

/// Get label and ID.
var stringArray = iui_get_all(argument4);
var ID     = stringArray[0];
var LABEL  = stringArray[1];

/// Button logic
var isClicky = false;

// is hover
if (uiActive && point_in_rectangle(iui_inputX, iui_inputY, boxL, boxT, boxR, boxB))
{
    iui_hotItem = ID;
        
    // set tooltip
    if (LABEL != "")
    {
        uiTooltipMsg = LABEL;
        uiTooltipShow = true;
    }
}

// is 'Pressed" (AKA The user pressed and released the button)
if (iui_hotItem == ID)
{
    if (iui_activeItem == ID && !iui_inputDown)
        isClicky = true;
    if (iui_activeItem == -1 && iui_inputDown)
        iui_activeItem = ID;
}


/// Button draw
var _labelcol;
var _border = 1;
var isActive = (iui_activeItem == ID);
var isHot    = (iui_hotItem == ID);

if (iuiButtonShadow)
    iui_rect(argument0 + 8, argument1 + 8, argument2, argument3, COL.GRAY);

// Hovering
if (isHot)
{
    // and clicked
    if (isActive)
    {
        iui_rect(argument0, argument1, argument2, argument3, COL.WHITE); // border
        iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.BASE);
        _labelcol = COL.WHITE;
    }
    else // nope
    {
        iui_rect(argument0, argument1, argument2, argument3, COL.WHITE);
        iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.GRAY);
        _labelcol = COL.WHITE;
    }
}
else // Nope
{
    // Default
    iui_rect(argument0, argument1, argument2, argument3, c_black);
    iui_rect(argument0 + _border, argument1 + _border, argument2 - (_border << 1), argument3 - (_border << 1), COL.WHITE);
    _labelcol = COL.BASE;
}

// label logic
// if (isHot)
// {
//     var _labelwid = string_width(LABEL) + 20;
//     var _labelhei = string_height(LABEL) + 20;
    
//     iui_rect(iui_inputX - 1, iui_inputY - 1, _labelwid + 2, _labelhei + 2, COL.BASE);
//     iui_rect(iui_inputX, iui_inputY, _labelwid, _labelhei, COL.WHITE);
//     iui_label(iui_inputX + (_labelwid >> 1), iui_inputY + (_labelhei >> 1), LABEL, COL.BASE);
// }
// iui_align_center();
// iui_label(_centerx, _centery + _margin, LABEL, _labelcol);
// iui_align_pop();

// icon
var _col = argument6;
if (isHot)
    _col = _labelcol;
    
draw_sprite_ext(spr_icons, argument5, argument0 + (argument2 >> 1), argument1 + (argument3 >> 1), 1, 1, 0, _col, 1);

return isClicky;