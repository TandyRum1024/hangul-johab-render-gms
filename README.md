<h1 align=center>한글 조합형 출력 (그리고 편집기)</h1>
<h3 align=center>

조합형으로 렌더링해서 이론적으로 ***'똚밝걁햙'*** 같은 이상한 글자마저도 출력 가능합니다.

</h3>
<span align=center>

![cracktro](pics/CRACKTRO.gif)

</span>

왜 만들었는지 궁금합니다?? <i style="font-size: 0.5em">(aka 한글 출력 관련 땡깡)</i>
===
게임메이커와 여느 엔진 특성상, 글자를 그릴 때 따로 텍스쳐에 하나씩 구워둔 글자들을 떼서 뿌리는 방식으로
글자를 출력하는데요,

그런데 말입니다.. 영어같은 경우는 글자가 26개 뿐이니 텍스쳐 걱정을 하지 않아도 되는데,<br>
한국어는 적어도 ***2350*** 자가 필요합니다. 거진 9배가 넘는 양이죠. 게다가 이 2350자는 많이 사용되는 글자들중 엄선된 글자만 포함 된 것입니다.<br>
'뭨' '뵑' 같은 생소한 글자를 포함하면 현대 한글 11172자를 모두 텍스쳐에 구겨넣어야 할 판입니다 :<<br>

하지만 다행이도, 우리 한글은 레고마냥 초성과 중성 그리고 종성을 합쳐서 만들수 있기때문에 (EX : ㄱ + ㅏ + ㄺ => '갉')<br>
이를 이용하면 최대 448자만 가지고도 위에서 말한 글자까지 출력할 수 있게됩니다.

마침 인터넷에 관련 글과 자료가 풍부해서, 한번 만들어보자는 심정으로 제작에 몰두하게 되었습니다.<br>
(+ 그리고 저는 고통을 좋아하는 변태 괴발자라는 점도 있습니다 :>)<br>
(++ 그리고 게임에 **괴기한 글자**를 사용하는게 낙이여서도 만든것 같네요)

(어찌저찌 만들어둔) 기능 & 한계점
===
- 도깨비한글 8x4x4벌식 형태의 스프라이트 폰트를 사용해 한글 출력
- 글자를 회전시키거나 크기를 줄이거나 늘이는 등 변형 가능합니다
- 글자 줄 당 너비에 제한을 둘 수 있읍니다

하지만 중요한건 퍼포먼스가 썩 좋지 않습니다;; 여러 괴상한 짓거리를 동원해 봤지만,<br>
한글 1글자당 스프라이트를 3개나 그리는탓인지 FPS가 제가 원하는만큼 나오지 않네요.

알아두어야 할 것
===

이 예제는 2가지 방식으로 한글을 출력 할 수 있읍니다:
- 사제 벌식 (비교적 적은 이미지 사용, 부자연스러운 글자, 자모 전용 이미지 사용)
- 도깨비한글 8x4x4벌식 (비교적 자연스러운 글자, 많은 이미지 사용, 자모가 부자연스러움)

*(좌측 : 사제 벌식/이전 버전 벌식, 우측 : 도깨비한글 벌식)*

![비교 GIF](pics/HANGUL_TF3.gif)

그리고 저번에 공개했던 버전과는 달리 또한 폰트 스프라이트의 서브이미지를 사용해서 출력합니다.
통채로 되있는 스프라이트를 사용하시려면 `hj_draw_sheet()` 와 `hj_draw_comp_sheet()` 를 사용해 주세요!

**(1번째 : 서브이미지로 나뉜 폰트의 예, 2번째 : 통짜 폰트의 예)**
![곱게 잘려있는 폰트](pics/FONT_EXTRA1.png "저흰 이걸 원합니다!")
![통짜 폰트](pics/FONT_EXTRA2.png "이런건 hj_draw_sheet()을 사용해 주세요")

다음은 함수에 관한 사용법입니다.<br>
**(컨트롤 오브젝트에서 `hj_init()` 으로 시스템을 초기화 시키신 다음 사용하셔야 합니다!)**

