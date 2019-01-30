///image_group_flush(group)
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    var _l_background = _l[| 1 ];

    for( var n = 0; n < ds_list_size( _l_background ); n++ ){
        background_flush( _l_background[| n ] );
    }
    return true;
} else {
    show_error( "The group '" + string( argument0 ) + "' you are trying to clear does not exist", false );
    return false;
}
