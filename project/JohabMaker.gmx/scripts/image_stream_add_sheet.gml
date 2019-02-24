#define image_stream_add_sheet
///image_stream_add_sheet(group,identifier,fname,hor_count,ver_count,xorig,yorig)
var _l = global.m_ex_image[? argument0 ];

// Error checking
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), true );
    return false; 
}

var _m = _l[| 2 ];
var _p_sprite = _m[? "sprite" ];

var _bck = background_add( argument2, _m[? "removeback" ], false );
var _spr_w = background_get_width( _bck ) / argument3;
var _spr_h = background_get_height( _bck ) / argument4;
var _priority = floor( ( _spr_w + _spr_h ) * 0.5 );

var _load_data = ds_list_create();
_load_data[| __IS_STREAM_IMAGE.ID ] = string( argument1 );
_load_data[| __IS_STREAM_IMAGE.TYPE ] = __IS.TYPE_SHEET;
_load_data[| __IS_STREAM_IMAGE.FPATH ] = argument2;
_load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] = argument3 * argument4;
_load_data[| __IS_STREAM_IMAGE.SUBIMG_ROWS ] = argument4;
_load_data[| __IS_STREAM_IMAGE.XORIG ] = argument5;
_load_data[| __IS_STREAM_IMAGE.YORIG ] = argument6;

if( _priority <= 1 and !file_exists( argument2 ) ){
    _load_data[| __IS_STREAM_IMAGE.SPRITES ] = _bck;
    
    var _l_loading = _m[? "loading" ];
    ds_list_add( _l_loading, _load_data );
    _m[? "finished" ] = false;
} else {
    if( _spr_w <= _m[? "w" ] + _m[? "sep" ] && _spr_h <= _m[? "h" ] + _m[? "sep" ] ){
        // The image came from a file, finish everything
        _load_data[| __IS_STREAM_IMAGE.SPRITES ] = _bck;
        __isa_sheet_bake( _load_data, _m[? "clamp" ] );
        _priority = floor( ( _load_data[| __IS_STREAM_IMAGE.WIDTH ] + _load_data[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
    } else {
        background_delete( _bck );
        ds_list_destroy( _load_data );
        show_error( "Image is larger than texturepage! " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), false );
        return false;
    }

}

ds_priority_add( _p_sprite, _load_data, _priority );
return true;

#define __isa_sheet_bake
///__isa_sheet_bake(load_data, clamp)

var _load_data = argument0;

var _bck = _load_data[| __IS_STREAM_IMAGE.SPRITES ];


var _subimg_ver = _load_data[| __IS_STREAM_IMAGE.SUBIMG_ROWS ];
var _subimg_hor = _load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] / _subimg_ver;

var _spr_w_raw = background_get_width( _bck ) / _subimg_hor;
var _spr_h_raw = background_get_height( _bck ) / _subimg_ver;
var _spr_w = floor( _spr_w_raw );
var _spr_h = floor( _spr_h_raw );
_load_data[| __IS_STREAM_IMAGE.XORIG ] *= _spr_w;
_load_data[| __IS_STREAM_IMAGE.YORIG ] *= _spr_h;


// Make sure that the user didn't enter the wrong subimage count
if( _spr_w_raw != _spr_w ){
    __is_log( "IMAGE STREAM WARNING: Image '" + string( _load_data[| __IS_STREAM_IMAGE.ID ] ) + 
        "' may have wrong amount of subimages per row. Width " + string( background_get_width( _bck ) ) + " / " + string( _subimg_hor ) + " = " + string( _spr_w_raw ) );
}
if( _spr_h_raw != _spr_h ){
    __is_log( "IMAGE STREAM WARNING: Image '" + string( _load_data[| __IS_STREAM_IMAGE.ID ] ) + 
        "' may have wrong amount of subimages per column. Height " + string( background_get_height( _bck ) ) + " / " + string( _subimg_ver ) + " = " + string( _spr_h_raw ) );
}
// Bake into sprite

var _surf = surface_create( background_get_width( _bck ), background_get_height( _bck ) );
surface_set_target( _surf );
draw_clear_alpha( c_black, 0 );
draw_background( _bck, 0, 0 );
var _spr = sprite_create_from_surface( _surf, 
    0, 0, 
    _spr_w, _spr_h, 
    false, false, 
    0, 0 );
var i = 1; // i = x + width * y
repeat( _subimg_hor * _subimg_ver - 1 ){
    var _x = i mod _subimg_hor;
    var _y = i div _subimg_hor;
    
    sprite_add_from_surface( _spr, _surf, _x * _spr_w, _y * _spr_h, _spr_w, _spr_h, false, false );
    i++;
}
surface_reset_target();
surface_free( _surf);
background_delete( _bck );

if( argument1 == false ){
    _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = 0;
    _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = 0;
    _load_data[| __IS_STREAM_IMAGE.WIDTH ] = _spr_w;
    _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = _spr_h;
} else {
    _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = sprite_get_bbox_left( _spr );
    _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = sprite_get_bbox_top( _spr );
    _load_data[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_bbox_right( _spr ) - sprite_get_bbox_left( _spr ) + 1;
    _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_bbox_bottom( _spr ) - sprite_get_bbox_top( _spr ) + 1;
}

_load_data[| __IS_STREAM_IMAGE.SPRITES ] = _spr;