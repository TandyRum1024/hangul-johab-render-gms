///draw_image_tiled_area_ext(image,subimg,x1,y1,x2,y2,xscale,yscale,colour,alpha)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;

var _w = argument0[# __ISG_IMG.WIDTH, 0 ];
var _h = argument0[# __ISG_IMG.HEIGHT, 0 ];

var _tw = _w * argument6;
var _th = _h * argument7;

var _bck  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];
var _left = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ];
var _top  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ];

var _x1 = argument2;
var _x2 = argument4;
var _y1 = argument3;
var _y2 = argument5;
var _xadd = 1 - 2 * ( argument4 < argument2 );
var _yadd = 1 - 2 * ( argument5 < argument3 );

var _x = _x1 - _tw * ( _xadd == -1 );
var _y = _y1 - _th * ( _yadd == -1 );
repeat( floor( abs( _x2 - _x1 ) / _tw ) ){
    repeat( floor( abs( _y2 - _y1 ) / _th ) ){
        draw_background_part_ext(
            _bck, 
            _left,
            _top,
            _w,
            _h,
            _x,
            _y,
            argument6,
            argument7,
            argument8,
            argument9
        );
        _y += _th * _yadd;
    }
    _x += _tw * _xadd;
    _y = _y1 - _th * ( _yadd == -1 );
}
var _y_side = _y;

// HORISONTAL
var _x = _x1 - _tw * ( _xadd == -1 );
_y = _y1 + floor( ( _y2 - _y1 ) / _th ) * _th;

if( _yadd == -1 ){
    var _part_top = _top + abs( _y2 - _y ) / argument7;
    var _part_h = abs( ( _y2 - _th ) - _y ) / argument7;
    var _part_y = _y + abs( _y2 - _y );
} else {
    var _part_top = _top;
    var _part_h = abs( _y2 - _y ) / argument7;
    var _part_y = _y;
}
repeat( floor( abs( _x2 - _x1 ) / _tw ) ){
    draw_background_part_ext(
        _bck, 
        _left,
        _part_top,
        _w,
        _part_h,
        _x,
        _part_y,
        argument6, 
        argument7,
        argument8,
        argument9
    );
    _x += _tw * _xadd;
}

// VERTICAL
var _y = _y1 - _th * ( _yadd == -1 );
_x = _x1 + floor( ( _x2 - _x1 ) / _tw ) * _tw;

if( _xadd == -1 ){
    var _part_left = _left + abs( _x2 - _x ) / argument6;
    var _part_w = abs( ( _x2 - _tw ) - _x ) / argument6;
    var _part_x = _x + abs( _x2 - _x );
} else {
    var _part_left = _left;
    var _part_w = abs( _x2 - _x ) / argument6;
    var _part_x = _x;
}
repeat( floor( abs( _y2 - _y1 ) / _th ) ){
    draw_background_part_ext(
        _bck, 
        _part_left,
        _top,
        _part_w,
        _h,
        _part_x,
        _y,
        argument6, 
        argument7,
        argument8,
        argument9
    );
    _y += _th * _yadd;
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
    argument6, 
    argument7,
    argument8,
    argument9
);

