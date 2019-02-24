///draw_image_tiled_ext(sprite,subimg,x,y,xscale,yscale,colour,alpha)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;

var _w = argument0[# __ISG_IMG.WIDTH, 0 ];
var _h = argument0[# __ISG_IMG.HEIGHT, 0 ];
var _bck  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];
var _left = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ];
var _top  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ];
var _xo = ( argument2 mod (_w*argument4) );
var _yo = ( argument3 mod (_h*argument5) );

for( var _x = -_w * argument4; _x <= view_wview[ view_current ]; _x += _w * argument4 ){
    for( var _y = -_h * argument5; _y <= view_hview[ view_current ]; _y += _h * argument5 ){
        draw_background_part_ext(
            _bck, 
            _left,
            _top,
            _w,
            _h,
            _xo + _x,
            _yo + _y,
            argument4,
            argument5,
            argument6,
            argument7
        );
    }
}
