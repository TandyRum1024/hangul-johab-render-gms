///build_char_surface_all()
/*
    Builds all font surfaces
*/

var _charlen = gridWid * gridHei;

for (var i=0; i<_charlen; i++)
{
    build_char_surface(i);
}