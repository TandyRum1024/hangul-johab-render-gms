///hj_string_width(str)
/*
    주어진 한글 문자열의 전체 너비를 계산하고 캐싱 한 뒤 반환 합니다.
    캐시된 결과 대신 새로 계산된 결과를 원하시면 hj_string_width_raw() 를 사용하세요.
*/

var _str = argument0;
var _data = global.hjCacheWid[? _str];

// 캐시 안되어있으면 계산 & 캐시
if (_data == undefined)
{
    _data = hj_string_width_adv(_str);
    global.hjCacheWid[? _str] = _data;
    // show_debug_message("CACHE " + _str + " : " + string(_data[@ 0]) + "/" + string(_data[@ 1]));
}

return _data[@ 0] * (global.hjCharWidAscii + global.hjGlyphKerning) + _data[@ 1] * (global.hjCharWidHan + global.hjGlyphKerning);
