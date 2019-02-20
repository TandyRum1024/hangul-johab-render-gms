///hj_draw_sheet(kor_font_sprite, ascii_font_sprite, x, y, str, colour, alpha)
/*
    hj_draw() 와 같지만 통짜 스프라이트 (= 서브이미지가 없고 모든 글자가 한 이미지에 채워져있는 것)
    를 사용합니다. (이전 버젼과 같이요.)
    
    kor_font_sprite & ascii_font_sprite - 폰트 스프라이트
    (ascii_font_sprite 에 -1를 넣으면 kor_font_sprite으로 ASCII 문자까지 커버합니다.)
    (global.hjUseAsciiSprite 와 같은 효과)
*/

// 변수
var _korspr = argument0;
var _asciispr = argument0;
var _str = argument4;
var _strx = argument2, _stry = argument3; // 글자 위치
var _offx = 0, _offy = 0; // 글자 위치에 더해지는 오프셋 변수 (줄바꿈 & 정렬... ETC에 사용)
var _originx = 0, _originy = 0; // 오프셋 원본 위치
var _strcol = argument5, _stralpha = argument6;
var _strlen = string_length(_str);
var _asciioff = 0;

// var _rowfirst = global.hjOffFirst / 28;
// var _rowmiddle = global.hjOffMiddle / 28;
// var _rowlast = global.hjOffLast / 28;
// var _rowjamo = global.hjOffJamo / 28;
// var _rowascii = global.hjOffAscii / 28;

// 글자 렌더링 준비
if (argument1 != -1)
{
    _asciioff = global.hjOffAscii;
    _asciispr = argument1;
}

// 글자 렌더링 루틴
var _curchr = "", _curord = $BEEF;
var _escape = false; // 바로 전 글자가 \ (backslash) 인가요? (줄바꿈 무시 기능에 사용)
var _dx, _dy;
for (var i=1; i<=_strlen; i++)
{
    // 현재 위치의 글자 가져오기 & 오프셋 계산
    _curchr = string_char_at(_str, i);
    _curord = ord(_curchr);
    _dx = _strx + _offx;
    _dy = _stry + _offy;
    
    // ASCII (& 줄바꿈 etc)
    if (_curord >= 0 && _curord <= global.hj_ASCII_LIMIT)
    {
        var _drawchr = _curchr;
        
        // 줄바꿈
        if (_curchr == "#" && !_escape)
        {
            _offx = _originx;
            _offy += global.hjGlpyhLineheight + global.hjCharHeiKor;
            continue; // 쌩까기
        }
        // 이스케이프 시퀀스
        if (_curchr == "\")
        {
            _escape = true;
            continue;
        }
        else
        {
            _escape = false;
        }
        
        // iui_rect(_dx, _dy, global.hjCharWidAscii, global.hjCharWidAscii, ~_strcol);
        // iui_label(_dx, _dy, _drawchr, c_black);
        
        var _idx = _curord + global.hjOffAscii;
        var _u = (_idx % 28) * global.hjCharWidAscii;
        var _v = (_idx div 28) * global.hjCharHeiAscii;
        draw_sprite_general(_asciispr, 0, _u, _v, global.hjCharWidAscii, global.hjCharHeiAscii, _dx, _dy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidAscii + global.hjGlyphKerning;
    }
    else // 한글
    {
        var _kr;
        if (_curord >= $AC00 && _curord <= $D7AF) // 조합
        {
            _kr = _curord - $AC00;
            
            // 초/중/종성 구하기 & 벌 (오프셋) 구하기
            var _first = (_kr div 588);
            var _mid = ((_kr % 588) div 28);
            var _last = (_kr % 28);
            var _offlast = global.hj_LUT_BEOL_MID[_mid] * global.hjSpecialMiddle;
            var _offmid = global.hj_LUT_BEOL_LAST[_last] * global.hjSpecialLast;
            var _offfirst = _offlast + _offmid * 2;
            
            var _idx = _first + _offfirst + global.hjOffFirst;
            var _u = (_idx % 28) * global.hjCharWidKor;
            var _v = (_idx div 28) * global.hjCharHeiKor;
            draw_sprite_general(global.hjSpriteKor, 0, _u, _v, global.hjCharWidKor, global.hjCharHeiKor, _dx, _dy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
            
            var _idx = _mid + _offmid + global.hjOffMiddle;
            var _u = (_idx % 28) * global.hjCharWidKor;
            var _v = (_idx div 28) * global.hjCharHeiKor;
            draw_sprite_general(global.hjSpriteKor, 0, _u, _v, global.hjCharWidKor, global.hjCharHeiKor, _dx, _dy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
            
            var _idx = _last + _offlast + global.hjOffLast;
            var _u = (_idx % 28) * global.hjCharWidKor;
            var _v = (_idx div 28) * global.hjCharHeiKor;
            draw_sprite_general(global.hjSpriteKor, 0, _u, _v, global.hjCharWidKor, global.hjCharHeiKor, _dx, _dy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
            // draw_sprite_ext(global.hjSpriteKor, _first + global.hjOffFirst + _offfirst, _dx, _dy, 1, 1, 0, _strcol, 1);
            // draw_sprite_ext(global.hjSpriteKor, _mid + global.hjOffMiddle + _offmid, _dx, _dy, 1, 1, 0, _strcol, 1);
            // draw_sprite_ext(global.hjSpriteKor, _last + global.hjOffLast + _offlast, _dx, _dy, 1, 1, 0, _strcol, 1);
            
            // 오프셋 증가
            _offx += global.hjCharWidKor + global.hjGlyphKerning;
        }
        else if (_curord >= $3130 && _curord <= $3163)// 호환용 자모 ([ㄱㄴㄷㄻㅄ ㅏㅒㅑㅛ] ETC...)
        {
            _kr = _curord - $3130 + global.hjOffJamo;
            
            // draw_sprite_ext(global.hjSpriteKor, global.hjOffJamo + _kr, _dx, _dy, 1, 1, 0, _strcol, 1);
            var _u = (_kr % 28) * global.hjCharWidKor;
            var _v = (_kr div 28) * global.hjCharHeiKor;
            draw_sprite_general(global.hjSpriteKor, 0, _u, _v, global.hjCharWidKor, global.hjCharHeiKor, _dx, _dy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
            
            // 오프셋 증가
            _offx += global.hjCharWidKor + global.hjGlyphKerning;
        }
        else // 며느리도 모르는 외계어
        {
            _kr = "u["+string(_curord)+"]";
            // draw_sprite_ext(_asciispr, _asciioff + 63, _dx, _dy, 1, 1, 0, c_red, 1); // ????????
            draw_text_colour(_dx, _dy, _kr, c_red, c_red, c_red, c_red, 1);
            
            // 오프셋 증가
            _offx += string_width(_kr) + global.hjGlyphKerning;
        }
        
    }
}
