///image_cache_unpack( group, cache )
/*
    Unpacks the image cache into the group.
    
    NOTE: If the group exists, it will be deleted and rewritten using ONLY the data in the cache. 
          If the group doesn't exist, no data will be overwritten.
    
    -------------------------
        group - The group name or the name that image_group_create() returned.
    -------------------------
    
    RETURNS boolean, which shows whether it unpacks or failed to unpack.
*/


// Load the cache
var _buf_cache = argument1;
buffer_seek( _buf_cache, buffer_seek_start, 0 );

// Detect whether the file is an actual image cache file and check if the version is supported.
if( buffer_read( _buf_cache, buffer_string ) != "IMAGE_CACHE" ){
    show_error( "The buffer '" + string( argument1 ) + "' for the group '" + string( argument0 ) + "' is not an image cache!", false );
    return false;
}
var _cache_version = buffer_read( _buf_cache, buffer_string );
switch( _cache_version ){
    case global.ex_image_cache_version: break; // Current version, no converting needed.
    case "1.0": break; // Supported older version
    
    default:
        show_error( "The image cache version '" + string( _cache_version ) + "' in buffer '" + string( argument1 ) + "' is not supported!", false );
        return false;
    break;
}

// Empty or create the group
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    image_group_clear( argument0 );
    var _l            = global.m_ex_image[? argument0 ];
    var _l_image      = _l[| 0 ];
    var _l_background = _l[| 1 ];
} else {
    var _l = ds_list_create();
    ds_map_add_list( global.m_ex_image, argument0, _l );
    var _l_image      = ds_list_create();
    var _l_background = ds_list_create();
    _l[| 0 ]          = _l_image;      // Image data list
    _l[| 1 ]          = _l_background; // Background list
    ds_list_mark_as_list( _l, 0 );
    ds_list_mark_as_list( _l, 1 );
}




