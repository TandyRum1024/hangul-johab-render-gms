///draw_image_tiled_area(image,subimg,x1,y1,x2,y2)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;

var _w = argument0[# __ISG_IMG.WIDTH, 0 ];
var _h = argument0[# __ISG_IMG.HEIGHT, 0 ];
var _bck  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];
var _left = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ];
var _top  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ];

var _x1 = argument2;
var _x2 = argument4;
var _y1 = argument3;
var _y2 = argument5;
var _xadd = 1 - 2 * ( argument4 < argument2 );
var _yadd = 1 - 2 * ( argument5 < argument3 );

var _x = _x1 - _w * ( _xadd == -1 );
var _y = _y1 - _h * ( _yadd == -1 );
repeat( floor( abs( _x2 - _x1 ) / _w ) ){
    repeat( floor( abs( _y2 - _y1 ) / _h ) ){
        draw_background_part(
            _bck, 
            _left,
            _top,
            _w,
            _h,
            _x,
            _y 
        );
        _y += _h * _yadd;
    }
    _x += _w * _xadd;
    _y = _y1 - _h * ( _yadd == -1 );
}
var _y_side = _y;

// HORISONTAL
var _x = _x1 - _w * ( _xadd == -1 );
_y = _y1 + floor( ( _y2 - _y1 ) / _h ) * _h;

if( _yadd == -1 ){
    var _part_top = _top + abs( _y2 - _y );
    var _part_h = abs( ( _y2 - _h ) - _y );
    var _part_y = _y + abs( _y2 - _y );
} else {
    var _part_top = _top;
    var _part_h = abs( _y2 - _y );
    var _part_y = _y;
}
repeat( floor( abs( _x2 - _x1 ) / _w ) ){
    draw_background_part_ext(
        _bck, 
        _left,
        _part_top,
        _w,
        _part_h,
        _x,
        _part_y,
        1, 
        1,
        c_white,
        1
    );
    _x += _w * _xadd;
}

// VERTICAL
var _y = _y1 - _h * ( _yadd == -1 );
_x = _x1 + floor( ( _x2 - _x1 ) / _w ) * _w;

if( _xadd == -1 ){
    var _part_left = _left + abs( _x2 - _x );
    var _part_w = abs( ( _x2 - _w ) - _x );
    var _part_x = _x + abs( _x2 - _x );
} else {
    var _part_left = _left;
    var _part_w = abs( _x2 - _x );
    var _part_x = _x;
}
repeat( floor( abs( _y2 - _y1 ) / _h ) ){
    draw_background_part_ext(
        _bck, 
        _part_left,
        _top,
        _part_w,
        _h,
        _part_x,
        _y,
        1, 
        1,
        c_white,
        1
    );
    _y += _h * _yadd;
}

// EDGE TILE
draw_background_part_ext(
    _bck, 
    _part_left,
    _part_top,
    _part_w,
    _part_h,
    _part_x,
    _part_y,
    1, 
    1,
    c_white,
    1
);

