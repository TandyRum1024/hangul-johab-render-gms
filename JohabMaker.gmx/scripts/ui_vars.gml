
tbFntSize = "12";
tbCellWid = "16";
tbCellHei = "16";
cbAscii = true;

// colorem boyy
enum COL
{
    BASE = $151414,
    WHITE = $ecfbfc,
    GRAY = $4f493f,
    TEAL = c_teal,
    BLUE = $88262d,
    HIGHLIGHT = $ab960b, //$3ba6fd
    HIGHLIGHT2 = $3ba6fd
}
uBGCol = COL.BASE;
uTextCol = COL.WHITE;

// top bar
uToolbarHei = 170;

// tool tab
uCurrentTab = 0;
uTitleMsg = "강아지는 멍멍";

// Tooltip
uiTooltipMsg = "DANK LOL";
uiTooltipShow = false;

// Cursor
/*
    0 - Nrml
    1 - Add
    2 - Del
    3 - Rect
*/
uiCursor = 0;
uiCursorInCrop = false;

// Style
// Button
iuiButtonShadow = true;

// Checkbox
iuiColCheckboxBorder = COL.WHITE;
iuiColCheckboxBG = COL.BASE;
iuiColCheckboxFG = COL.HIGHLIGHT2; // the checker colour

// Text box
iuiTextBoxRainbow   = true; // rainbow colour when active
iuiColTextBoxFill   = COL.GRAY;
iuiColTextBoxBorder = COL.GRAY;
iuiColTextBoxText   = COL.WHITE;
iuiColTextBoxActiveFill     = COL.WHITE;
iuiColTextBoxActiveBorder   = COL.WHITE;
iuiColTextBoxActiveText     = COL.BASE;
iuiColTextBoxHotFill    = iuiColTextBoxFill;
iuiColTextBoxHotBorder  = iuiColTextBoxBorder;
iuiColTextBoxHotText    = iuiColTextBoxText;
