#define hj_init
/*
    코리안 만쉐이
    직박구루@2018
    =====================================
    지원 하는것 :
    - 초/중/종성 조합형 렌더링 (자모 지원)
    - 모노스페이스 폰트여서 모든 글자가 같은 크기를 차지합니다.
    - 매우 제한된 아스키 폰트 렌더링 (아마 0x00 ~ 0x7F 범위 +a 정도 지원할거에요.)
    - (물론 따로 폰트 스프라이트를 쓰면 극복가능, 아래 참고하세요)
    =====================================
    직접 폰트 만드는법:
    A] 일단 폰트 글자 한 칸당 몇 픽셀을 차지하는지 정하세요. 32px 이나 64px, 24px 같이요.
    
    B] 폰트 스프라이트는 가로로 28칸, 세로로 12칸이 되게 해줘요.
    최종 이미지 사이즈는 (28 * [한 칸 크기]) x (12 * [한 칸 크기]) 가 되겠죠?
    (EX : 한 칸당 24px 크기라면 [672 x 288] 사이즈의 스프라이트가 필요해요)
    
    C] 폰트 견본 (24px 크기) sprHangul24 를 참고해서 폰트를 제작하세요.
    - 초성 2줄, 중성 1줄, 종성 2줄과 자모 2 줄
    
    - A] 만약 한글 폰트에 ASCII 도 포함하실가면 남은 빈 공간 전부를 아스키 문자로 채우시면 되요.
    (ASCII는 0부터 0x7F까지; 0x7F 번째 글자 부터는 아무렇게나 써도 될겁니다. 저처럼 이모티콘같은걸 넣어도 되고요.)
    
    - B] 만약에 ASCII 스프라이트를 따로 사용하실거라면 아래 폰트 설정에서 ascii 관련 변수를 설정해주세요.
    ASCII 폰트는 한 줄에 16칸을 차지하며 총 16줄입니다.
    256개의 글자가 필요해요.
    (아님 저처럼 귀찮으시면 드워프 포트리스에서 끌어다 쓰세요)
    (http://dwarffortresswiki.org/Tileset_repository?ref=binfind.com/web)
    
    ------------------------------------
    !!주의사항!! :
    초성과 종성은 총 2줄을 차지해요.
    
    [ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅣ] 는 초성 / 종성의 첫번째 줄을 써요. (ex : 각 객)
    - 큰 초성
    
    [ㅗ ㅠ ㅘ ㅛ ㅙ ㅚ ㅜ ㅝ ㅞ ㅟ ㅡ ㅢ] 는 초성 / 종성의 두번째 줄을 써요. (ex : 금 곰 겅)
    - 작은 초성 (중성 'ㅗ' 와 'ㅘ' 를 고려하세요), 센터에 있는 종성
*/

/*
    평범한 설정
    =============================================================
*/
// ASCII 전용 폰트 스프라이트 사용 여부 (이러면 한글폰트 스프라이트에 있는 건 무시됩니다)
// 아래 ASCII 폰트 설정 도 확인하세요!
global.hangulExternalAscii = false;

// 중성에 따라 종성의 모양을 변하게 할까요?
global.hangulUseJungBeol = true;

// 한 줄의 크기입니다. 다음줄로 넘어갈때 이만큼 아래로 내려갑니다. (픽셀 단위)
global.hangulLineheight = 30;

/*
    한글 폰트 설정
    =============================================================
    직접 만든 폰트를 쓰실때 이 변수들을
    폰트에 맞게 설정해주세요!
*/
// 한글 드로잉에 사용될 스프라이트
global.hangulFont = sprHangul24;

// 한 글자당 글자 크기 -- 모노스페이스 폰트여서 높이와 너비가 같습니다
// sprHangul24 (현재 폰트) 을 예를 들면 한 칸 당 24px 입니다.
global.hangulFntSize = 24;

// 한글 자간 여백 (픽셀 단위)
global.hangulKerning = 1;

/*
    ASCII 폰트 설정
    =============================================================
    global.hangulExternalAscii 가 true 일때만 사용됩니다.
    직접 만든 폰트를 쓰실때 이 변수들을
    폰트에 맞게 설정해주세요!
*/
// ASCII 드로잉 전용 스프라이트; 
global.hangulAsciiFont = sprYayoC64;

