// set vars

if (FNT_DKB) // dkb844
{
    choRows = 8;
    jungRows = 4;
    jongRows = 4;
    jamoRows = 0;
    asciiRows = 0;
}
else // comp
{
    // calc head beol
    if (FNT_MIDDLE)
        choRows = 2;
    else
        choRows = 1;
    if (FNT_LAST)
        choRows *= 2;
    
    // calc body beol
    if (FNT_LAST)
        jungRows = 2;
    else
        jungRows = 1;
    
    // calc tail beol
    if (FNT_MIDDLE)
        jongRows = 2;
    else
        jongRows = 1;
    
    jamoRows = 2;
    asciiRows = 5;
}

gridHei = choRows + jungRows + jongRows + jamoRows;

if (FNT_ASCII)
    gridHei += asciiRows;

// rebuild
// reset_char_surfaces();
