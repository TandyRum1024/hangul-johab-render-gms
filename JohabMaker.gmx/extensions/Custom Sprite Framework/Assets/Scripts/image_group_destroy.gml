///image_group_destroy(group)
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    var _l_image = _l[| 0 ];
    var _l_background = _l[| 1 ];
    
    image_group_clear( argument0 );
    
    // Remove the data structures
    ds_list_destroy( _l_image );
    ds_list_destroy( _l_background );
    ds_list_destroy( _l );
    ds_map_delete( global.m_ex_image, argument0 );
    return true;
} else {
    show_error( "The group '" + string( argument0 ) + "' you are trying to clear does not exist", false );
    return false;
}
