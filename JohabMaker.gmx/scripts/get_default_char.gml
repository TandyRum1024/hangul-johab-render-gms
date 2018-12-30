///get_default_char(idx)
/*
    returns "default" Korean character given the index
*/

var idx = argument0;
var glyphX = idx % gridWid;
var glyphY = idx div gridWid;
var char = "";

var _choseongoff = 0;
var _jungseongoff = _choseongoff + choRows;
var _jongseongoff = _jungseongoff + jungRows;
var _jamooff = _jongseongoff + jongRows;
var _asciioff = _jamooff + jamoRows;

var localoff;

// check for invalid index
if (idx < 0)
    return "";

if (glyphY < _jungseongoff) // Choseong
{
    localoff = glyphY;
    
    switch (localoff)
    {
        case 0: // beol 1
            char = chr($AC00 + ((glyphX * 21) + 0) * 28 + 16);
            break;
            
        case 1: // beol 2
            char = chr($AC00 + ((glyphX * 21) + 8) * 28 + 16);
            break;
    }
}
else if (glyphY < _jongseongoff) // Jungseong
{
    char = chr($AC00 + glyphX * 28 + 16);
}
else if (glyphY < _jamooff) // Jongseong
{
    localoff = glyphY - _jongseongoff;
    
    switch (localoff)
    {
        case 0: // beol 1
            char = chr($AC00 + glyphX);
            break;
            
        case 1: // beol 2
            char = chr($AC00 + (29) * 28 + glyphX);
            break;
    }
}
else if (glyphY < _asciioff) // Compatible Jamo
{
    localoff = idx - (gridWid * _jamooff); // Compat. Jamo offset
        
    if (localoff >= 0 && localoff <= $33) // check if the index is inside of the valid jamo range
        char = chr($3130 + localoff);
}
else // ASCII
{
    char = chr(idx - gridWid * _asciioff);
}
/*
switch (glyphY)
{
    case 0: // Choseong beol 1
        char = chr($AC00 + ((glyphX * 21) + 0) * 28 + 16);
        break;
    
    case 1: // Choseong beol 2
        char = chr($AC00 + ((glyphX * 21) + 8) * 28 + 16);
        break;
        
    case 2: // Jungseong
        char = chr($AC00 + glyphX * 28 + 16);
        break;
    
    case 3: // Jongseong beol 1
        char = chr($AC00 + glyphX);
        break;
    
    case 4: // Choseong beol 2
        char = chr($AC00 + ((1 * 21) + 8) * 28 + glyphX);
        break;
        
    case 5: // Compat. Jamo
    case 6:
        var _off = $3130 + (idx - gridWid * 5);
        
        if (_off >= $3130 && _off <= $3163)
            char = chr(_off);
        break;
        
    default: // ASCII
        char = chr(idx - gridWid * 7);
}
*/

return char;