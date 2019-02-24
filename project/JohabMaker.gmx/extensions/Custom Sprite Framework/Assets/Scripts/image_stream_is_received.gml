///image_stream_is_received(group)
var _l = global.m_ex_image[? argument0 ];
if( ds_list_size( _l ) != 3 ){
    show_error( "Image stream not started." + chr(13) + "Group: " + string( argument0 ), true );
    return false;
}
var _m = _l[| 2 ];
return _m[? "finished" ];

