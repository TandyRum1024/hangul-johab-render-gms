///hj_draw_sheet(kor_font_sprite, ascii_font_sprite, x, y, str, colour, alpha)
/*
    한글을 그립니다.
    통짜 스프라이트 (= 서브이미지가 없고 모든 글자가 한 이미지에 채워져있는 것)를 사용합니다. (이전 버젼 호환용)
    
    kor_font_sprite & ascii_font_sprite - 폰트 스프라이트
    (ascii_font_sprite 에 -1를 넣으면 kor_font_sprite으로 ASCII 문자까지 커버합니다.)
    (global.hjUseAsciiSprite 와 같은 효과)
    
    글자 크기는 그대로 글로벌 변수에서 가져옵니다.
    hj_init() 참고!
*/

// 변수
var _korspr = argument0;
var _asciispr = argument0;
var _str = argument4;
var _strx = argument2, _stry = argument3; // 글자 위치
var _offx = _strx, _offy = _stry; // 글자 위치에 더해지는 오프셋 변수 (줄바꿈 & 정렬... ETC에 사용)
// var _originx = 0, _originy = 0; // 오프셋 원본 위치
var _strcol = argument5, _stralpha = argument6;
var _strlen = string_length(_str);
var _asciioff = global.hjCompOffAscii;
var _asciicol = 28;

// var _rowfirst = global.hjOffFirst / 28;
// var _rowmiddle = global.hjOffMiddle / 28;
// var _rowlast = global.hjOffLast / 28;
// var _rowjamo = global.hjOffJamo / 28;
// var _rowascii = global.hjOffAscii / 28;

// 글자 렌더링 준비
if (argument1 != -1)
{
    _asciioff = 0;
    _asciispr = argument1;
    _asciicol = 16;
}

// string_char_at 이 드럽게 느려서 배열로 바꿔줍니다.
// https://forum.yoyogames.com/index.php?threads/draw_wrapped_colored_text-optimization-the-mother-of-all-textboxes.35901/
var _strarray = -1;
if (global.hjCache[? _str] == undefined)
{
    for (var i=0; i<_strlen; i++)
    {
        var _byte = string_char_at(_str, i + 1);
        _strarray[i] = _byte;
    }
    
    global.hjCache[? _str] = _strarray;
}
else
{
    _strarray = global.hjCache[? _str];
    _strlen = array_length_1d(_strarray);
}

// 줄 높이 구하기 : ASCII 폰트 높이와 한글 폰트 높이 중 더 큰 것
var _linehei = max(global.hjCharHeiAscii, global.hjCharHeiHan) + global.hjGlpyhLineheight;

// 글자 렌더링 루틴
var _curchr = "", _curord = $BEEF;
var _prevchr = false; // 바로 전 글자
var _kr;
var _idx, _u, _v;
var _first, _mid, _last, _rowlast, _rowmid;
for (var i=0; i<_strlen; i++)
{
    // 현재 위치의 글자 가져오기 & 오프셋 계산
    _curchr = _strarray[@ i];//string_char_at(_str, i);
    _curord = ord(_curchr);
    
    // ASCII (& 줄바꿈 etc)
    if (_curord <= global.hjComp_ASCII_LIMIT)
    {
        // 줄바꿈
        if (_curchr == "#" && _prevchr != "\")
        {
            _offx = _strx;
            _offy += _linehei;
            continue; // 쌩까기
        }
        
        _idx = _curord + _asciioff;
        _u = (_idx % _asciicol) * global.hjCharWidAscii;
        _v = (_idx div _asciicol) * global.hjCharHeiAscii;
        draw_sprite_general(_asciispr, 0, _u, _v, global.hjCharWidAscii, global.hjCharHeiAscii, _offx, _offy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidAscii + global.hjGlyphKerning;
    }
    else if (_curord >= $AC00 && _curord <= $D7AF) // 조합
    {
        _kr = _curord - $AC00;
        
        // 초/중/종성 구하기 & 벌 (오프셋) 구하기
        _first = (_kr div 588);
        _mid = ((_kr % 588) div 28);
        _last = (_kr % 28);
        _rowlast = global.hjComp_LUT_BEOL_MID[@ _mid] * global.hjCompSpecialMiddle;
        _rowmid = global.hjComp_LUT_BEOL_LAST[@ _last] * global.hjCompSpecialLast;
        
        _u = _first * global.hjCharWidHan;
        _v = global.hjCompOffFirst + _rowlast + _rowmid * 2;
        draw_sprite_general(_korspr, 0, _u, _v, global.hjCharWidHan, global.hjCharHeiHan, _offx, _offy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
        _u = _mid * global.hjCharWidHan;
        _v = global.hjCompOffMiddle + _rowmid;
        draw_sprite_general(_korspr, 0, _u, _v, global.hjCharWidHan, global.hjCharHeiHan, _offx, _offy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
        _u = _last * global.hjCharWidHan;
        _v = global.hjCompOffLast + _rowlast;
        draw_sprite_general(_korspr, 0, _u, _v, global.hjCharWidHan, global.hjCharHeiHan, _offx, _offy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
        // 오프셋 증가
        _offx += global.hjCharWidHan + global.hjGlyphKerning;
    }
    else if (_curord >= $3130 && _curord <= $3163)// 호환용 자모 ([ㄱㄴㄷㄻㅄ ㅏㅒㅑㅛ] ETC...)
    {
        _kr = _curord - $3130 + global.hjOffJamo;
        
        // draw_sprite_ext(global.hjSpriteKor, global.hjOffJamo + _kr, _dx, _dy, 1, 1, 0, _strcol, 1);
        _u = (_kr % 28) * global.hjCharWidHan;
        _v = (_kr div 28) * global.hjCharHeiHan;
        draw_sprite_general(_korspr, 0, _u, _v, global.hjCharWidHan, global.hjCharHeiHan, _offx, _offy, 1, 1, 0, _strcol, _strcol, _strcol, _strcol, 1);
        
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
    
    // 이전 글자
    _prevchr = _curchr;
}
