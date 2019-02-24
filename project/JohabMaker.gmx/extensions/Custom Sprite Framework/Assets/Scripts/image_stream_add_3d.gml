///image_stream_add_3d(group,identifier,fname,subimg,xorig,yorig)
var _l = global.m_ex_image[? argument0 ];

// Error checking
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), true );
    return false; 
}

var _m = _l[| 2 ];
var _p_sprite_3d = _m[? "sprite_3d" ];

var _spr = sprite_add( argument2, argument3, _m[? "removeback" ], false, 0, 0 );
var _priority = floor( ( sprite_get_width( _spr ) + sprite_get_height( _spr ) ) / 2 );
var _load_data = ds_list_create();

ds_list_add( _load_data, _spr, string( argument1 ), argument2 );
_load_data[| __IS_STREAM_IMAGE.ID ] = string( argument1 );
_load_data[| __IS_STREAM_IMAGE.TYPE ] = __IS.TYPE_3D;
_load_data[| __IS_STREAM_IMAGE.FPATH ] = argument2;
_load_data[| __IS_STREAM_IMAGE.SPRITES ] = _spr;
_load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] = argument3;
_load_data[| __IS_STREAM_IMAGE.XORIG ] = argument4;
_load_data[| __IS_STREAM_IMAGE.YORIG ] = argument5;

if( _priority <= 1 and !file_exists( argument2 ) ){
    var _l_loading = _m[? "loading" ];
    ds_list_add( _l_loading, _load_data );
    _m[? "finished" ] = false;
} else {
    _load_data[| __IS_STREAM_IMAGE.XORIG ] *= sprite_get_width( _spr );
    _load_data[| __IS_STREAM_IMAGE.YORIG ] *= sprite_get_height( _spr );
}

ds_priority_add( _p_sprite_3d, _load_data, _priority );
return true;
