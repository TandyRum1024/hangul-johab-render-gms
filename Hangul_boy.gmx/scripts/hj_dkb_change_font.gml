///hj_dkb_change_font(hanspr, asciispr, hanwidth, hanheight, asciiwidth, asciiheight)
/*
    [도꺠비 8x8x4벌식]
    폰트 스프라이트를 바꿉니다.
    만약 16x16 & 8x16 폰트 말고 다른 크기의 폰트를 쓰시고자 한다면
    dkb_change_font_ext() 로 한글, ASCII 폰트의 크기도 조정 할 수 있습니다.
    =====================================
    hanspr : 한글 폰트 스프라이트
    asciispr : ASCII 폰트 스프라이트
*/

// 폰트
global.hjSpriteHan = argument0;
global.hjSpriteAscii = argument1;