// ASCII 전용 스프라이트의 크기
global.hangulAsciiFntSize = 16;

// ASCII 코드의 범위. (아직 사용안됨)
global.hangulAsciiRange = $7F;

// (ASCII 폰트 스프라이트 전용) 자간 여백 (픽셀 단위) (아직 사용안됨)
global.hangulAsciiKerning = 1;

/*
    슈퍼 어드밴스드 ZONE
    (아래 변수가 뭔짓을 하는지 알고 있다면 수정하셔도 되고, 아니면 그냥 이대로 냅두시면 됩니다.)
    ================================================================================
*/
// cache boy
global.hangulWidthCache = ds_map_create();

// (스프라이트) 한 줄에 몇칸이 있는지 저장하는 변수
// sprHangul24 같은 경우엔 한 줄에 28칸이 있죠.
global.hangulFontRows = 28;
global.hangulAsciiFontRows = 16; // ascii plz

// 초중종성 오프셋
// 초성중성종성은 줄을 기준으로 구분합니다. (0부터 시작해요)
global.hangulChoOffset = 0; // sprHangul24는 초성이 1번째 줄! (2 줄을 차지해요)
global.hangulJungOffset = global.hangulFntSize * 2; // 중성은 3번째 줄부터!
global.hangulJongOffset = global.hangulFntSize * 3; // 종성은 4번째 줄부터! (2 줄을 차지해요)

// 자모 ("ㅇㅇ ㅋㅋ ㅗㅜㅑ" <- 이런것들), 아스키의 오프셋
global.hangulJamoOffset = global.hangulFntSize * 5; // 자모는 6번째 줄, 2줄 차지
global.hangulAsciiOffset = global.hangulFntSize * 7; // ASCII (0x00~0x7F +a) 는 8번째 줄부터 끝까지

// 글자 정렬 (== draw_set_halign 같은거)에 쓰이는 변수
global.hangulAlignH = 0;
global.hangulAlignV = 0;

// 한글 벌식 LUT (초성이나 종성의 모양을 결정할때 쓰입니다.)
var BEOL_OFFSET = global.hangulFontRows;
for (var i=0; i<=7; i++)
    global.hangul_beol_lut[i] = 0;
global.hangul_beol_lut[20] = 0;

for (var i=8; i<20; i++)
    global.hangul_beol_lut[i] = global.hangulFntSize;
/*
    ================================================================================
    슈퍼 어드밴스드 ZONE 끝
*/

#define hj_draw
///hj_draw(x, y, string, colour, alpha)
/*
    한글을 드로우 합니다.
    x, y - 위치
    string - 드로우 할 문자열
    colour - 색
    alpha - 알파
*/

// 글로벌 변수 미리 저장해두기
var hangulFont = global.hangulFont;
var asciiFont = global.hangulAsciiFont;

var jungBeolMod = global.hangulUseJungBeol;
var choOffset = global.hangulChoOffset;
var jungOffset = global.hangulJungOffset;
var jongOffset = global.hangulJongOffset;
var jamoOffset = global.hangulJamoOffset;
var asciiOffset = global.hangulAsciiOffset;
var beol_lut = global.hangul_beol_lut;
var halign = global.hangulAlignH;
var valign = global.hangulAlignV;
var hangulSize = global.hangulFntSize;
var asciiSize = global.hangulAsciiFntSize;
var hangulKerning = global.hangulKerning;
var asciiKerning = global.hangulAsciiKerning;
var useAsciiSpr = global.hangulExternalAscii;
var glyphsperrow = global.hangulFontRows;
var asciiperrow = global.hangulAsciiFontRows;
var hangulLineHeight = global.hangulLineheight;

var strX = argument0;
var strY = argument1;
var str = argument2;
var col = argument3;
var alpha = argument4;
// var rot = argument5;
var strlen = string_length(str);

var _cho, _jung, _jong;
var _utf;
var beolOffset;

var lineWidth = hj_get_width_line(str);
var lineHeight = hj_get_height(str);
var offX, offY, tX, tY;

// Calc font offset via align
if (halign == 1)
        tX = -(lineWidth >> 1);
else if (halign == 2)
        tX = -lineWidth;

if (valign == 1)
        tY = -(lineHeight >> 1);
else if (valign == 2)
        tY = -lineHeight;

