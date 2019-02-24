///hj_string_width_raw(str)
/*
    주어진 한글 문자열의 전체 너비를 반환합니다.
    (= 모든 줄 중 최대 넓이)
*/

var _in = argument0, _len = 0, _maxlen = 0;
var _strlen = string_length(_in);
var _prev = "", _ch;

for (var i=1; i<=_strlen; i++)
{
    _ch = string_char_at(_in, i);
    
    // 다음줄 체크
    if (_ch == "#")
    {
        if (_prev != "\")
        {
            _maxlen = max(_len, _maxlen);
            _len = 0;
        }
        else // 다음줄 이스케이프 = [\#] -> [#] 따라서 글자 1개만큼 길이를 줄여야 한다
        {
            _len -= global.hjCharWidAscii + global.hjGlyphKerning;
        }
    }
    
    // 너비 더하기
    if (ord(_ch) >= 0 && ord(_ch) <= $FF) // ASCII 문자 너비 더하기
        _len += global.hjCharWidAscii + global.hjGlyphKerning;
    else // 한글 문자 너비 더하기
        _len += global.hjCharWidHan + global.hjGlyphKerning;
    
    _prev = _ch;
}

// 마지막 체크
_maxlen = max(_len, _maxlen);

return _maxlen;
