///hj_dkb_change_font_ext(hanspr, asciispr, hanwidth, hanheight, asciiwidth, asciiheight)
/*
    [도꺠비 8x8x4벌식]
    폰트와 크기 설정을 바꿉니다.
    이 스크립트로 폰트의 크기를 조정하면 앞으로 그려지는 모든 글자 (= 이전 버전식으로 그리는것도)가
    영향을 받습니다.
    이 스크립트로 폰트를 변경하시고 다시 이전 버전식으로 그리시려면 hj_compat_change_font()로
    알맞은 설정을 해주는걸 잊지 마세요!!
    =====================================
    hanspr : 한글 폰트 스프라이트
    asciispr : ASCII 폰트 스프라이트
    hanwidth, hanheight : 한글 폰트 너비/높이
    asciiwidth, asciiheight : ASCII 폰트 너비/높이
*/

// 폰트
global.hjSpriteHan = argument0;
global.hjSpriteAscii = argument1;

// 크기
global.hjCharWidHan = argument2;
global.hjCharHeiHan = argument3;
global.hjCharWidAscii = argument4;
global.hjCharHeiAscii = argument5;

// 캐시 삭제
ds_map_clear(global.hjCacheMisc);