// Transform
/*
d3d_transform_stack_push();
d3d_transform_set_translation(tX, tY, 0);
d3d_transform_add_rotation_z(rot);
d3d_transform_add_translation(strX, strY, 0);
*/

offX = strX + tX;
offY = strY + tY;

// Draw hangul
for (var i=1; i<=strlen; i++)
{
    _utf = string_ord_at(str, i);
    
    // Check Ascii / newline
    if (_utf == ord('\'))
    {
        var _mark = string_char_at(str, i + 1);
        if (_mark == 'n')
        {
            offX = strX;
            offY += hangulLineHeight;
            
            // 스트링 너비 재계산
            lineWidth = hj_get_width_line(string_delete(str, 1, i + 1));
            // show_debug_message("WID : [" + string_delete(str, 1, i + 1) + "]" + string(lineWidth));
            
            if (halign == 1)
                    tX = -(lineWidth >> 1);
            else if (halign == 2)
                    tX = -lineWidth;
            
            /*
            d3d_transform_set_translation(tX, tY, 0);
            d3d_transform_add_rotation_z(rot);
            d3d_transform_add_translation(strX, strY, 0);
            */
            offX += tX;
            
            i++;
            continue;
        }
        else if (_mark == '\')
            i++;
    }
    
    if (_utf < $AC00 && !(_utf >= $3130 && _utf <= $3163)) // 아스키
    {
        if (useAsciiSpr)
        {
            var _u = asciiSize * (_utf % asciiperrow);
            var _v = asciiSize * (_utf div asciiperrow);
            // var _idx = (_utf % 28) + asciiOffset + (28 * (_utf div 28));
            // draw_sprite_ext(global.hangulFont, _idx, offX, offY, 1, 1, 0, col, alpha);
            draw_sprite_part_ext(asciiFont, 0, _u, _v, asciiSize, asciiSize, offX, offY, 1, 1, col, alpha);
            
            // draw_rectangle_colour(offX, offY, offX + asciiSize, offY + asciiSize, $FF00FF, $FF00FF, $FF00FF, $FF00FF, true);
            
            // Advance
            offX += asciiSize * asciiKerning;
        }
        else
        {
            var _u = hangulSize * (_utf % glyphsperrow);
            var _v = asciiOffset + (hangulSize * (_utf div glyphsperrow));
            // var _idx = (_utf % 28) + asciiOffset + (28 * (_utf div 28));
            draw_sprite_part_ext(hangulFont, 0, _u, _v, hangulSize, hangulSize, offX, offY, 1, 1, col, alpha);
            
            // draw_rectangle_colour(offX, offY, offX + hangulSize, offY + hangulSize, $FF00FF, $FF00FF, $FF00FF, $FF00FF, true);
            
            // Advance
            offX += hangulSize * hangulKerning;
        }
    }
    // Full hangul
    else
    {
        // Check Jamo only
        if (_utf >= $3130 && _utf <= $3163)
        {
            _utf -= $3130;
            // var _idx = (_utf % 28) + jamoOffset + 28 * (_utf div 28);
            // draw_sprite_ext(global.hangulFont, _idx, offX, offY, 1, 1, 0, col, alpha);
            
            var _u = hangulSize * (_utf % glyphsperrow);
            var _v = jamoOffset + (hangulSize * (_utf div glyphsperrow));
            
            draw_sprite_part_ext(hangulFont, 0, _u, _v, hangulSize, hangulSize, offX, offY, 1, 1, col, alpha);
        }
        else
        {
            _utf -= $AC00;
        
            _cho    = _utf div (588);
            _jung   = (_utf % (588)) div 28;
            _jong   = _utf % 28;
            
            // Determine beol from jungseong
            beolOffset = beol_lut[_jung];
            
            // Choseong
            draw_sprite_part_ext(hangulFont, 0, _cho * hangulSize, choOffset + beolOffset, hangulSize, hangulSize, offX, offY, 1, 1, col, alpha);
            
            // Jungseong
            // draw_sprite_ext(global.hangulFont, jungOffset + _jung, offX, offY, 1, 1, 0, col, alpha);
            draw_sprite_part_ext(hangulFont, 0, _jung * hangulSize, jungOffset, hangulSize, hangulSize, offX, offY, 1, 1, col, alpha);
            
            // Jongseong
            // draw_sprite_ext(global.hangulFont, jongOffset + beolOffset, (beolOffset * jungBeolMod) + _jong, offX, offY, 1, 1, 0, col, alpha);
            draw_sprite_part_ext(hangulFont, 0, _jong * hangulSize, jongOffset + (hangulSize * (!jungBeolMod)) + (beolOffset * jungBeolMod), hangulSize, hangulSize, offX, offY, 1, 1, col, alpha);
        }
        
        // draw_rectangle_colour(offX, offY, offX + hangulSize, offY + hangulSize, $FF00FF, $FF00FF, $FF00FF, $FF00FF, true);
        
        // Advance
        offX += hangulSize * hangulKerning;
    }
}

// d3d_transform_stack_pop();

#define hj_get_width_line
///hj_get_width_line(str)
/*
    문자열 한 줄의 너비를 구합니다.
*/

var idx, len = 0;

var useAsciiFont = global.hangulExternalAscii;
var hangulSize = global.hangulFntSize;
var asciiSize = global.hangulAsciiFntSize;
var cache = global.hangulWidthCache;

// escape & get line
var slashPos = string_pos("\", argument0);
var sumPos = slashPos;
var tmp = argument0;
var line = argument0;
while (slashPos > 0)
{
    if (string_char_at(tmp, slashPos + 1) == "n")
    {
        line = string_copy(argument0, 0, sumPos - 1);
        break;
    }
    else if (string_char_at(tmp, slashPos + 1) == "\")
        tmp = string_delete(tmp, slashPos, 1);
    
    
    tmp = string_delete(tmp, 0, slashPos);
    slashPos = string_pos("\", tmp);

    sumPos += slashPos;
}

// show_debug_message(line);

// CACHE BOY
if (cache[? line] != undefined)
{
    return cache[? line];
}

/*
var idx = 0;
var strlen = string_length(line);
for (var i=0; i<strlen; i++)
{
    if (useAsciiFont && string_ord_at(line, i) < $AC00) // ascii
        len += asciiSize;
    else
        len += hangulSize;
}
*/

// TODO : MAKE THIS THING WORK >:(

if (useAsciiFont) // Variable letter size
{
    var strlen = string_length(line);
    for (var i=0; i<strlen; i++)
    {
        var _utf = string_ord_at(line, i);
        if (_utf < $AC00 && !(_utf >= $3130 && _utf <= $3163)) // ascii
            len += asciiSize;
        else
            len += hangulSize;
    }
}
else // All glyphs has same size
{
    var lineLen;
    lineLen = string_length(line);
        
    // show_debug_message("LW : " + line + "], LEN : " + string(lineLen) + " [" + string(lineLen * hangulSize) + "]");
    
    // Escape sequence and newline stuff
    lineLen -= string_count("\n", line);
    lineLen -= string_count("\\", line);
        
    return lineLen * hangulSize;
}

// Cache er' up
cache[? line] = len;

return len;

#define hj_get_height
///hj_get_height(str)
/*
    문자열의 높이 구하기
*/

return global.hangulLineheight + global.hangulLineheight * string_count("\n", argument0);

#define hj_set_align
///hj_set_align(halign, valign);
/*
    hj_set_halign & hj_set_valign 일체형
*/

global.hangulAlignH = argument0;
global.hangulAlignV = argument1;

#define hj_set_halign
///hj_set_halign(halign);
/*
    한글 드로우시 가로 정렬을 설정합니다.
    draw_set_halign 과 같습니다.
    
    0 = 왼쪽 (일반)
    1 = 가운데
    2 = 오른쪽
*/

global.hangulAlignH = argument0;

#define hj_set_valign
///hj_set_halign(valign);
/*
    한글 드로우시 세로 정렬을 설정합니다.
    draw_set_valign 과 같습니다.
    
    0 = 위 (일반)
    1 = 가운데
    2 = 아래
*/

global.hangulAlignV = argument0;

#define hj_set_center
///hj_set_center();
/*
    가운데 정렬
*/

global.hangulAlignH = 1;
global.hangulAlignV = 1;

#define hj_set_topleft
///hj_set_topleft();
/*
    왼쪽 위 정렬
*/

global.hangulAlignH = 0;
global.hangulAlignV = 0;