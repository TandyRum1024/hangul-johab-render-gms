// set vars

if (FNT_DKB) // dkb844
{
    choRows = 8;
    jungRows = 4;
    jongRows = 4;
    jamoRows = 0;
}
else // comp
{
    // calc head beol
    if (cbSpecialBody)
        choRows = 2;
    else
        choRows = 1;
    if (cbSpecialTail)
        choRows *= 2;
    
    // calc body beol
    if (cbSpecialTail)
        choRows = 2;
    else
        choRows = 1;
    
    // calc tail beol
    if (cbSpecialBody)
        jongRows = 2;
    else
        jongRows = 1;
    
    jamoRows = 2;
}

gridHei = choRows + jungRows + jongRows + jamoRows;

if (FNT_ASCII)
    gridHei += asciiRows;

// rebuild
// reset_char_surfaces();
