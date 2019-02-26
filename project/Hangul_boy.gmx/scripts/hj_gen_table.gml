///hj_gen_table(map, string, value)
/*
    자모로 이루어진 스트링을 입력받아 배열에 테이블을 생성/추가 합니다.
    각 자모를 번호로 변환해 (ㄱ = 1, ㅏ = 1 etc...) 배열의 인덱스값으로 저장하며
    값은 주어진 value 인자로 설정합니다.
    결과값은 초성/중성/종성을 이용해 알맞은 벌을 찾기 위해 사용됩니다.
*/
var _in = argument1, _map = argument0, _val = argument2;

// if (!ds_exists(_map, ds_type_map))
//     _map = ds_map_create();

var _strlen = string_length(_in), _ord = "";

// 순서 변환을 위한 테이블 (들)
var _chosunglut = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
var _jungseonglut = "ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
for (var i=1; i<=_strlen; i++)
{
    _ord = string_ord_at(_in, i);
    
    // 한글 자모 -> 초성/중성 순서로 변경
    if (_ord >= $3131 && _ord <= $314E) // 초성
    {
        var _key = string_pos(chr(_ord), _chosunglut) - 1; // 초성 테이블을 사용해 초성 순서로 변경
        if (_key >= 0)
        {
            // show_debug_message(chr(_ord) + " [" + string(_key) + "] : " + string(_val));
            _map[_key] = _val;
            // ds_map_add(_map, _key, _val);
        }
    }
    else if (_ord >= $314F && _ord <= $3163) // 중성
    {
        var _key = string_pos(chr(_ord), _jungseonglut) - 1; // 중성 테이블을 사용해 초성 순서로 변경
        if (_key >= 0)
        {
            // show_debug_message(chr(_ord) + " [" + string(_key) + "] : " + string(_val));
            _map[_key] = _val;
            // ds_map_add(_map, _key, _val);
        }
    }
}

return _map;
