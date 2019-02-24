///image_stream_progress(group)
/*
    Returns a value from 0-1, the larger the value, the more has been loaded.
*/
var _l = global.m_ex_image[? argument0 ];
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started." + chr(13) + "Group: " + string( argument0 ), true );
}
var _m = _l[| 2 ];
return _m[? "progress" ];

