///build_char_surface_all()
/*
    Builds all font surfaces
*/

var _charlen = gridWid * gridHei;
var _data;

for (var i=0; i<_charlen; i++)
{
    _data = charData[| i];
    
    if (_data[@ CHAR.OCCUPIED])
        build_char_surface(i);
}
