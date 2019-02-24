///image_stream_add_files(group,identifier,basename,xorig,yorig) - creates a sprite from a list of files with the specified name (spr_player_0,spr_player_1,...etc)
var _l = global.m_ex_image[? argument0 ];

// Error checking
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), true );
    return false; 
}

var _m = _l[| 2 ];
var _p_sprite = _m[? "sprite" ];
var _removeback = _m[? "removeback" ];

var _pq = ds_priority_create();
var _load_data = ds_list_create();

// Scan the file system
var _subimg_n = 0;
var _path_sprite =  argument2 + "_";
var _spritename = filename_name( _path_sprite );

var _bbox_left = 500000;
var _bbox_top = 500000;
var _bbox_right = -500000;
var _bbox_bottom = -500000;

var _file = file_find_first( _path_sprite + "*", 0 );
while( _file != "" ){
    var _file_ext = filename_ext( _file );
    var _file_extl = string_lower( _file_ext );
    
    // Make sure it is an image file
    if( _file_extl == ".png" || _file_extl == ".jpg" || _file_extl == ".jpeg" || _file_extl == ".gif" ){
        var _file_name = filename_name( _file );
        var _stripped_name = string_replace( string_replace( _file_name, _spritename, "" ), _file_ext, "" );
        
        // Make sure that it's coin_0.png and not coin_test_0.png
        if( string_digits( _stripped_name ) == _stripped_name && string_length( _stripped_name ) ){ 
            var _sub = real( _stripped_name );
            var _spr = sprite_add( _file, 1, _removeback, false, 0, 0 );
            _bbox_left = min( sprite_get_bbox_left( _spr ), _bbox_left );
            _bbox_top = min( sprite_get_bbox_top( _spr ), _bbox_top );
            _bbox_right = max( sprite_get_bbox_right( _spr ), _bbox_right );
            _bbox_bottom = max( sprite_get_bbox_bottom( _spr ), _bbox_bottom );
            
            ds_priority_add( _pq, _spr, _sub );
        }
    }
    
    _file = file_find_next();
}
file_find_close();

if( ds_priority_size( _pq ) ){
    var _spr = ds_priority_find_min( _pq );

    if( sprite_get_width( _spr ) <= _m[? "w" ] + _m[? "sep" ] && sprite_get_height( _spr ) <= _m[? "h" ] + _m[? "sep" ] ){
        _load_data[| __IS_STREAM_IMAGE.ID ] = string( argument1 );
        _load_data[| __IS_STREAM_IMAGE.TYPE ] = __IS.TYPE_LIST;
        _load_data[| __IS_STREAM_IMAGE.FPATH ] = argument2;
        _load_data[| __IS_STREAM_IMAGE.SPRITES ] = _pq;
        _load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] = ds_priority_size( _pq );
        
        _load_data[| __IS_STREAM_IMAGE.XORIG ] = argument3 * sprite_get_width( _spr );
        _load_data[| __IS_STREAM_IMAGE.YORIG ] = argument4 * sprite_get_height( _spr );
        
        if( _m[? "clamp" ] == false ){
            _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = 0;
            _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = 0;
            _load_data[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_width( _spr );
            _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_height( _spr );
        } else {
            _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = _bbox_left;
            _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = _bbox_top;
            _load_data[| __IS_STREAM_IMAGE.WIDTH ] = _bbox_right - _bbox_left + 1;
            _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = _bbox_bottom - _bbox_top + 1;
        }
        
        var _priority = floor( ( _load_data[| __IS_STREAM_IMAGE.WIDTH ] + _load_data[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
        
    } else {
        while( ds_priority_size( _pq ) ){
            sprite_delete( ds_priority_delete_min( _pq ) );
        }
        ds_list_destroy( _load_data );
        show_error( "Image is larger than texturepage! " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), false );
        return false;
    }
} else {
    ds_priority_destroy( _pq );
    ds_list_destroy( _load_data );

    show_error( "Could not find subimage files from '" + string( argument2 ) + "' for identifier '" + string( argument1 ) + " in group " + string( argument0 ), false );
    return false;
}

ds_priority_add( _p_sprite, _load_data, _priority );
return true;    
