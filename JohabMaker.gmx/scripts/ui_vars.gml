
uiActive = true;

tbFntSize = "12";
tbCellWid = "16";
tbCellHei = "16";
cbAscii = true;
cbExportGrid = false;
cbExportBG = false;

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

// Highlight
uiModal = false;
uiModalMsg = "<ESC> 키로 나가기";
uiModalState = 0;

enum UI_MODAL
{
    PREVIEW = 0
}

uiModalType = "";

// hangul input
uTestInputActive = false;
uFontInputActive = false;
uTestInput = "";
uFontInput = "";


// Style
// Button
iuiButtonShadow = true;

// Checkbox
iuiColCheckboxBorder = COL.WHITE;
iuiColCheckboxBG = COL.BASE;
iuiColCheckboxFG = COL.HIGHLIGHT2; // the checker colour

// Text box
iuiTextBoxRainbow   = true; // rainbow colour when active
iuiColTextBoxFill   = COL.WHITE;
iuiColTextBoxBorder = c_black;
iuiColTextBoxText   = COL.BASE;
iuiColTextBoxActiveFill     = COL.WHITE;
iuiColTextBoxActiveBorder   = c_black;
iuiColTextBoxActiveText     = COL.BASE;
iuiColTextBoxHotFill    = iuiColTextBoxFill;
iuiColTextBoxHotBorder  = iuiColTextBoxBorder;
iuiColTextBoxHotText    = iuiColTextBoxText;
