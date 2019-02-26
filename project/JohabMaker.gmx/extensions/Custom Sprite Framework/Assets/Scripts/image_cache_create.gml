///image_cache_create( group )
/*
    Creates a cache for the image group and returns the buffer that it is stored in,
    this can be saved using image_cache_save() or used in networking.
    
    -------------------------
        group - The group name or the name that image_group_create() returned.
    -------------------------
    
    RETURNS buffer or -1 if failed.
*/

if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    var _l_image      = _l[| 0 ];
    var _l_background = _l[| 1 ];
    
    // Temp directory
    var _dir = working_directory + ".TEMP_IMAGE_FOLDER/";
    if( directory_exists( _dir ) ){
        directory_destroy( _dir );
    }
    directory_create( _dir );
    
    // Create the cache and add safe checks
    var _buf_cache = buffer_create( 1, buffer_grow, 1 );
    buffer_seek( _buf_cache, buffer_seek_start, 0 );
    buffer_write( _buf_cache, buffer_string, "IMAGE_CACHE" );
    buffer_write( _buf_cache, buffer_string, global.ex_image_cache_version );
    
    // Add the image to the cache
    buffer_write( _buf_cache, buffer_u16, ds_list_size( _l_background ) );
    for( var n = 0; n < ds_list_size( _l_background ); n++ ){
        var _back = _l_background[| n ];
        background_save( _l_background[| n ], _dir + string( _l_background[| n ] ) + ".png" );
        var _buf = buffer_load( _dir + string( _l_background[| n ] ) + ".png" );
        buffer_write( _buf_cache, buffer_u32, buffer_get_size( _buf ) );
        buffer_copy( _buf, 0, buffer_get_size( _buf ), _buf_cache, buffer_tell( _buf_cache ) );
        
        buffer_seek( _buf_cache, buffer_seek_relative, buffer_get_size( _buf ) );
        buffer_delete( _buf );
    }
    
    // Write the image info into the cache
    buffer_write( _buf_cache, buffer_u16, ds_list_size( _l_image ) );
    for( var n = 0; n < ds_list_size( _l_image ); n++ ){
        var _g       = _l_image[| n ];
        var _id      = _g[# __ISG_IMG.ID, 0 ];
        var _subimg  = _g[# __ISG_IMG.SUBIMAGES, 0 ];
        var _width   = _g[# __ISG_IMG.WIDTH, 0 ];
        var _height  = _g[# __ISG_IMG.HEIGHT, 0 ];
        var _xorigin = _g[# __ISG_IMG.XORIGIN, 0 ];
        var _yorigin = _g[# __ISG_IMG.YORIGIN, 0 ];
        
        buffer_write( _buf_cache, buffer_string, string( _id )  );
        buffer_write( _buf_cache, buffer_u16, _subimg  );
        buffer_write( _buf_cache, buffer_u16, _width   );
        buffer_write( _buf_cache, buffer_u16, _height  );
        buffer_write( _buf_cache, buffer_s16, _xorigin );
        buffer_write( _buf_cache, buffer_s16, _yorigin );
        buffer_write( _buf_cache, buffer_s16, _g[# __ISG_IMG.BBOX_LEFT, 0 ] );
        buffer_write( _buf_cache, buffer_s16, _g[# __ISG_IMG.BBOX_TOP, 0 ] );
        buffer_write( _buf_cache, buffer_s16, _g[# __ISG_IMG.BBOX_RIGHT, 0 ] );
        buffer_write( _buf_cache, buffer_s16, _g[# __ISG_IMG.BBOX_BOTTOM, 0 ] );
        
        for( var i = 0; i < _subimg; i++ ){
            var _bck = _g[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.BACK, 0 ];
            var _bck_x = _g[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.X, 0 ];
            var _bck_y = _g[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.Y, 0 ];
            
            var _index = ds_list_find_index( _l_background, _bck );
            if( _index != -1 )
                buffer_write( _buf_cache, buffer_u16, _index );//_g[# 6 + i * 3, 0 ] );
            else
                show_error( "The texturepage with id '" + string( _bck ) + "' Couldn't be found in the group background ds_list", true );
            buffer_write( _buf_cache, buffer_u16, _bck_x );
            buffer_write( _buf_cache, buffer_u16, _bck_y );
        }
        buffer_write( _buf_cache, buffer_string, string( _g[# ds_grid_width( _g ) - 1, 0 ] ) );
    }
    buffer_resize( _buf_cache, buffer_tell( _buf_cache ) );
    directory_destroy( _dir );
    return _buf_cache;
} else {
    show_error( "The image group '" + string( argument0 ) + "' you are trying to save does not exist", false );
    return -1;
}
