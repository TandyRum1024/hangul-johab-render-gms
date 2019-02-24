///image_group_find_image(group,identifier)
/*
    Returns the image with the identifier.
    
    -------------------------
        group - The group name or the name that image_group_create() returned.
        identifier - The sprite identifier that was applied to the sprite using image_load_add(identifier,...)
    -------------------------
    
    RETURNS the image or -1 if failed.
*/

argument1 = string( argument1 );
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    var _l_image = _l[| 0 ];
    for( var n = 0; n < ds_list_size( _l_image ); n++ ){
        var _g = _l_image[| n ];
        if( _g[# __ISG_IMG.ID, 0 ] == argument1 ){
            /*show_debug_message( argument1 + " - " + 
                string( image_get_width( _g ) ) + ", " + string( image_get_height( _g ) ) + " | " +
                string( image_get_bbox_left( _g ) ) + ", " + string( image_get_bbox_top( _g ) ) + " | " +
                string( image_get_bbox_right( _g ) ) + ", " + string( image_get_bbox_bottom( _g ) ) );*/
            return _g;
        }
    }
    return( -1 );
} else {
    show_error( "The group '" + string( argument0 ) + "' you are trying to find the image '" + string( argument1 ) + "' from does not exist", false );
    return( -1 );
}
