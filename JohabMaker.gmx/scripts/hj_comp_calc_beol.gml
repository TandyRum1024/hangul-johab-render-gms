///hj_comp_calc_beol()
/*
    !![이전 버전 호환용]!!
    초성, 중성, 종성의 벌 수를 계산합니다.
    ======================
*/

// 초성
if (global.hjCompSpecialMiddle) // 중성에 따른 초성 & 종성 벌 변경
    global.hjCompBeolFirst = 2;
else
    global.hjCompBeolFirst = 1;

if (global.hjCompSpecialLast) // 종성 여부에 따른 초성 & 중성 벌 변경
    global.hjCompBeolFirst *= 2;
    
// 중성
if (global.hjCompSpecialLast) // 종성 여부에 따른 초성 & 중성 벌 변경
    global.hjCompBeolMiddle = 2;
else
    global.hjCompBeolMiddle = 1;

// 종성
if (global.hjCompSpecialMiddle) // 중성에 따른 초성 & 종성 벌 변경
    global.hjCompBeolLast = 2;
else
    global.hjCompBeolLast = 1;

// show_debug_message("BEOL : ");
// show_debug_message(string(global.hjCompBeolFirst));
// show_debug_message(string(global.hjCompBeolMiddle));
// show_debug_message(string(global.hjCompBeolLast));
