///hj_draw_wave(x, y, str, xscale, yscale, angle, colour, alpha, t, size, freq, offset)
/*
    물결모양으로 슝슝거리는 글자!!
    YEAH!! CRACKTRO!!
    
    ==================================
    x, y : 글자 그리는 좌표
    str : 그릴 문자열
    xscale, yscale : 글자의 크기 (원본 크기에 곱해집니다)
    angle : 회전
    colour : 글자 색
    alpha : 글자 알파 (투명도)
    t : time
    size : wavesize
    freq : wavefreq
    offset : waveoffset
*/

// 변수
var _strx = argument0, _stry = argument1, _str = argument2, _xscale = argument3, _yscale = argument4, _strangle = argument5;
var _strcol = argument6, _stralpha = argument7;
var _time = argument8 * 0.1, _size = argument9, _freq = argument10, _offset = argument11;
var _offx = _strx, _offy = _stry; // 최종 글자 위치 변수 (줄바꿈 & 정렬... ETC에 사용)

// 글자 오프셋 계산
var _sin = dsin(-_strangle);
var _cos = dcos(-_strangle);
var _lines = 0;
var _linehei = _yscale * max(global.hjCharHeiAscii, global.hjCharHeiHan); // 한 줄 높이
var _lineheix = -_sin * _linehei;
var _lineheiy = _cos * _linehei;
var _stepxhan = _cos * _xscale * (global.hjCharWidHan + global.hjGlyphKerning); // 매 글자마다 더해지는 x 오프셋 변수 (한글)
var _stepxascii = _cos * _xscale * (global.hjCharWidAscii + global.hjGlyphKerning); // 매 글자마다 더해지는 x 오프셋 변수 (ASCII)
var _stepyhan = _sin * _yscale * (global.hjCharWidHan + global.hjGlyphKerning); // 매 글자마다 더해지는 y 오프셋 변수 (한글)
var _stepyascii = _sin * _yscale * (global.hjCharWidAscii + global.hjGlyphKerning); // 매 글자마다 더해지는 y 오프셋 변수 (ASCII)

// 글자 렌더링 준비
// string_char_at() 이 드럽게 느려서 배열로 바꿔줍니다. 배열로 바꿔주는 김에 초/중/종성 인덱스도 같이 캐시해줍니다.
// https://forum.yoyogames.com/index.php?threads/draw_wrapped_colored_text-optimization-the-mother-of-all-textboxes.35901/
var _strarray = global.hjCacheData[? _str], _strlen;
if (_strarray == undefined)
{
    _strarray = hj_dkb_compile_str(_str);
    global.hjCacheData[? _str] = _strarray;
}
_strlen = array_length_1d(_strarray);

var _linestr = hj_string_get_first_line(_str); // 첫 줄 가져오기
_str = string_delete(_str, 1, string_length(_linestr)); // 첫 줄을 제외한 글자 가져오기

// 글자 너비 & 높이
// _strhei 는 argument2(원본 문자열) 에서 계산합니다.
// 보시다시피 위에서 _str를 수정해버렸으니깐요
var _strwid = hj_string_width_line(_linestr), _strhei = hj_string_height(argument2);

// 정렬 & 오프셋
var _alignx = -((_strwid >> 1) * global.hjDrawAlignH) * _xscale; // X축 정렬을 위한 오프셋
var _aligny = -((_strhei >> 1) * global.hjDrawAlignV) * _yscale; // Y축 정렬을 위한 오프셋

// Pivot points 응용
// https://yal.cc/2d-pivot-points/
_offx += _alignx * _cos - _aligny * _sin;
_offy += _alignx * _sin + _aligny * _cos;


// 글자 렌더링 루틴
// 미리 처리된 글자를 _strarray 배열에서 하나씩 빼먹으며 그 데이타로 글자를 드로우합니다.
var _data = -1, _widdata = -1;
var _type, _idx1, _idx2, _idx3;
var _t, _waveoffx, _waveoffy, _ang;
for (var i=0; i<_strlen; i++)
{
    // 현재 위치의 글자 가져오기 & 오프셋 계산
    _data = _strarray[@ i];
    _type = _data[@ 0];
    _idx1 = _data[@ 2];
    _idx2 = _data[@ 3];
    _idx3 = _data[@ 4];
    
    _t = sin(_time + (_offset + i) * _freq) * _size;
    _ang = _t * 0.25;
    _waveoffx = -_sin * _t;
    _waveoffy = _cos * _t;

    switch (_type)
    {
        case 0: // 다음 줄
            _lines++;
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
            _alignx = -(_strwid >> 1) * global.hjDrawAlignH * _xscale; // X축 정렬을 위한 오프셋
            _offx = _strx + _alignx * _cos - _aligny * _sin + (_lineheix * _lines);
            _offy = _stry + _alignx * _sin + _aligny * _cos + (_lineheiy * _lines);
            break;
        case 1: // 스페이스바 / 화이트스페이스
            // 오프셋 증가
            _offx += _stepxascii;
            _offy += _stepyascii;
            break;
        default:
        case 2: // ASCII
            draw_sprite_ext(global.hjSpriteAscii, _idx1, _offx + _waveoffx, _offy + _waveoffy, _xscale, _yscale, _strangle + _ang, _strcol, 1);
            
            // 오프셋 증가
            _offx += _stepxascii;
            _offy += _stepyascii;
            break;
        case 3: // 조합형 한글
            draw_sprite_ext(global.hjSpriteHan, _idx1, _offx + _waveoffx, _offy + _waveoffy, _xscale, _yscale, _strangle + _ang, _strcol, 1);
            draw_sprite_ext(global.hjSpriteHan, _idx2, _offx + _waveoffx, _offy + _waveoffy, _xscale, _yscale, _strangle + _ang, _strcol, 1);
            draw_sprite_ext(global.hjSpriteHan, _idx3, _offx + _waveoffx, _offy + _waveoffy, _xscale, _yscale, _strangle + _ang, _strcol, 1);
            
            // 오프셋 증가
            _offx += _stepxhan;
            _offy += _stepyhan;
            break;
            
        case 4: // 한글 자모
            draw_sprite_ext(global.hjSpriteHan, _idx1, _offx + _waveoffx, _offy + _waveoffy, _xscale, _yscale, _strangle + _ang, _strcol, 1);
            
            // 오프셋 증가
            _offx += _stepxhan;
            _offy += _stepyhan;
            break;
    }
}