// Load the image information
switch( _cache_version ){
    case "1.0":
        // Temp directory for extracting the cache
        var _dir = working_directory + ".TEMP_IMAGE_FOLDER/";
        if( directory_exists( _dir ) ){
            directory_destroy( _dir );
        }
        directory_create( _dir );
        
        // Load the textures
        var _tex_count = buffer_read( _buf_cache, buffer_u16 );
        for( var n = 0; n < _tex_count; n++ ){
            var _size = buffer_read( _buf_cache, buffer_u32 );
            buffer_save_ext( _buf_cache, _dir + string( n ) + ".png", buffer_tell( _buf_cache ), _size );
            buffer_seek( _buf_cache, buffer_seek_relative, _size );
            
            var _back = background_add( _dir + string( n ) + ".png", false, false );
            ds_list_add( _l_background, _back );
        }
        
        directory_destroy( _dir );
    
        var _image_count = buffer_read( _buf_cache, buffer_u16 );
        repeat( _image_count ){
            var _id      = buffer_read( _buf_cache, buffer_string );
            var _subimg  = buffer_read( _buf_cache, buffer_u16 );
            var _width   = buffer_read( _buf_cache, buffer_u16 );
            var _height  = buffer_read( _buf_cache, buffer_u16 );
            var _xorigin = buffer_read( _buf_cache, buffer_s16 );
            var _yorigin = buffer_read( _buf_cache, buffer_s16 );
            
            var _g_image = ds_grid_create( __ISG_IMG.COUNT + _subimg * __ISG_SUBIMG.COUNT + 1, 1 );
            ds_list_add( _l_image, _g_image );
            
            _g_image[# __ISG_IMG.ID, 0 ] = _id;
            _g_image[# __ISG_IMG.SUBIMAGES, 0 ] = _subimg;
            _g_image[# __ISG_IMG.WIDTH, 0 ] = _width;
            _g_image[# __ISG_IMG.HEIGHT, 0 ] = _height;
            _g_image[# __ISG_IMG.XORIGIN, 0 ] = _xorigin;
            _g_image[# __ISG_IMG.YORIGIN, 0 ] = _yorigin;
            // Bbox not supported in version 1.0, set to default values
            _g_image[# __ISG_IMG.BBOX_LEFT, 0 ]   = 0;
            _g_image[# __ISG_IMG.BBOX_TOP, 0 ]    = 0;
            _g_image[# __ISG_IMG.BBOX_RIGHT, 0 ]  = _width;
            _g_image[# __ISG_IMG.BBOX_BOTTOM, 0 ] = _height;
            
            for( var i = 0; i < _subimg; i++ ){
                var _index = buffer_read( _buf_cache, buffer_u16 ); // background
                var _x     = buffer_read( _buf_cache, buffer_u16 ); // x
                var _y     = buffer_read( _buf_cache, buffer_u16 ); // y
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.BACK, 0 ] = _l_background[| _index ];
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.X, 0 ] = _x;
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.Y, 0 ] = _y;
            }
            
            _g_image[# ds_grid_width( _g_image ) - 1, 0 ] = buffer_read( _buf_cache, buffer_string ); // filename
        }
    break;
    
    case "1.1":
        // Temp directory for extracting the cache
        var _dir = working_directory + ".TEMP_IMAGE_FOLDER/";
        if( directory_exists( _dir ) ){
            directory_destroy( _dir );
        }
        directory_create( _dir );
        
        // Load the textures
        var _tex_count = buffer_read( _buf_cache, buffer_u16 );
        for( var n = 0; n < _tex_count; n++ ){
            var _size = buffer_read( _buf_cache, buffer_u32 );
            buffer_save_ext( _buf_cache, _dir + string( n ) + ".png", buffer_tell( _buf_cache ), _size );
            buffer_seek( _buf_cache, buffer_seek_relative, _size );
            
            var _back = background_add( _dir + string( n ) + ".png", false, false );
            ds_list_add( _l_background, _back );
        }
        
        directory_destroy( _dir );
    
        var _image_count = buffer_read( _buf_cache, buffer_u16 );
        repeat( _image_count ){
            var _id          = buffer_read( _buf_cache, buffer_string );
            var _subimg      = buffer_read( _buf_cache, buffer_u16 );
            var _width       = buffer_read( _buf_cache, buffer_u16 );
            var _height      = buffer_read( _buf_cache, buffer_u16 );
            var _xorigin     = buffer_read( _buf_cache, buffer_s16 );
            var _yorigin     = buffer_read( _buf_cache, buffer_s16 );
            var _bbox_left   = buffer_read( _buf_cache, buffer_s16 );
            var _bbox_top    = buffer_read( _buf_cache, buffer_s16 );
            var _bbox_right  = buffer_read( _buf_cache, buffer_s16 );
            var _bbox_bottom = buffer_read( _buf_cache, buffer_s16 );
            
            var _g_image = ds_grid_create( __ISG_IMG.COUNT + _subimg * __ISG_SUBIMG.COUNT + 1, 1 );
            ds_list_add( _l_image, _g_image );
            
            _g_image[# __ISG_IMG.ID, 0 ]         = _id;
            _g_image[# __ISG_IMG.SUBIMAGES, 0 ]  = _subimg;
            _g_image[# __ISG_IMG.WIDTH, 0 ]       = _width;
            _g_image[# __ISG_IMG.HEIGHT, 0 ]      = _height;
            _g_image[# __ISG_IMG.XORIGIN, 0 ]     = _xorigin;
            _g_image[# __ISG_IMG.YORIGIN, 0 ]     = _yorigin;
            _g_image[# __ISG_IMG.BBOX_LEFT, 0 ]   = _bbox_left;
            _g_image[# __ISG_IMG.BBOX_TOP, 0 ]    = _bbox_top;
            _g_image[# __ISG_IMG.BBOX_RIGHT, 0 ]  = _bbox_right;
            _g_image[# __ISG_IMG.BBOX_BOTTOM, 0 ] = _bbox_bottom;
            
            for( var i = 0; i < _subimg; i++ ){
                var _index = buffer_read( _buf_cache, buffer_u16 ); // background
                var _x     = buffer_read( _buf_cache, buffer_u16 ); // x
                var _y     = buffer_read( _buf_cache, buffer_u16 ); // y
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.BACK, 0 ] = _l_background[| _index ];
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.X, 0 ] = _x;
                _g_image[# __ISG_IMG.COUNT + i * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.Y, 0 ] = _y;
            }
            
            _g_image[# ds_grid_width( _g_image ) - 1, 0 ] = buffer_read( _buf_cache, buffer_string ); // filename
        }
    break;
}
return true;

