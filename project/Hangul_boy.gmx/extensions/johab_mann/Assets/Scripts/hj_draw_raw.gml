///hj_draw_raw(x, y, str, colour, alpha)
/*
    한글 문자열을 드로우 합니다. (컴파일같은거 없이 바로 문자열에서 드로우합니다)
    (도깨비 8x4x4벌 형식)
    ==================================
    x, y : 글자 그리는 좌표
    str : 그릴 문자열
    colour : 글자 색
    alpha : 글자 알파 (투명도)
*/

// 변수
var _str = argument2;
var _strlen = string_length(_str);
var _strx = argument0, _stry = argument1; // 글자 위치
var _offx = _strx, _offy = _stry; // 글자 위치에 더해지는 오프셋 변수 (줄바꿈 & 정렬... ETC에 사용)
var _strwid, _strhei;
var _strcol = argument3, _stralpha = argument4;
var _linestr;

// 글자 렌더링 준비
_linestr = hj_string_get_first_line(_str); // 첫 줄 가져오기
_str = string_delete(_str, 1, string_length(_linestr)); // 첫 줄을 제외한 글자 가져오기
_strwid = hj_string_width_line(_linestr); // 글자 너비 & 높이
_strhei = hj_string_height(argument2);

_offx -= (_strwid >> 1) * global.hjDrawAlignH; // 수평 정렬
_offy -= (_strhei >> 1) * global.hjDrawAlignV; // 수직 정렬

// 글자 렌더링 루틴
var _curchr, _curord = $BEEF;
var _escape = false; // 바로 전 글자
var _kr, _widdata;
for (var i=0; i<_strlen; i++)
{
    // 현재 위치의 글자 가져오기 & 오프셋 계산
    // ASCII (& 줄바꿈 etc)
    _curchr = string_char_at(argument2, i + 1);
    _curord = ord(_curchr);
    if (_curord <= $FF)
    {
        // 줄바꿈
        if (_curchr == "#" && !_escape)
        {
            _linestr = hj_string_get_first_line(_str);
            _str = string_delete(_str, 1, string_length(_linestr));
            
            // 다음 줄 넓이 구하기
            // _strwid = hj_string_width_line(_linestr);
            // 캐시 안되어있으면 계산 & 캐시
            _widdata = global.hjCacheWid[? _linestr];
            if (_widdata == undefined)
            {
                _widdata = hj_string_width_line_adv(_linestr);
                global.hjCacheWid[? _linestr] = _widdata;
            }
            
            // 뤼얼 바보같은 생각 : 최종 계산 결과를 또 다시 캐시하면??
            // 결과 : 50+ FPS 증가 (??????????????????????)
            _strwid = global.hjCacheMisc[? _linestr];
            if (_strwid == undefined)
            {
                _strwid = _widdata[@ 0] * (global.hjCharWidAscii + global.hjGlyphKerning)
                        + _widdata[@ 1] * (global.hjCharWidHan + global.hjGlyphKerning);
                global.hjCacheMisc[? _linestr] = _strwid;
            }
            
            // 오프셋 값 변경
            _offx = _strx;
            _offy += global.hjGlyphLineheight + global.hjCharHeiAscii;
            
            // 수평 정렬
            _offx -= (_strwid * 0.5) * global.hjDrawAlignH;
            continue; // 쌩까기
        }
        if (_curchr == "\" && string_char_at(argument2, i + 2) == "#") // 개행 문자 이스케이프
        {
            _escape = true;
            continue;
        }
        else
        {
            _escape = false;
        }
        
        draw_sprite_ext(global.hjSpriteAscii, _curord, _offx, _offy, 1, 1, 0, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidAscii + global.hjGlyphKerning;
    }
    else if (_curord >= $AC00 && _curord <= $D7AF) // 조합형
    {
        _kr = _curord - $AC00;
        
        // 초/중/종성 구하기 & 벌 (오프셋) 구하기
        var _head = (_kr div 588); // 초성
        var _body = ((_kr % 588) div 28); // 중성
        var _tail = (_kr % 28); // 종성 (받침)
        
        var _headidx = _head + 1;
        var _bodyidx = _body + 1;
        var _tailidx = _tail + global.hjLUTTail[@ _body];
        
        if (_tail == 0) // 받침 없는 글자
        {
            _headidx += global.hjLUTHead[@ _body];
            _bodyidx += global.hjLUTBody[@ _head];
        }
        else // 받침 있는 글자
        {
            _headidx += global.hjLUTHeadWithTail[@ _body];
            _bodyidx += global.hjLUTBodyWithTail[@ _head];
        }
        
        draw_sprite_ext(global.hjSpriteHan, _headidx, _offx, _offy, 1, 1, 0, _strcol, 1);
        draw_sprite_ext(global.hjSpriteHan, _bodyidx, _offx, _offy, 1, 1, 0, _strcol, 1);
        draw_sprite_ext(global.hjSpriteHan, _tailidx, _offx, _offy, 1, 1, 0, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidHan + global.hjGlyphKerning;
    }
    else if (_curord >= $3131 && _curord <= $3163)// 호환용 자모 ([ㄱㄴㄷㄻㅄ ㅏㅒㅑㅛ] ETC...)
    {
        _kr = _curord - $3131;
        
        // draw_sprite_ext(global.hjSpriteKor, global.hjOffJamo + _kr, _dx, _dy, 1, 1, 0, _strcol, 1);
        draw_sprite_ext(global.hjSpriteHan, global.hjLUTJamo[@ _kr], _offx, _offy, 1, 1, 0, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidHan + global.hjGlyphKerning;
    }
    else // 며느리도 모르는 외계어
    {
        _kr = "u["+string(_curord)+"]";
        // draw_sprite_ext(_asciispr, _asciioff + 63, _dx, _dy, 1, 1, 0, c_red, 1); // ????????
        draw_text_colour(_offx, _offy, _kr, c_red, c_red, c_red, c_red, 1);
        
        // 오프셋 증가
        _offx += string_width(_kr) + global.hjGlyphKerning;
    }
}