## **함수 길잡이 : 도깨비한글 벌식 / 기본 벌식 출력 관련**
---
| 함수 이름 | 파라미터 (순서대로) | 비고 |
|-----|-----|-----|
|`hj_draw(x, y, str, colour, alpha)`|*X, Y, 출력할 문자열, 색깔, 알파(투명도)*|한글 문자열을 컴파일한 뒤 출력합니다.|
|`hj_draw_ext(x, y, str, sep, width, colour, alpha)`|*X, Y, 문자열, 줄 간격, 너비 제한, 색깔, 알파*|줄 간격 & 줄당 너비에 제한을 둘 수 있읍니다.<br>(줄 간격에 `-1`을 넘기면 알아서 계산합니다.)|
|`hj_draw_transformed(x, y, str, xscale, yscale, angle, colour, alpha)`|*X, Y, 문자열, X 크기, Y 크기, 각도, 색깔, 알파*|문자열을 각도와 크기를 변형시켜 출력합니다.|
|`hj_draw_raw(x, y, str, colour, alpha)`|*X, Y, 문자열, 색깔, 알파*|문자열을 컴파일 시키지 않고 그대로 출력합니다.<br>(매우 느려질 수 있습니다..)|
|`hj_draw_sheet(hansprite, asciisprite, x, y, str, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, 색깔, 알파*|서브이미지 없는 통채로 된 스프라이트를 받아서 출력합니다.<br>(ASCII 폰트에 `-1`을 넘기면 대신 한글 스프라이트에서 ASCII 문자 구간을 사용합니다.)|

```
hj_draw(x, y, str, colour, alpha)
```
![예제](pics/DRAW.png)
![코드](pics/DRAW_CODE.png)

```
hj_draw_ext(x, y, str, sep, width, colour, alpha)
```
![예제](pics/DRAWEXT.gif)
![코드](pics/DRAWEXT_CODE.png)

```
hj_draw_transformed(x, y, str, xscale, yscale, angle, colour, alpha)
```
![예제](pics/DRAWTRANSFORM.gif)
![코드](pics/DRAWTRANSFORM_CODE.png)

## **함수 길잡이 : 사제 벌식 / 이전 버전 벌식 출력 관련**
---

**(사제 벌식은 모든 출력 함수가 한글 폰트와 ASCII 폰트를 받습니다.)**

| 함수 이름 | 파라미터 (순서대로) | 비고 |
|-----|-----|-----|
|`hj_draw_comp(kor_font_sprite, ascii_font_sprite, x, y, str, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, 색깔, 알파*|한글 문자열을 컴파일한 뒤 출력합니다.|
|`hj_draw_comp_ext(kor_font_sprite, ascii_font_sprite, x, y, str, sep, width, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, 줄 간격, 너비 제한, 색깔, 알파*|줄 간격 & 줄당 너비에 제한을 둘 수 있습니다.<br>(줄 간격에 `-1`을 넘기면 알아서 계산합니다.)|
|`hj_draw_comp_transformed(kor_font_sprite, ascii_font_sprite, x, y, str, xscale, yscale, angle, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, X 크기, Y 크기, 각도, 색깔, 알파*|문자열을 각도와 크기를 변형시켜 출력합니다.|
|`hj_draw_comp_raw(kor_font_sprite, ascii_font_sprite, x, y, str, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, 색깔, 알파*|문자열을 컴파일 시키지 않고 그대로 출력합니다.<br>(매우 느려질 수 있습니다..)|
|`hj_draw_comp_sheet(kor_font_sprite, ascii_font_sprite, x, y, str, colour, alpha)`|*한글 폰트, ASCII 폰트, X, Y, 문자열, 색깔, 알파*|서브이미지 없는 통채로 된 스프라이트를 받아서 출력합니다.<br>(ASCII 폰트에 `-1`을 넘기면 대신 한글 스프라이트에서 ASCII 문자 구간을 사용합니다.)|

```
hj_draw_comp_*()
```

![예제](pics/DRAW_COMP.gif)
![코드](pics/DRAW_COMP_CODE.png)

## **함수 길잡이 : 기타**
---

| 함수 이름 | 파라미터 (순서대로) | 비고 |
|-----|-----|-----|
|`hj_string_width(str)`|*문자열*|주어진 문자열의 너비를 반환합니다.|
|`hj_string_width_line(str)`|*문자열*|주어진 문자열의 ***첫 줄***  의 너비를 반환합니다.|
|`hj_string_height(str)`|*문자열*|주어진 문자열의 높이를 반환합니다.|
|`hj_set_align(halign, valign)`|*가로 정렬, 세로 정렬*|정렬을 설정합니다. 기존의 정렬 설정과 동일합니다.|
|`hj_change_font(hanspr, asciispr)`|*한글 스프라이트, ASCII 스프라이트*|문자열을 출력할 떄 쓰이는 스프라이트를 설정합니다.|
|`hj_change_font_ext(hanspr, asciispr, hanwidth, hanheight, asciiwidth, asciiheight)`|*한글 스프라이트, ASCII 스프라이트, 한글 너비, 한글 높이, ASCIII 너비, ASCII 높이*|문자열을 출력할 떄 쓰이는 스프라이트를 설정하고, 글자의 크기도 설정합니다.|

```
hj_string_width(str)
hj_string_height(str)
```

![예제](pics/SIZE.png)
![코드](pics/SIZE_CODE.png)

```
hj_set_align(halign, valign)
```

![예제](pics/ALIGN.png)
![코드](pics/ALIGN_CODE.png)

```
hj_change_font(hanspr, asciispr)
hj_change_font_ext(hanspr, asciispr, hanwidth, hanheight, asciiwidth, asciiheight)
```

![예제](pics/FONT.png)
![코드](pics/FONT_CODE.png)