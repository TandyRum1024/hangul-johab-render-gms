#define hj_init
/*
    한글 조합형 드로잉 MK.2
    ZIK @ 2019
    =======================
    이전 한글 드로잉 함수들은 hj_..._old 형식으로 보존되어있습니다.
*/

// 폰트 관련
global.hjSpriteKor = sprHangul24; // 한글 스프라이트
global.hjSpriteAscii = sprYayoC64; // ASCII 스프라이트
global.hjCharWidKor = 24; // 글자 한 칸의 너비와 높이 (한글)
global.hjCharHeiKor = 24;
global.hjCharWidAscii = 24; // 글자 한 칸의 너비와 높이 (ASCII)
global.hjCharHeiAscii = 24;
global.hjGlyphKerning = 1; // 글자간 간격 (글자 너비 포함)
global.hjGlpyhLineheight = 1; // 줄 간격 (글자 높이 포함)
global.hjUseAsciiSprite = false; // 별도의 ASCII 스프라이트 사용 여부
////////////////////////

// 한글 관련
global.hjSpecialMiddle = true; // 초성 & 종성의 중성 없는 버젼 사용?
global.hjSpecialLast = true; // 초성 & 중성의 종성 없는 버젼 사용?
global.hjBeolFirst = 4; // 초성 벌 수 -- (2벌: 중성 고려, 4벌: 중성 고려 & 종성 없는 글자)
global.hjBeolMiddle = 2; // 중성 벌 수 -- (1벌: 일반, 2벌: 종성 없는 글자)
global.hjBeolLast = 2; // 종성 벌 수
global.hjBeolJamo = 2; // 자모 벌 수
////////////////////////

// 드로잉 관련
global.hjDrawAlignH = 0; // 글자 맞춤 / 정렬
global.hjDrawAlignV = 0;
////////////////////////

// 오프셋
global.hjOffFirst = 0; // 초성 인덱스 오프셋
global.hjOffMiddle = global.hjOffFirst + (global.hjBeolFirst * 28); // 중성 오프셋
global.hjOffLast = global.hjOffMiddle + (global.hjBeolMiddle * 28); // 종성 오프셋
global.hjOffJamo = global.hjOffLast + (global.hjBeolLast * 28); // 자모 오프셋
global.hjOffAscii = global.hjOffJamo + (global.hjBeolJamo * 28); // ASCII 오프셋
////////////////////////

// 단단한 상수
global.hj_ASCII_LIMIT = 127; // ASCII 범위
global.hj_LUT_BEOL_MID = -1; // 중성에 따른 초성 / 종성 벌 오프셋 테이블 ('감' vs '곰')
for (var i=0; i<=7; i++)
    global.hj_LUT_BEOL_MID[i] = 0; // 중성 [ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅣ] 는 1번째 벌 쓰기
global.hj_LUT_BEOL_MID[20] = 0;
for (var i=8; i<=19; i++)
    global.hj_LUT_BEOL_MID[i] = 28; // 중성 [ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ]는 2번째 벌 쓰기
//
global.hj_LUT_BEOL_LAST = -1; // 종성 여부에 따른 초성 벌 오프셋 테이블 ('곰' vs '가')
global.hj_LUT_BEOL_LAST[0] = 28; // 종성 없으면 벌 3~4 가져다 쓰기
for (var i=1; i<=27; i++)
    global.hj_LUT_BEOL_LAST[i] = 0; // 나머지는 그대로
////////////////////////

#define hj_draw
///hj_draw(x, y, str, colour, alpha)
/*
    한글을 그리는 함수
*/

// 변수
var _str = argument2;
var _strx = argument0, _stry = argument1; // 글자 위치
var _offx = 0, _offy = 0; // 글자 위치에 더해지는 오프셋 변수 (줄바꿈 & 정렬... ETC에 사용)
var _originx = 0, _originy = 0; // 오프셋 원본 위치
var _strcol = argument3, _stralpha = argument4;
var _strlen = string_length(_str);
var _asciioff = 0;
var _asciispr = global.hjSpriteAscii;

// 글자 렌더링 준비
if (!global.hjUseAsciiSprite)
{
    _asciioff = global.hjOffAscii;
    _asciispr = global.hjSpriteKor;
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
        // draw_image_ext(_asciispr, _asciioff + _curord, _dx, _dy, 1, 1, 0, _strcol, 1);
        draw_sprite_ext(_asciispr, _asciioff + _curord, _dx, _dy, 1, 1, 0, _strcol, 1);
        
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
            var _first = _kr div (588);
            var _mid = (_kr % (588)) div 28;
            var _last = _kr % 28;
            var _offlast = global.hj_LUT_BEOL_MID[_mid] * global.hjSpecialMiddle;
            var _offmid = global.hj_LUT_BEOL_LAST[_last] * global.hjSpecialLast;
            var _offfirst = _offlast + _offmid * 2;
            
            draw_sprite_ext(global.hjSpriteKor, _first + global.hjOffFirst + _offfirst, _dx, _dy, 1, 1, 0, _strcol, 1);
            draw_sprite_ext(global.hjSpriteKor, _mid + global.hjOffMiddle + _offmid, _dx, _dy, 1, 1, 0, _strcol, 1);
            draw_sprite_ext(global.hjSpriteKor, _last + global.hjOffLast + _offlast, _dx, _dy, 1, 1, 0, _strcol, 1);
            
            // 오프셋 증가
            _offx += global.hjCharWidKor + global.hjGlyphKerning;
        }
        else if (_curord >= $3130 && _curord <= $3163)// 호환용 자모 ([ㄱㄴㄷㄻㅄ ㅏㅒㅑㅛ] ETC...)
        {
            _kr = _curord - $3130;
            draw_sprite_ext(global.hjSpriteKor, global.hjOffJamo + _kr, _dx, _dy, 1, 1, 0, _strcol, 1);
            
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