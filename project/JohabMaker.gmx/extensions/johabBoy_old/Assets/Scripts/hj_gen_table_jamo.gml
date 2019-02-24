///hj_add_table_jamo()
/*
    (자모 렌더링용) 자모와 대응하는 초성/중성/종성의 스프라이트 인덱스 테이블을 배열에 넣고 반환합니다.
*/

var _table = -1;
var _headtable = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
var _bodytable = "ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
var _tailtable = "ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅃㅅㅆㅇㅈㅊㅋㅌㅍㅎ";

var _sz = $3163 - $3131;
for (var i=0; i<=_sz; i++)
{
    var _jamo = chr(i + $3131); // 현재 체크할려는 자모
    
    var _pos = string_pos(_jamo, _headtable);
    if (_pos != 0) // 현재 자모가 초성에 속함
    {
        _table[i] = global.hjGlyphJamoHead * 28 + _pos; //ds_map_add(argument0, _jamo, global.hjGlyphJamoHead + _pos - 1);
        continue;
    }
        
    _pos = string_pos(_jamo, _bodytable);
    if (_pos != 0) // 현재 자모가 중성에 속함
    {
        _table[i] = global.hjGlyphJamoBody * 28 + _pos; //ds_map_add(argument0, _jamo, global.hjGlyphJamoBody + _pos - 1);
        continue;
    }
        
    _pos = string_pos(_jamo, _tailtable);
    if (_pos != 0) // 현재 자모가 종성에 속함
    {
        _table[i] = global.hjGlyphJamoTail * 28 + _pos; //ds_map_add(argument0, _jamo, global.hjGlyphJamoTail + _pos - 1);
        continue;
    }
}

return _table;
