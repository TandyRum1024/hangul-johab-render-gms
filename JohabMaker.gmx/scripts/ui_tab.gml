///ui_tab(x, y, total_width, h, array_of_string, tab_index)
/**
    iui_tab but custom skin
**/

/// Setup
var numTabs = array_length_1d(argument4);
var tabX = argument0, tabY = argument1;
var tabW = argument2, tabH = argument3;
var tabCurrent = argument5; // selected tab index

// array
var IDs    = 0;
var labels = 0;

/// ID for each tabs
var i, _IDSTR, _IDMAP;
var stringArr;
for (i = 0; i < numTabs; i++)
{
    stringArr = iui_get_all(argument4[@ i]);
    IDs[i]    = stringArr[0];
    labels[i] = stringArr[1];
}

/// Button logic for each tabs
var isCurrent, isHot;
var tabLabel, tabLabelWid;
var tabID;
var colBackdrop, colLabel;

iui_align_center(); // center label

// backdrop
iui_rect(tabX, tabY, tabW, tabH, COL.WHITE);
iui_rect(tabX, tabY + tabH, tabW, 2, COL.BASE); // shadow

for (i = 0; i < numTabs; i++)
{
    isHot = false;
    
    tabLabel    = labels[i];
    tabLabelWid = string_width(tabLabel);
    
    tabID   = IDs[i];
    tabW = (tabLabelWid + 20);
    
    // is hover
    if (point_in_rectangle(iui_inputX, iui_inputY, tabX, tabY, (tabX + tabW), (tabY + tabH)))
    {
        iui_hotItem = tabID;
        isHot = true;
        
        // ... and is clicked
        if (iui_activeItem == -1 && iui_inputDown)
        {
            iui_activeItem = tabID;
            tabCurrent = i;
        }
    }
    isCurrent = (tabCurrent == i);
    
    
    /// Button draw
    // var colIdx  = (i % iuiColTabNum);
    // colBackdrop = iuiColTab[colIdx];
    colBackdrop = COL.WHITE;
    colLabel    = COL.BASE;
    
    if (isCurrent)
    {
        colBackdrop = COL.BLUE;
        colLabel    = COL.WHITE;
    }
    else if (isHot) // Hovering
    {
        colBackdrop = COL.GRAY;
        colLabel    = COL.WHITE;
    }
    
    // draw
    iui_rect(tabX, tabY, tabW, tabH, colBackdrop);
    iui_rect(tabX, tabY + tabH, tabW, 2, COL.BASE);
    iui_label(tabX + (tabW >> 1), tabY + (tabH >> 1), tabLabel, colLabel);
    
    // for next tab
    tabX += tabW;
}

iui_align_pop(); // revert align

return tabCurrent;
