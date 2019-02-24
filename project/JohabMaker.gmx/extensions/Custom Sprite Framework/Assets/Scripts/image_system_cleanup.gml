///image_system_cleanup()
if( ds_exists( global.m_ex_image, ds_type_map ) ){
    while( ds_map_size( global.m_ex_image ) > 0 ){
        var _key = ds_map_find_first( global.m_ex_image );
        image_group_destroy( _key );
    }
    ds_map_destroy( global.m_ex_image );
    draw_texture_flush();
    show_debug_message( "IMAGE SYSTEM: Cleaned all image system memory" );
} else {
    show_debug_message( "IMAGE SYSTEM: Failed to clean image system, it is already clean");
}
