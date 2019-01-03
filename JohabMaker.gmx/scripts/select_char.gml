///select_char(idx)
/*
    Selects character for mask editing
*/

var idx = argument0;

var data = charData[| idx];

if (is_array(data))
{
    charSelected = idx;
    
    // Copy mask to temp surface
    var srcMask = data[@ CHAR.MASK];
    surface_copy(maskTemp, 0, 0, srcMask);
}
