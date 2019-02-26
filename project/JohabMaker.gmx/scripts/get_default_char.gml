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
    
// setup for dkb844
if (FNT_DKB)
    glyphX--; // Offset for 1 cell

// check for invalid x
if (glyphX < 0)
    return "";

if (glyphY < _jungseongoff) // Choseong
{
    localoff = glyphY;
    
    if (glyphX <= 18)
    {
        if (FNT_DKB)
        {
            switch (localoff)
            {
                case 0: // beol 1
                    char = chr($AC00 + ((glyphX * 21) + 1) * 28);
                    break;
                    
                case 1: // beol 2
                    char = chr($AC00 + ((glyphX * 21) + 8) * 28);
                    break;
                    
                case 2: // beol 3
                    char = chr($AC00 + ((glyphX * 21) + 13) * 28);
                    break;
                    
                case 3: // beol 4
                    char = chr($AC00 + ((glyphX * 21) + 10) * 28);
                    break;
                    
                case 4: // beol 5
                    char = chr($AC00 + ((glyphX * 21) + 15) * 28);
                    break;
                    
                case 5: // beol 6
                    char = chr($AC00 + ((glyphX * 21) + 1) * 28 + 21);
                    break;
                    
                case 6: // beol 7
                    char = chr($AC00 + ((glyphX * 21) + 8) * 28 + 21);
                    break;
                
                case 7: // beol 8
                    char = chr($AC00 + ((glyphX * 21) + 11) * 28 + 4);
                    break;
            }
        }
        else
        {
            switch (localoff)
            {
                case 0: // beol 1
                    char = chr($AC00 + ((glyphX * 21) + 0) * 28 + 16);
                    break;
                    
                case 1: // beol 2
                    char = chr($AC00 + ((glyphX * 21) + 8) * 28 + 16);
                    break;
                    
                case 2: // beol 3
                    char = chr($AC00 + ((glyphX * 21) + 0) * 28);
                    break;
                    
                case 3: // beol 4
                    char = chr($AC00 + ((glyphX * 21) + 8) * 28);
                    break;
            }
        }
    }
}
else if (glyphY < _jongseongoff) // Jungseong
{
    localoff = glyphY - _jungseongoff;
    
    if (glyphX <= 20)
    {
        if (FNT_DKB)
        {
            switch (localoff)
            {
                case 0: // no jongseong with ㄱ, ㅋ
                    char = chr($AC00 + (glyphX) * 28);
                    break;
                    
                case 1: // no jongseong without ㄱ, ㅋ
                    char = chr($AC00 + ((6 * 21) + glyphX) * 28);
                    break;
                
                case 2: // yes jongseong with ㄱ, ㅋ
                    char = chr($AC00 + (glyphX) * 28 + 16);
                    break;
                    
                case 3: // yes jongseong without ㄱ, ㅋ
                    char = chr($AC00 + ((6 * 21) + glyphX) * 28 + 16);
                    break;
            }
        }
        else
        {
            switch (localoff)
            {
                case 0: // yes jongseong 
                    char = chr($AC00 + glyphX * 28 + 16);
                    break;
                    
                case 1: // no jongseong
                    char = chr($AC00 + glyphX * 28);
                    break;
            }
        }
    }
}
else if (glyphY < _jamooff) // Jongseong
{
    localoff = glyphY - _jongseongoff;
    
    if (FNT_DKB)
    {
        glyphX++;
        switch (localoff)
        {
            case 0: // beol 1
                char = chr($AC00 + glyphX);
                break;
                
            case 1: // beol 2
                char = chr($AC00 + (4 * 28) + glyphX);
                break;
                
            case 2: // beol 3
                char = chr($AC00 + 28 + glyphX);
                break;
                
            case 3: // beol 4
                char = chr($AC00 + (8 * 28) + glyphX);
                break;
        }
    }
    else if (glyphX > 0)
    {
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
}
else if (glyphY < _asciioff) // Compatible Jamo
{
    localoff = idx - (gridWid * _jamooff); // Compat. Jamo offset
        
    if (localoff >= 0 && localoff <= $33) // check if the index is inside of the valid jamo range
        char = chr($3130 + localoff);
    else
        char = "";
}
else // ASCII
{
    char = chr(idx - gridWid * _asciioff);
    
    if (char == "#")
    {
        char = "\" + char;
    }
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
