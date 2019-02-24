///image_group_clear(group)
/*
    Clears the image group, does not destroy it.
    
    -------------------------
        group - The group name.
    -------------------------
    
    RETURNS a boolean, this shows whether the groups was cleared or not.
*/
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    var _l_image = _l[| 0 ];
    var _l_background = _l[| 1 ];
    
    image_stream_stop( argument0 );
    
    for( var n = 0; n < ds_list_size( _l_image ); n++ ){
        ds_grid_destroy( _l_image[| n ] );
    }
    
    for( var n = 0; n < ds_list_size( _l_background ); n++ ){
        background_delete( _l_background[| n ] );
    }
    ds_list_clear( _l_image );
    ds_list_clear( _l_background );
    return true;
} else {
    show_error( "The group '" + string( argument0 ) + "' you are trying to clear does not exist", false );
    return false;
}
