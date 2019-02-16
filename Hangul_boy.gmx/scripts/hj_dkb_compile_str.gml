///hj_dkb_compile_str(string)
/*
    스트링을 받아서 각 글자마다 인덱스와 여러 정보를 배열에 저장한 결과를 반환합니다.
    자주 그려지는 글자에 적용하면 더 나을지도?
    
    잘 응용하면 글자 색 바꾸기, 폰트 바꾸기같은 효과를 주는 것도 가능할겁니다
*/

var _strarray = -1, _strlen = string_length(argument0);
var _char, _escape = false, _ord, _kr, _idx = 0;
var _head, _body, _tail, _headidx, _bodyidx, _tailidx;
var _arr = -1;
var _type = -1;
for (var i=0; i<_strlen; i++)
{
    _arr = -1;
    _char = string_char_at(argument0, i + 1);
    _ord = ord(_char);
    
    if (_char == "#" && !_escape) // 다음줄
    {
        _arr[0] = 0; // 타입 [다음줄, ASCII, 조합, 자모]
        _arr[1] = i; // 원본 스트링에서의 인덱스
        _arr[2] = _ord; // 스프라이트 인덱스(들)
        _arr[3] = 0;
        _arr[4] = 0;
    }
    else if (_ord == $20) // 스페이스바 / 화이트스페이스
    {
        _arr[0] = 1;
        _arr[1] = i;
        _arr[2] = 0;
        _arr[3] = 0;
        _arr[4] = 0;
    }
    else if (_ord <= $FF) // ASCII
    {
        if (_char == "\") // 백슬래시 + 개행문자 예외
        {
            _escape = true;
            continue;
        }
        else
        {
            _escape = false;
        }
        
        _arr[0] = 2;
        _arr[1] = i;
        _arr[2] = _ord;
        _arr[3] = 0;
        _arr[4] = 0;
    }
    else if (_ord >= $AC00 && _ord <= $D7AF) // 조합형 한글
    {
        _kr = _ord - $AC00;
        
        // 초/중/종성 구하기 & 벌 (오프셋) 구하기
        _head = (_kr div 588); // 초성
        _body = ((_kr % 588) div 28); // 중성
        _tail = (_kr % 28); // 종성 (받침)
        
        _headidx = _head + 1;
        _bodyidx = _body + 1;
        _tailidx = _tail + global.hjLUTTail[@ _body];
        
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
        
        _arr[0] = 3;
        _arr[1] = i;
        _arr[2] = _headidx;
        _arr[3] = _bodyidx;
        _arr[4] = _tailidx;
    }
    else if (_ord >= $3131 && _ord <= $3163) // 한글 자모
    {
        _kr = _ord - $3131;
        
        // show_debug_message("JAMO : " + _char + "/" + string(global.hjLUTJamo[@ _kr]));
        
        _arr[0] = 4;
        _arr[1] = i;
        _arr[2] = global.hjLUTJamo[@ _kr];
        _arr[3] = 0;
        _arr[4] = 0;
    }
    else // ????
    {
        _arr[0] = -1;
        _arr[2] = i;
        _arr[3] = 0;
        _arr[4] = 0;
        _arr[5] = 0;
    }
    
    _strarray[_idx++] = _arr;
}

return _strarray;
