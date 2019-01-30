///image_stream_add(group, identifier, fname, subimg, xorig, yorig)
var _l = global.m_ex_image[? argument0 ];

// Error checking
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), true );
    return false; 
}

var _m = _l[| 2 ];
var _p_sprite = _m[? "sprite" ];
var _spr  = sprite_add( argument2, argument3, _m[? "removeback" ], false, 0, 0 );
var _priority = floor( ( sprite_get_width( _spr ) + sprite_get_height( _spr ) ) * 0.5 );
var _load_data = ds_list_create();
_load_data[| __IS_STREAM_IMAGE.ID ] = string( argument1 );
_load_data[| __IS_STREAM_IMAGE.TYPE ] = __IS.TYPE_STRIP;
_load_data[| __IS_STREAM_IMAGE.FPATH ] = argument2;
_load_data[| __IS_STREAM_IMAGE.SPRITES ] = _spr;
_load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] = argument3;
_load_data[| __IS_STREAM_IMAGE.XORIG ] = argument4;
_load_data[| __IS_STREAM_IMAGE.YORIG ] = argument5;



if( _priority <= 1 and !file_exists( argument2 ) ){
    var _l_loading = _m[? "loading" ];
    ds_list_add( _l_loading, _load_data );
    _m[? "finished" ] = false;
    
    //ds_priority_add( _p_sprite, _load_data, _priority );
} else {
    if( sprite_get_width( _spr ) <= _m[? "w" ] + _m[? "sep" ] && sprite_get_height( _spr ) <= _m[? "h" ] + _m[? "sep" ] ){
        if( _m[? "clamp" ] == false ){
            _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = 0;
            _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = 0;
            _load_data[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_width( _spr );
            _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_height( _spr );
        } else {
            _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = sprite_get_bbox_left( _spr );
            _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = sprite_get_bbox_top( _spr );
            _load_data[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_bbox_right( _spr ) - sprite_get_bbox_left( _spr ) + 1;
            _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_bbox_bottom( _spr ) - sprite_get_bbox_top( _spr ) + 1;
        }
        
        _load_data[| __IS_STREAM_IMAGE.XORIG ] *= sprite_get_width( _spr );
        _load_data[| __IS_STREAM_IMAGE.YORIG ] *= sprite_get_height( _spr );
        
        _priority = floor( ( _load_data[| __IS_STREAM_IMAGE.WIDTH ] + _load_data[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
    } else {
        sprite_delete( _spr );
        ds_list_destroy( _load_data );
        show_error( "Image is larger than texturepage! " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), false );
        return false;
    }
}

ds_priority_add( _p_sprite, _load_data, _priority );
return true;



