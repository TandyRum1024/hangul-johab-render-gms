///image_stream_start(group, tex_page_width, tex_page_height, tex_sep, clamp, removeback)
/*
    returns boolean;
*/


if( !ds_map_exists( global.m_ex_image, argument0 ) ){
    show_error( "Unknown image group '" + string( argument0 ) + "'", true );
    return false;
}
var _l = global.m_ex_image[? argument0 ];
if( ds_list_size( _l ) != 2 ){
    if( ds_list_size( _l ) == 3 and ds_exists( _l[| 2 ], ds_type_map ) ){
        show_error( "The image stream of the group '" + string( argument0 ) + "' has already started", true );
        return false;
    } else {
        show_error( "Invalid group '" + string( argument0 ) + "', the data might have been edited from outside.", true );
        return false;
    }
}

var _m_stream = ds_map_create();
ds_list_add( _l, _m_stream );
ds_list_mark_as_map( _l, 2 );

_m_stream[? "w" ]         = argument1;
_m_stream[? "h" ]         = argument2;
_m_stream[? "sep" ]       = argument3;
/*ds_map_add_list( _m_stream, "l_back", ds_list_create() );
ds_map_add_list( _m_stream, "l_back_3d", ds_list_create() );*/
_m_stream[? "sprite" ]    = ds_priority_create();
_m_stream[? "sprite_3d" ] = ds_priority_create();
_m_stream[? "loading" ]   = ds_list_create();
_m_stream[? "finished" ]  = true;
_m_stream[? "progress" ]  = 0;
_m_stream[? "clamp" ] = argument4;
_m_stream[? "removeback" ] = argument5;

return true;
