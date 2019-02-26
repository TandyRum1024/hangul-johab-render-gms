///hj_string_height(str)
/*
    주어진 한글 문자열의 높이를 반환합니다
*/

var _lineheight = max(global.hjCharHeiHan, global.hjCharHeiAscii) + global.hjGlyphLineheight; // 한 줄의 높이는 ASCII 글자의 크기와 한글 글자의 크기 중 가장 큰걸로 계산됩니다.
var _lines = string_count("#", argument0) - string_count("\#", argument0) + 1; // [개행문자 개수] - [이스케이프 된 문자 개수] + 1 = 총 줄 수

return _lineheight * _lines;
