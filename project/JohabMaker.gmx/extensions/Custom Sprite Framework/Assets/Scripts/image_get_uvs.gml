///image_get_uvs(spr,subimg)
gml_pragma("forceinline");
var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
var _bck = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];

var _bck_x = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ];
var _bck_y = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ];

var _ar;
_ar[ 0 ] = _bck_x / background_get_width( _bck );
_ar[ 1 ] = _bck_y / background_get_width( _bck );
_ar[ 2 ] = (_bck_x + argument0[# __ISG_IMG.WIDTH, 0 ]) / background_get_width( _bck );
_ar[ 3 ] = (_bck_y + argument0[# __ISG_IMG.HEIGHT, 0 ]) / background_get_width( _bck );
return( _ar );
