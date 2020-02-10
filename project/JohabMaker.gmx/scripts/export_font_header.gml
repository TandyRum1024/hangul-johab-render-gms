/// export_font_header(dir, generateComments, trimBlanks)
/*
    Exports font in form of header files
*/

var dir = argument0, generateComments = argument1, trimBlanks = argument2;

var _FILE = file_text_open_write(dir);
if (_FILE)
{
    /// =========================
    /// Compute few variables
    /// =========================
    var _intperrow = ceil(charWid / 8); // How many uint8 is required for each row in glyph?
    var _intperrowascii = ceil(charAsciiWid / 8); // How many uint8 is required for each row in glyph?
    var _flipendian = false;
    var _totalglyphnum = 0;
    var _choseongoff = 0; // array index offset of each part of font
    var _jungseongoff = 0;
    var _jongseongoff = 0;
    var _jamooff = 0;
    var _asciioff = 0;
    var _flipbitmap = cbExportHeaderFlipBitmap;
    var _flipbitorder = cbExportHeaderFlipBitOrder;
    
    /// =========================
    /// Compute the packed bits
    /// =========================
    // First we build the font atlas
    // build_font_tex_ext(false, c_black, 1.0);
    build_font_tex_header();
    
    show_debug_message("PACKING BITMAPS..");
    
    // Then for each glyph, We crop the each glyph's area & use that to generate a binary bitmap.
    show_debug_message("PACKING KOREAN BITMAP...");
    var _glyphnum = gridWid * gridHei;
    var _glyphdata = array_create(gridWid * gridHei); // Contains each glyph's packed bits data (each glyph contains array of packed uint8 array)
    
    var _choglyphs = 0;
    var _jungglyphs = 0;
    var _jongglyphs = 0;
    var _jamoglyphs = 0;
    var _asciiglyphs = 0;
    var _jungrowoff = choRows + jungRows;
    var _jongrowoff = _jungrowoff + jongRows;
    var _jamorowoff = _jongrowoff + jamoRows;
    var _asciirowoff = _jamorowoff + asciiRows;
    
    // fetch raw bytes from surface
    var _texturewid = charWid * gridWid;
    var _texturehei = charHei * gridHei;
    var _texturebuff = buffer_create(_texturewid * _texturehei * 4, buffer_grow, 1);
    buffer_get_surface(_texturebuff, fntTex, 0, 0, 0);
    
    for (var i=0; i<_glyphnum; i++)
    {
        var _glypharr = array_create(charHei); // array of uint8 array
        
        var _data = charData[| i];
        
        // Calculate glyph area
        var _row = i div gridWid;
        var _x1 = (i % gridWid) * charWid;
        var _y1 = (_row) * charHei;
        //var _x2 = _x1 + charWid;
        var _y2 = _y1 + charHei;
        
        if (_data[@ CHAR.OCCUPIED] || !trimBlanks)
        {
            // Calculate which glyph area we're in & increment glyph counter
            // 0 : choseong, 1 : jungseong, 2 : jongseong, 3 : jamo, 4 : ascii
            // var _area = 0;
            if (_row >= _jamorowoff)
            {
                // _area = 4;
                _asciiglyphs++;
            }
            else if (_row >= _jongrowoff)
            {
                // _area = 3;
                _jamoglyphs++;
            }
            else if (_row >= _jungrowoff)
            {
                // _area = 2
                _jongglyphs++;
            }
            else if (_row >= choRows)
            {
                // _area = 1;
                _jungglyphs++;
            }
            else
            {
                _choglyphs++;
            }
        }
        
        // Sample surface & generate array of uint8 array
        for (var _y=_y1; _y<_y2; _y++)
        {
            // prepare array for one row
            var _rowarr = array_create(_intperrow);
            
            var _rowbinary = ""; // binary (sort of) representation of current row
            var _packed = 0;
            var _bitswritten = 0;
            var _intidx = 0;
            for (var _x=0; _x<charWid; _x++)
            {
                var _samplex = _x1 + _x;
                if (_flipbitmap)
                    _samplex = _x1 + (charWid - 1 - _x);
                
                var _idx = (_texturewid * _y + _samplex) * 4;
                // var _pixel = surface_getpixel(fntTex, _x, _y);
                // fetch surface data
                var _b = buffer_peek(_texturebuff, _idx, buffer_u8), _g = buffer_peek(_texturebuff, _idx + 1, buffer_u8), _r = buffer_peek(_texturebuff, _idx + 2, buffer_u8);
                var _binary = clamp(round((_b + _g + _r) / 3 / 255), 0.0, 1.0);
                
                if (_flipbitorder)
                {
                    _packed |= (_binary << (7 - _bitswritten));
                }
                else
                {
                    _packed |= (_binary << _bitswritten);
                }
                
                _rowbinary += string(_binary);
                
                _bitswritten++;
                if (_bitswritten >= 8) // written 8 bits, append array
                {
                    _rowarr[@ _intidx] = _packed;
                    
                    // increment array indices & reset variables
                    _packed = 0;
                    _bitswritten = 0;
                    _intidx++;
                }
            }
            
            // set row array to freshly-packed array
            var _row = _y - _y1;
            _glypharr[@ _row] = iui_pack(_rowbinary, _rowarr);
        }
        
        // Set glyph data array
        _glyphdata[@ i] = _glypharr;
    }
    
    _totalglyphnum = _choglyphs + _jungglyphs + _jongglyphs + _jamoglyphs + _asciiglyphs;
    _choseongoff = 0;
    _jungseongoff = _choseongoff + _choglyphs;
    _jongseongoff = _jungseongoff + _jungglyphs;
    _jamooff = _jongseongoff + _jongglyphs;
    _asciioff = _jamooff + _jamoglyphs;
    
    show_debug_message("CHOSEONG GLYPHS : " + string(_choglyphs));
    show_debug_message("JUNGSEONG GLYPHS : " + string(_jungglyphs));
    show_debug_message("JONGSEONG GLYPHS : " + string(_jongglyphs));
    show_debug_message("JAMO GLYPHS : " + string(_jamoglyphs));
    show_debug_message("ASCII GLYPHS : " + string(_asciiglyphs));
    
    // Free buffer
    buffer_delete(_texturebuff);
    
    if (FNT_DKB && FNT_ASCII)
    {
        show_debug_message("PACKING ASCII BITMAP...");
        var _glyphnumascii = 8 * 32;
        var _glyphdataascii = array_create(8 * 32); // Contains each glyph's packed bits data (each glyph contains array of packed uint8 array)
        
        // fetch raw bytes from surface
        var _texturewidascii = charAsciiWid * 32;
        var _textureheiascii = charAsciiHei * 8;
        var _texturebuff = buffer_create(_texturewidascii * _textureheiascii * 4, buffer_grow, 1);
        buffer_get_surface(_texturebuff, fntAsciiTex, 0, 0, 0);
        
        for (var i=0; i<_glyphnumascii; i++)
        {
            var _glypharr = array_create(charAsciiHei); // array of uint8 array
            
            // Calculate glyph area
            var _x1 = (i % 32) * charAsciiWid;
            var _y1 = (i div 32) * charAsciiHei;
            var _x2 = _x1 + charAsciiWid;
            var _y2 = _y1 + charAsciiHei;
            
            // Sample surface & generate array of uint8 array
            for (var _y=_y1; _y<_y2; _y++)
            {
                // prepare array for one row
                var _rowarr = array_create(_intperrowascii);
                
                var _rowbinary = ""; // binary (sort of) representation of current row
                var _packed = 0;
                var _bitswritten = 0;
                var _intidx = 0;
                for (var _x=0; _x<charAsciiWid; _x++)
                {
                    // äääääääääääääääääääääääää what the hell is this
                    var _samplex = _x1 + _x;
                    if (_flipbitmap)
                        _samplex = _x1 + (charAsciiWid - 1 - _x);
                    var _idx = (_texturewidascii * _y + _samplex) * 4;
                    
                    // fetch surface data
                    var _b = buffer_peek(_texturebuff, _idx, buffer_u8), _g = buffer_peek(_texturebuff, _idx + 1, buffer_u8), _r = buffer_peek(_texturebuff, _idx + 2, buffer_u8);
                    var _binary = clamp(round((_b + _g + _r) / 3 / 255), 0.0, 1.0);
                    
                    if (_flipbitorder)
                    {
                        _packed |= (_binary << (7 - _bitswritten));
                    }
                    else
                    {
                        _packed |= (_binary << _bitswritten);
                    }
                    
                    _rowbinary += string(_binary);
                    
                    _bitswritten++;
                    if (_bitswritten >= 8) // written 8 bits, append array
                    {
                        _rowarr[@ _intidx] = _packed;
                        
                        // increment array indices & reset variables
                        _packed = 0;
                        _bitswritten = 0;
                        _intidx++;
                    }
                }
                
                // set row array to freshly-packed array
                var _row = _y - _y1;
                _glypharr[@ _row] = iui_pack(_rowbinary, _rowarr);
            }
            
            // Set glyph data array
            _glyphdataascii[@ i] = _glypharr;
        }
        
        // Free buffer
        buffer_delete(_texturebuff);
    }
    else
    {
        _intperrowascii = _intperrow;
    }
    
    show_debug_message("WRITTING FILE BEGIN..");
    
    /// =========================
    /// Begin writting the file
    /// =========================
    // Write the comments
    if (generateComments)
    {
        file_text_write_string(_FILE, "/*"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, chr(9) + "조합형 편집기에서 자동적으로 생성된 헤더 파일입니다 :D"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, chr(9) + "This header was automatically generated by Korean johab font editor :D"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, chr(9) + "===================================="); file_text_writeln(_FILE);
        file_text_write_string(_FILE, chr(9) + "폰트 정보 / FONT INFORMATION ]"); file_text_writeln(_FILE);
        if (FNT_DKB)
        {
            file_text_write_string(_FILE, chr(9) + "벌식 : 도깨비한글 8x4x4 벌식"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "TYPE : DKB844 BEOL SET"); file_text_writeln(_FILE);
            
            // Write Hangul info. first
            if (trimBlanks)
            {
                // _totalglyphnum = _choglyphs + _jungglyphs + _jongglyphs + _jamoglyphs + _asciiglyphs;
                file_text_write_string(_FILE, chr(9) + "글자 개수 (공백인 글자 미포함) / NUMBER OF GLYPH (EXCLUDING BLANK GLYPHS) : " + string(_totalglyphnum)); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 초성 : 총 " + string(_choglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 중성 : 총 " + string(_jungglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 종성 : 총 " + string(_jongglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + CHOSEONG : TOTAL " + string(_choglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JUNGSEONG : TOTAL " + string(_jungglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JONGSEONG : TOTAL " + string(_jongglyphs) + " GLYPHS"); file_text_writeln(_FILE);
            }
            else
            {
                file_text_write_string(_FILE, chr(9) + "글자 개수 (공백인 글자 포함) / NUMBER OF GLYPH (INCLUDING BLANK GLYPHS) : " + string(gridWid * gridHei)); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 초성 : 총 " + string(gridWid * choRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(choRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 중성 : 총 " + string(gridWid * jungRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(jungRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 종성 : 총 " + string(gridWid * jongRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(jongRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + CHOSEONG : TOTAL " + string(gridWid * choRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(choRows) + "BEOL)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JUNGSEONG : TOTAL " + string(gridWid * jungRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(jungRows) + "BEOL)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JONGSEONG : TOTAL " + string(gridWid * jongRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(jongRows) + "BEOL)"); file_text_writeln(_FILE);
            }
            // English info
            file_text_write_string(_FILE, chr(9) + "ASCII : 256 (32 x 8)"); file_text_writeln(_FILE);
            
            // Offsets
            /*
                _choseongoff = 0;
                _jungseongoff = _choseongoff + _choglyphs;
                _jongseongoff = _jungseongoff + _jungglyphs;
                _jamooff = _jongseongoff + _jongglyphs;
                _asciioff = _jamooff + _jamoglyphs;
            */
            file_text_write_string(_FILE, chr(9) + "한국어 비트맵 배열 오프셋/범위 / KOREAN BITMAP ARRAY OFFSET ENTRIES : "); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 초성 / CHOSEONG : " + string(_choseongoff) + " ~ " + string(_choseongoff + _choglyphs)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 중성 / JUNGSEONG : " + string(_jungseongoff) + " ~ " + string(_jungseongoff + _jungglyphs)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 종성 / JONGSEONG : " + string(_jongseongoff) + " ~ " + string(_jongseongoff + _jongglyphs)); file_text_writeln(_FILE);
        }
        else
        {
            file_text_write_string(_FILE, chr(9) + "벌식 : 이전 버전 호환용 비표준 사제 벌식"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "TYPE : COMPATIBILITY / LEGACY BEOL SET"); file_text_writeln(_FILE);
            
            file_text_write_string(_FILE, chr(9) + "글자 개수 (공백인 글자 포함) / NUMBER OF GLYPH (INCLUDING BLANK GLYPHS) : " + string(gridWid * gridHei)); file_text_writeln(_FILE);
            // Write Hangul info. first
            if (trimBlanks)
            {
                // _totalglyphnum = _choglyphs + _jungglyphs + _jongglyphs + _jamoglyphs + _asciiglyphs;
                file_text_write_string(_FILE, chr(9) + " + 글자 개수 (공백인 글자 미포함) / NUMBER OF GLYPH (EXCLUDING BLANK GLYPHS) : " + string(_totalglyphnum)); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 초성 : 총 " + string(_choglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 중성 : 총 " + string(_jungglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 종성 : 총 " + string(_jongglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 자모 : 총 " + string(_jamoglyphs) + " 글자"); file_text_writeln(_FILE);
                if (FNT_ASCII) file_text_write_string(_FILE, chr(9) + " + ASCII : 총 " + string(_asciiglyphs) + " 글자"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + CHOSEONG : TOTAL " + string(_choglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JUNGSEONG : TOTAL " + string(_jungglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JONGSEONG : TOTAL " + string(_jongglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JAMO : TOTAL " + string(_jamoglyphs) + " GLYPHS"); file_text_writeln(_FILE);
                if (FNT_ASCII) file_text_write_string(_FILE, chr(9) + " + ASCII : TOTAL " + string(_asciiglyphs) + " GLYPHS"); file_text_writeln(_FILE);
            }
            else
            {
                file_text_write_string(_FILE, chr(9) + " + 초성 : 총 " + string(gridWid * choRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(choRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 중성 : 총 " + string(gridWid * jungRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(jungRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 종성 : 총 " + string(gridWid * jongRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(jongRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + 자모 : 총 " + string(gridWid * jamoRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(jamoRows) + "벌)"); file_text_writeln(_FILE);
                if (FNT_ASCII) file_text_write_string(_FILE, chr(9) + " + ASCII : 총 " + string(gridWid * asciiRows) + " 글자 (" + string(gridWid) + "글자 x "+ string(asciiRows) + "벌)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + CHOSEONG : TOTAL " + string(gridWid * choRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(choRows) + "BEOL)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JUNGSEONG : TOTAL " + string(gridWid * jungRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(jungRows) + "BEOL)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JONGSEONG : TOTAL " + string(gridWid * jongRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(jongRows) + "BEOL)"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, chr(9) + " + JAMO : TOTAL " + string(gridWid * jamoRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(jamoRows) + "BEOL)"); file_text_writeln(_FILE);
                if (FNT_ASCII) file_text_write_string(_FILE, chr(9) + " + ASCII : TOTAL " + string(gridWid * asciiRows) + " GLYPHS (" + string(gridWid) + "CHARS x "+ string(asciiRows) + "BEOL)"); file_text_writeln(_FILE);
            }
            // English info
            // file_text_write_string(_FILE, chr(9) + "ASCII : " + string(gridWid * asciiRows) + " (" + string(gridWid) + " x "+ string(asciiRows) + ")"); file_text_writeln(_FILE);
            
            // Offsets
            /*
                _choseongoff = 0;
                _jungseongoff = _choseongoff + _choglyphs;
                _jongseongoff = _jungseongoff + _jungglyphs;
                _jamooff = _jongseongoff + _jongglyphs;
                _asciioff = _jamooff + _jamoglyphs;
            */
            file_text_write_string(_FILE, chr(9) + "비트맵 배열 오프셋/범위 / BITMAP ARRAY OFFSET ENTRIES : "); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 초성 / CHOSEONG : " + string(_choseongoff) + " ~ " + string(_choseongoff + _choglyphs)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 중성 / JUNGSEONG : " + string(_jungseongoff) + " ~ " + string(_jungseongoff + _jungglyphs)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 종성 / JONGSEONG : " + string(_jongseongoff) + " ~ " + string(_jongseongoff + _jongglyphs)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 자모 / JAMO : " + string(_jamooff) + " ~ " + string(_jamooff + _jamoglyphs)); file_text_writeln(_FILE);
            if (FNT_ASCII) file_text_write_string(_FILE, chr(9) + " + ASCII : " + string(_asciioff) + " ~ " + string(_asciioff + _choglyphs)); file_text_writeln(_FILE);
        }
        file_text_write_string(_FILE, chr(9) + "글자 정보 / GLYPH INFORMATION ]"); file_text_writeln(_FILE);
        if (FNT_DKB)
        {
            file_text_write_string(_FILE, chr(9) + "한 줄당 uint8 개수 / uint8 PER ROW"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 한글 / KOREAN FONT : " + string(_intperrow)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + ASCII : " + string(_intperrowascii)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "글자당 비트맵 사이즈 / BITMAP SIZE OF EACH GLYPH"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 한글 / KOREAN FONT : " + string(_intperrow * 8) + "x" +  string(charHei) + "px"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + ASCII : " + string(_intperrowascii * 8) + "x" +  string(charAsciiHei) + "px"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "원본 비트맵 사이즈 / UNALIGNED BITMAP SIZE OF EACH GLYPH"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + 한글 / KOREAN FONT : " + string(charWid) + "x" +  string(charHei) + "px"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + " + ASCII : " + string(charAsciiWid) + "x" +  string(charAsciiHei) + "px"); file_text_writeln(_FILE);
        }
        else
        {
            file_text_write_string(_FILE, chr(9) + "한 줄당 uint8 개수 / uint8 PER ROW : " + string(_intperrow)); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "글자당 비트맵 사이즈 / BITMAP SIZE OF EACH GLYPH : " + string(_intperrow * 8) + "x" +  string(charHei) + "px"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, chr(9) + "원본 비트맵 사이즈 / UNALIGNED BITMAP SIZE OF EACH GLYPH : " + string(charWid) + "x" +  string(charHei) + "px"); file_text_writeln(_FILE);
        }
        var _flipstr = chr(9) + "비트맵 뒤집힘 / BITMAP HORIZONTALLY FLIPPED : ";
        if (_flipbitmap)
            _flipstr += "TRUE";
        else
            _flipstr += "FALSE";
        file_text_write_string(_FILE, _flipstr); file_text_writeln(_FILE);
        
        var _flipstr = chr(9) + "비트 순서 뒤집힘 / BIT ORDER FLIPPED : ";
        if (_flipbitorder)
            _flipstr += "TRUE";
        else
            _flipstr += "FALSE";
        file_text_write_string(_FILE, _flipstr); file_text_writeln(_FILE);
        
        file_text_write_string(_FILE, chr(9) + "===================================="); file_text_writeln(_FILE);
        file_text_write_string(_FILE, chr(9) + "생성 시간 / CREATION TIME : " + date_datetime_string(date_current_datetime())); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "*/"); file_text_writeln(_FILE); file_text_writeln(_FILE);
    }
    
    if (FNT_DKB)
    {
        // Write offsets
        file_text_write_string(_FILE, "// 비트맵 배열 오프셋/범위 / BITMAP ARRAY OFFSET ENTRIES"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_CHOSEONG_BEGIN = " + string(_choseongoff) + "; // 초성 비트맵 데이터 시작 오프셋 / CHOSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_CHOSEONG_END = " + string(_choseongoff + _choglyphs) + "; // 초성 비트맵 데이터 끝 오프셋 / CHOSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JUNGSEONG_BEGIN = " + string(_jungseongoff) + "; // 중성 비트맵 데이터 시작 오프셋 / JUNGSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JUNGSEONG_END = " + string(_jungseongoff + _jungglyphs) + "; // 중성 비트맵 데이터 끝 오프셋 / JUNGSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JONGSEONG_BEGIN = " + string(_jongseongoff) + "; // 종성 비트맵 데이터 시작 오프셋 / JONGSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JONGSEONG_END = " + string(_jongseongoff + _jongglyphs) + "; // 종성 비트맵 데이터 끝 오프셋 / JONGSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        // file_text_write_string(_FILE, "const int OFFSET_JAMO = " + string(_jamooff) + "; // 자모 비트맵 데이터 시작 오프셋 / JAMO BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        // if (FNT_ASCII) file_text_write_string(_FILE, "const int OFFSET_ASCII = " + string(_jamooff) + "; // ASCII 비트맵 데이터 시작 오프셋 / ASCII BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        
        // Now, It's time to write the packed array of uint8...
        if (FNT_ASCII)
        {
            if (generateComments)
            {
                // Write some comments
                var _estimatedbytes = _glyphnumascii * _intperrowascii * charAsciiHei;
                var _estimatedmbs = _estimatedbytes * 0.00001; // round(_estimatedbytes * 0.00001) * 0.1;
                var _decplace = 2;
                if (_estimatedmbs >= 1)
                {
                    _estimatedmbs = round(_estimatedmbs) * 0.1;
                    _decplace = 2;
                }
                else
                {
                    _estimatedmbs = _estimatedmbs * 0.1;
                    _decplace = 6;
                }
                
                
                file_text_write_string(_FILE, "//" + chr(9) + "ASCII 부분 비트맵 배열 (크기 : " + string(_glyphnumascii) + ")"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "ARRAY OF PACKED ASCII BITMAP (SIZE : " + string(_glyphnumascii) + ")"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "배열의 예상 크기 : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "EST. SIZE OF ARRAY : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "===="); file_text_writeln(_FILE);
            }
            var _varname = "BITMAP_ASCII";
            
            // Write the variable containing the array size :
            var _varsizedecl = "const long int " + string(_varname) + "_SIZE = " + string(int64(_glyphnumascii)) + ";";
            file_text_write_string(_FILE, _varsizedecl); file_text_writeln(_FILE);
            
            // Write the array declaration :
            var _vartype = "const uint8_t";
            var _vardecl = _vartype + " " + _varname + "[] = {";
            file_text_write_string(_FILE, _vardecl); file_text_writeln(_FILE);
            
            // And we write the packed uint8 array.
            for (var i=0; i<256; i++)
            {
                if (generateComments)
                {
                    var _char = chr(i);
                    if (i == 10 || i == 13) // make sure that linebreaking characters are nulled out
                        _char = "";
                    file_text_write_string(_FILE, chr(9) + "// #" + string(i) + ": '" + _char + "' | [" + string(i % 32) + ", " + string(i div 32) + "] ==================="); file_text_writeln(_FILE);
                }
                
                var _glypharr = _glyphdataascii[@ i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
            
            // After all of that, We enclose the brackets to finish writting our array of uint8.
            file_text_write_string(_FILE, "};"); file_text_writeln(_FILE); file_text_writeln(_FILE);
        }
        
        // Write Korean part
        if (generateComments)
        {
            // Write some comments
            var _estimatedbytes = _totalglyphnum * _intperrow * charHei;
            var _estimatedmbs = _estimatedbytes * 0.00001; // round(_estimatedbytes * 0.00001) * 0.1;
            var _decplace = 2;
            if (_estimatedmbs >= 1)
            {
                _estimatedmbs = round(_estimatedmbs) * 0.1;
                _decplace = 2;
            }
            else
            {
                _estimatedmbs = _estimatedmbs * 0.1;
                _decplace = 6;
            }
            
            
            file_text_write_string(_FILE, "//" + chr(9) + "한국어 부분 비트맵 배열 (크기 : " + string(_totalglyphnum) + ")"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "ARRAY OF PACKED KOREAN BITMAP (SIZE : " + string(_totalglyphnum) + ")"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "배열의 예상 크기 : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "EST. SIZE OF ARRAY : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "===="); file_text_writeln(_FILE);
        }
        var _varname = "BITMAP_KR";
        
        // Write the variable containing the array size :
        var _varsizedecl = "const long int " + string(_varname) + "_SIZE = " + string(int64(_totalglyphnum)) + ";";
        file_text_write_string(_FILE, _varsizedecl); file_text_writeln(_FILE);
        
        // Write the array declaration :
        var _vartype = "const uint8_t";
        var _vardecl = _vartype + " " + _varname + "[] = {";
        file_text_write_string(_FILE, _vardecl); file_text_writeln(_FILE);
        
        // And we write the packed uint8 array.
        // Hangul : Choseong & Jungseong & Jongseong
        var _off = 0;
        
        if (generateComments)
        {
            // Write some comments
            // var _choseongnum = choRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "초성 (" + string(_choglyphs) + " 개, 총 " + string(choRows) + " 벌) | HANGUL - CHOSEONG (" + string(_choglyphs) + " GLYPHS, TOTAL " + string(choRows) + " BEOLS / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _choseonglut = " ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"; // iui_pack("ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"); // LUT for getting the source character at given index
        for (var row=0; row<choRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "초성 " + string(row + 1) + " 벌 | " + string(row + 1) + "th CHOSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                var _data = charData[| i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                
                if (generateComments)
                {
                    var _choseongchar = string_char_at(_choseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _choseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += choRows;
        
        if (generateComments)
        {
            // Write some comments
            var _jungseongnum = jungRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "중성 (" + string(_jungglyphs) + " 개, 총 " + string(jungRows) + " 벌) | HANGUL - JUNGSEONG (" + string(_jungglyphs) + " GLYPHS, TOTAL " + string(jungRows) + " BEOL / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _jungseonglut = " ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
        for (var row=_off; row<_off+jungRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "중성 " + string(row - _off + 1) + " 벌 | " + string(row - _off + 1) + "th JUNGSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                
                if (generateComments)
                {
                    var _jungseongchar = string_char_at(_jungseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _jungseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += jungRows;
        
        if (generateComments)
        {
            // Write some comments
            var _jongseongnum = jongRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "종성 (" + string(_jongglyphs) + " 개, 총 " + string(jongRows) + " 벌) | HANGUL - JONGSEONG (" + string(_jongglyphs) + " GLYPHS, TOTAL " + string(jongRows) + " BEOL / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _jongseonglut = " ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ";
        for (var row=_off; row<_off+jongRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "종성 " + string(row - _off + 1) + " 벌 | " + string(row - _off + 1) + "th JONGSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                
                if (generateComments)
                {
                    var _jongseongchar = string_char_at(_jongseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _jongseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += jungRows;
        
        // After all of that, We enclose the brackets to finish writting our array of uint8.
        file_text_write_string(_FILE, "};"); file_text_writeln(_FILE);
    }
    else
    {
        // Write offsets
        file_text_write_string(_FILE, "// 비트맵 배열 오프셋/범위 / BITMAP ARRAY OFFSET ENTRIES"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_CHOSEONG_BEGIN = " + string(_choseongoff) + "; // 초성 비트맵 데이터 시작 오프셋 / CHOSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_CHOSEONG_END = " + string(_choseongoff + _choglyphs) + "; // 초성 비트맵 데이터 끝 오프셋 / CHOSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JUNGSEONG_BEGIN = " + string(_jungseongoff) + "; // 중성 비트맵 데이터 시작 오프셋 / JUNGSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JUNGSEONG_END = " + string(_jungseongoff + _jungglyphs) + "; // 중성 비트맵 데이터 끝 오프셋 / JUNGSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JONGSEONG_BEGIN = " + string(_jongseongoff) + "; // 종성 비트맵 데이터 시작 오프셋 / JONGSEONG BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JONGSEONG_END = " + string(_jongseongoff + _jongglyphs) + "; // 종성 비트맵 데이터 끝 오프셋 / JONGSEONG BITMAP END OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JAMO_BEGIN = " + string(_jamooff) + "; // 자모 비트맵 데이터 시작 오프셋 / JAMO BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
        file_text_write_string(_FILE, "const int OFFSET_JAMO_END = " + string(_jamooff + _jamoglyphs) + "; // 자모 비트맵 데이터 끝 오프셋 / JAMO BITMAP END OFFSET"); file_text_writeln(_FILE);
        if (FNT_ASCII)
        {
            file_text_write_string(_FILE, "const int OFFSET_ASCII_BEGIN = " + string(_asciioff) + "; // ASCII 비트맵 데이터 시작 오프셋 / ASCII BITMAP BEGIN OFFSET"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "const int OFFSET_ASCII_END = " + string(_asciioff + _asciiglyphs) + "; // ASCII 비트맵 데이터 끝 오프셋 / ASCII BITMAP END OFFSET"); file_text_writeln(_FILE);
        }
        
        // Now, It's time to write the packed array of uint8...
        // Write Korean part
        if (generateComments)
        {
            // Write some comments
            var _estimatedbytes = _totalglyphnum * _intperrow * charHei;
            var _estimatedmbs = _estimatedbytes * 0.00001; // round(_estimatedbytes * 0.00001) * 0.1;
            var _decplace = 2;
            if (_estimatedmbs >= 1)
            {
                _estimatedmbs = round(_estimatedmbs) * 0.1;
                _decplace = 2;
            }
            else
            {
                _estimatedmbs = _estimatedmbs * 0.1;
                _decplace = 6;
            }
            
            
            file_text_write_string(_FILE, "//" + chr(9) + "비트맵 배열 (크기 : " + string(_totalglyphnum) + ")"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "ARRAY OF PACKED BITMAP (SIZE : " + string(_totalglyphnum) + ")"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "배열의 예상 크기 : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "EST. SIZE OF ARRAY : " + string(_estimatedbytes) + "B / " + string_format(_estimatedmbs, 1, _decplace) + "MB"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "===="); file_text_writeln(_FILE);
        }
        var _varname = "BITMAP_FNT";
        
        // Write the variable containing the array size :
        var _varsizedecl = "const long int " + string(_varname) + "_SIZE = " + string(int64(_totalglyphnum)) + ";";
        file_text_write_string(_FILE, _varsizedecl); file_text_writeln(_FILE);
        
        // Write the array declaration :
        var _vartype = "const uint8_t";
        var _vardecl = _vartype + " " + _varname + "[] = {";
        file_text_write_string(_FILE, _vardecl); file_text_writeln(_FILE);
        
        // And we write the packed uint8 array.
        // Hangul : Choseong & Jungseong & Jongseong
        var _off = 0;
        
        if (generateComments)
        {
            // Write some comments
            var _choseongnum = _choglyphs;//choRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "초성 (" + string(_choseongnum) + " 개, 총 " + string(choRows) + " 벌) | HANGUL - CHOSEONG (" + string(_choseongnum) + " GLYPHS, TOTAL " + string(choRows) + " BEOLS / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _choseonglut = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"; // iui_pack("ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"); // LUT for getting the source character at given index
        for (var row=0; row<choRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "초성 " + string(row + 1) + " 벌 | " + string(row + 1) + "th CHOSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                
                if (generateComments)
                {
                    var _choseongchar = string_char_at(_choseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _choseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += choRows;
        
        if (generateComments)
        {
            // Write some comments
            var _jungseongnum = _jungglyphs;// jungRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "중성 (" + string(_jungseongnum) + " 개, 총 " + string(jungRows) + " 벌) | HANGUL - JUNGSEONG (" + string(_jungseongnum) + " GLYPHS, TOTAL " + string(jungRows) + " BEOL / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _jungseonglut = "ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
        for (var row=_off; row<_off+jungRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "중성 " + string(row - _off + 1) + " 벌 | " + string(row - _off + 1) + "th JUNGSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                    
                if (generateComments)
                {
                    var _jungseongchar = string_char_at(_jungseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _jungseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += jungRows;
        
        if (generateComments)
        {
            // Write some comments
            var _jongseongnum = _jongglyphs;//jongRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "종성 (" + string(_jongseongnum) + " 개, 총 " + string(jongRows) + " 벌) | HANGUL - JONGSEONG (" + string(_jongseongnum) + " GLYPHS, TOTAL " + string(jongRows) + " BEOL / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _jongseonglut = " ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ";
        for (var row=_off; row<_off+jongRows; row++)
        {
            var _rowoff = row * gridWid;
            
            if (generateComments)
            {
                file_text_write_string(_FILE, "//" + chr(9) + "종성 " + string(row - _off + 1) + " 벌 | " + string(row - _off + 1) + "th JONGSEONG BEOL"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                
                if (generateComments)
                {
                    var _jongseongchar = string_char_at(_jongseonglut, i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _jongseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += jongRows;
        
        if (generateComments)
        {
            // Write some comments
            var _jamonum = _jamoglyphs;//jamoRows * gridWid;
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "자모 (" + string(_jamonum) + " 개, 총 " + string(jamoRows) + " 벌) | HANGUL - JAMO (" + string(_jamonum) + " GLYPHS, TOTAL " + string(jamoRows) + " BEOL / ROWS)"); file_text_writeln(_FILE);
            file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
        }
        
        var _glyphidx = 0;
        var _jamolut = " ㄱㄲㄳㄴㄵㄶㄷㄸㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅃㅄㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
        for (var row=_off; row<_off+jamoRows; row++)
        {
            var _rowoff = row * gridWid;
            for (var i=0; i<gridWid; i++)
            {
                //var _glyphidx = 0;
                var _data = charData[| _rowoff + i];
                if (!_data[@ CHAR.OCCUPIED])
                    continue;
                    
                if (generateComments)
                {
                    var _jongseongchar = string_char_at(_jongseonglut, _rowoff + i + 1);
                    file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _jongseongchar + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                }
                _glyphidx++;
                
                var _glypharr = _glyphdata[@ _rowoff + i];
                
                // Iterate through each row of glyph bitmap data
                for (var j=0; j<array_length_1d(_glypharr); j++)
                {
                    var _rowdata = _glypharr[@ j];
                    
                    var _str = _rowdata[@ 0];
                    var _packedarr = _rowdata[@ 1];
                    
                    var _rowcode = chr(9); // current row of code
                    
                    // Convert each packed uint8 to hexadecimal and append to current row of code
                    for (var k=0; k<array_length_1d(_packedarr); k++)
                    {
                        _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                    }
                    
                    _rowcode += "// " + _str; // Append binary visualization as comment
                    
                    // Write the code
                    file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                }
            }
        }
        _off += jamoRows;
        
        if (FNT_ASCII)
        {
            if (generateComments)
            {
                // Write some comments
                var _asciinum = _asciiglyphs;//asciiRows * gridWid;
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "ASCII (" + string(_asciinum) + ")"); file_text_writeln(_FILE);
                file_text_write_string(_FILE, "//" + chr(9) + "==================================================="); file_text_writeln(_FILE);
            }
            
            var _glyphidx = 0;
            for (var row=_off; row<_off+asciiRows; row++)
            {
                var _rowoff = row * gridWid;
                for (var i=0; i<gridWid; i++)
                {
                    //var _glyphidx = 0;
                    var _data = charData[| _rowoff + i];
                    if (!_data[@ CHAR.OCCUPIED])
                        continue;
                    
                    if (generateComments)
                    {
                        var _asciiindex = _rowoff - _off * gridWid + i;
                        var _char = chr(_asciiindex);
                        if (_asciiindex == 10 || _asciiindex == 13) // make sure that linebreaking characters are nulled out
                            _char = "";
                        file_text_write_string(_FILE, chr(9) + "// #" + string(_glyphidx) + ": '" + _char + "' | [" + string(i) + ", " + string(row) + "] ==================="); file_text_writeln(_FILE);
                    }
                    _glyphidx++;
                    
                    var _glypharr = _glyphdata[@ _rowoff + i];
                    
                    // Iterate through each row of glyph bitmap data
                    for (var j=0; j<array_length_1d(_glypharr); j++)
                    {
                        var _rowdata = _glypharr[@ j];
                        
                        var _str = _rowdata[@ 0];
                        var _packedarr = _rowdata[@ 1];
                        
                        var _rowcode = chr(9); // current row of code
                        
                        // Convert each packed uint8 to hexadecimal and append to current row of code
                        for (var k=0; k<array_length_1d(_packedarr); k++)
                        {
                            _rowcode += "0x" + dec_to_hex(_packedarr[@ k]) + ", ";
                        }
                        
                        _rowcode += "// " + _str; // Append binary visualization as comment
                        
                        // Write the code
                        file_text_write_string(_FILE, _rowcode); file_text_writeln(_FILE);
                    }
                }
            }
        }
        
        // After all of that, We enclose the brackets to finish writting our array of uint8.
        file_text_write_string(_FILE, "};"); file_text_writeln(_FILE);
    }
    
    // Also, Revert the font texture
    build_font_tex();
    
    file_text_close(_FILE);
    return true;
}
else
{
    show_debug_message("EXPORT HEADER] ERROR HAPPENED WHILE OPENING THE FILE [" + string(dir) + "] !");
    return false;
}
