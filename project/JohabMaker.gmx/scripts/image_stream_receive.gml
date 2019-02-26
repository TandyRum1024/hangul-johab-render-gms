///image_stream_receive(group)
if( !ds_exists( async_load, ds_type_map ) ){
    show_error( "image_stream_receive() can only be used in Image Loaded event", true );
    return false;
}

// Async data
var _id     = async_load[? "id" ];
var _fname  = async_load[? "filename" ];
var _status = async_load[? "status" ];

// Image stream data 
var _l = global.m_ex_image[? argument0 ];
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started." + chr(13) + "Group: " + string( argument0 ), true );
    return false;
}
var _m            = _l[| 2 ];
var _l_loading    = _m[? "loading" ];
var _p_sprite       = _m[? "sprite" ];
var _p_sprite_3d    = _m[? "sprite_3d" ];


// Check if we got the data.
for( var n = 0; n < ds_list_size( _l_loading ); n++ ){
    var _l_sprite = _l_loading[| n ];
    switch( _l_sprite[| __IS_STREAM_IMAGE.TYPE ] ){
        case __IS.TYPE_STRIP:
            if( _l_sprite[|  __IS_STREAM_IMAGE.SPRITES ] == _id && _l_sprite[|  __IS_STREAM_IMAGE.FPATH ] == _fname ){
                if( _status >= 0 ){
                    //show_debug_message( "IMAGE SYSTEM: Group " + string( argument0 ) + " received " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + "[STRIP] "  );
                    ds_list_delete( _l_loading, n );
                    n--;
                    
                    if( point_in_rectangle( sprite_get_width( _id ), sprite_get_height( _id ), 1, 1, _m[? "w" ] + _m[? "sep" ], _m[? "h" ] + _m[? "sep" ] ) ){
                        if( _m[? "clamp" ] == false ){
                            _l_sprite[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = 0;
                            _l_sprite[| __IS_STREAM_IMAGE.CLAMP_TOP ] = 0;
                            _l_sprite[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_width( _id );
                            _l_sprite[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_height( _id );
                        } else {
                            _l_sprite[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = sprite_get_bbox_left( _id );
                            _l_sprite[| __IS_STREAM_IMAGE.CLAMP_TOP ] = sprite_get_bbox_top( _id );
                            _l_sprite[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_bbox_right( _id ) - sprite_get_bbox_left( _id ) + 1;
                            _l_sprite[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_bbox_bottom( _id ) - sprite_get_bbox_top( _id ) + 1;
                        }
                        
                        _l_sprite[| __IS_STREAM_IMAGE.XORIG ] *= sprite_get_width( _id );
                        _l_sprite[| __IS_STREAM_IMAGE.YORIG ] *= sprite_get_height( _id );
                        
                        var _priority = floor( ( _l_sprite[| __IS_STREAM_IMAGE.WIDTH ] + _l_sprite[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
                        ds_priority_change_priority( _p_sprite, _l_sprite, _priority );
                    } else {
                        sprite_delete( _id );
                        ds_list_destroy( _l_sprite );
                        ds_priority_delete_value( _p_sprite, _l_sprite );
                        show_error( "Image is the wrong size (" + string( sprite_get_width( _id ) ) + ", " + string( sprite_get_width( _id ) ) + 
                            ") for the texturepage (" + string( _m[?"w"] ) + ", " + string( _m[? "h" ] ) + ")! " + chr(13) + 
                            "Group: " + string( argument0 ) + chr(13) + 
                            "Identifier " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + chr(13) + 
                            "Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] ), false );
                    }
                    continue;
                } else {
                    show_debug_message( "IMAGE SYSTEM: Load failed for " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + 
                        "[STRIP] Group: " + string( argument0 ) + chr(13) + "Error: " + string( _status ) + 
                        " Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] )
                    );
                    
                    _l_sprite[| __IS_STREAM_IMAGE.SPRITES ] = sprite_add( 
                        _l_sprite[| __IS_STREAM_IMAGE.FPATH ], sprite_get_number( _id ), 
                        _m[? "removeback" ], false,
                        sprite_get_xoffset( _id ), sprite_get_yoffset( _id ) 
                    );
                    sprite_delete( _id );
                }
            }
        break;
        
        case __IS.TYPE_SHEET:
            var _bck = _l_sprite[|  __IS_STREAM_IMAGE.SPRITES ];
            if( _l_sprite[|  __IS_STREAM_IMAGE.SPRITES ] == _id && _l_sprite[|  __IS_STREAM_IMAGE.FPATH ] == _fname ){
                if( _status >= 0 ){
                    ds_list_delete( _l_loading, n );
                    n--;
                    
                    var _subimg_ver = _l_sprite[| __IS_STREAM_IMAGE.SUBIMG_ROWS ];
                    var _subimg_hor = _l_sprite[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] / _subimg_ver;
                    var _spr_w = background_get_width( _id ) / _subimg_hor;
                    var _spr_h = background_get_height( _id ) / _subimg_ver;
                    
                    //show_debug_message( "IMAGE SYSTEM: Group " + string( argument0 ) + " received " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + "[SHEET]"  );
                    
                    if( point_in_rectangle( _spr_w, _spr_h, 1, 1, _m[? "w" ] + _m[? "sep" ], _m[? "h" ] + _m[? "sep" ] ) ){
                        __isa_sheet_bake( _l_sprite, _m[? "clamp" ] );
                        var _spr = _l_sprite[| __IS_STREAM_IMAGE.SPRITES ];
                        var _priority = floor( ( _l_sprite[| __IS_STREAM_IMAGE.WIDTH ] + _l_sprite[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
                        ds_priority_change_priority( _p_sprite, _l_sprite, _priority );
                    } else {
                        background_delete( _id );
                        ds_list_destroy( _l_sprite );
                        ds_priority_delete_value( _p_sprite, _l_sprite );
                        show_error( "Image is the wrong size (" + string( _spr_w ) + ", " + string( _spr_h ) + 
                            ") for the texturepage (" + string( _m[?"w"] ) + ", " + string( _m[? "h" ] ) + ")! " + chr(13) + 
                            "Group: " + string( argument0 ) + chr(13) + 
                            "Identifier " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + chr(13) + 
                            "Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] ), false );
                    }
                } else {
                    show_debug_message( "IMAGE SYSTEM: Load failed for " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + 
                        "[SHEET] Group: " + string( argument0 ) + chr(13) + "Error: " + string( _status ) + 
                        " Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] )
                    );
                    
                    _l_sprite[| __IS_STREAM_IMAGE.SPRITES ] = background_add( _l_sprite[| __IS_STREAM_IMAGE.FPATH ], _m[? "removeback" ], false );
                    background_delete( _id );
                }
            }
        break;
        
        case __IS.TYPE_3D:
            if( _l_sprite[| __IS_STREAM_IMAGE.SPRITES ] == _id && _l_sprite[|  __IS_STREAM_IMAGE.FPATH ] == _fname ){
                if( _status >= 0 ){
                    ds_list_delete( _l_loading, n );
                    n--;
                    //show_debug_message( "IMAGE SYSTEM: Group " + string( argument0 ) + " received " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + "[3D]"  );
                    
                    var _spr_w = sprite_get_width( _id );
                    var _spr_h = sprite_get_height( _id );
                    
                    if( point_in_rectangle( _spr_w, _spr_h, 1, 1, _m[? "w" ] + _m[? "sep" ], _m[? "h" ] + _m[? "sep" ] ) ){
                        _l_sprite[| __IS_STREAM_IMAGE.XORIG ] *= sprite_get_width( _id );
                        _l_sprite[| __IS_STREAM_IMAGE.YORIG ] *= sprite_get_height( _id );
                        
                        
                        var _priority = ( _spr_w + _spr_h ) * 0.5;
                        ds_priority_change_priority( _p_sprite_3d, _l_sprite, _priority );
                    } else {
                        sprite_delete( _id );
                        ds_list_destroy( _l_sprite );
                        ds_priority_delete_value( _p_sprite, _l_sprite );
                        show_error( "Image is the wrong size (" + string( _spr_w ) + ", " + string( _spr_h ) + 
                            ") for the texturepage (" + string( _m[?"w"] ) + ", " + string( _m[? "h" ] ) + ")! " + chr(13) + 
                            "Group: " + string( argument0 ) + chr(13) + 
                            "Identifier " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + chr(13) + 
                            "Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] ), false );
                    }
                    continue;
                } else {
                    show_debug_message( "IMAGE SYSTEM: Load failed for " + string( _l_sprite[| __IS_STREAM_IMAGE.ID ] ) + 
                        "[3D] Group: " + string( argument0 ) + chr(13) + "Error: " + string( _status ) + 
                        " Path: " + string( _l_sprite[| __IS_STREAM_IMAGE.FPATH ] )
                    );
                    
                    _l_sprite[| __IS_STREAM_IMAGE.SPRITES ] = sprite_add( _l_sprite[| __IS_STREAM_IMAGE.FPATH ], sprite_get_number( _id ), _m[? "removeback" ], false, 0, 0 );
                    sprite_delete( _id );
                }
            }
        break;
        
        default:
            show_error( "Unknown image type " + string( _l_sprite[| __IS_STREAM_IMAGE.TYPE ] ) + 
                chr(13) + "Identifier: " + string( _l_sprite[| 1 ] ) + chr(13) + "Group: " + string( argument0 ), false );
        break;
    }
}


var _total  = ds_priority_size( _p_sprite ) + ds_priority_size( _p_sprite_3d );
if( _total != 0 ){
    var _loaded = _total - ( ds_list_size( _l_loading ) );
    
    // Update progress
    _m[? "progress" ] = _loaded / _total;
    _m[? "finished" ] = ( _loaded == _total );
}
return true;
