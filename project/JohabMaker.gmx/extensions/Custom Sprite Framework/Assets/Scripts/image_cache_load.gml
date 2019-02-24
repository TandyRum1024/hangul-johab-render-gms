///image_cache_load(fname)
gml_pragma( "forceinline" );
/*
    Loads the image cache file in as a buffer and checks 
    whether the file is an image cache that is supported. 
    This can be used for networking.
    
    -------------------------
        fname -  The name of the file to load. 
    -------------------------
    
    RETURNS the buffer id or -1 if it either fails or the cache is the wrong format.
*/

if( !file_exists( argument0 ) ){
    show_error( "The image group file '" + string( argument0 ) + "' does not exist", true );
    return -1;
}

// Load the cache
var _buf_cache = buffer_load( argument0 );

// Detect whether the file is an actual image cache file and check if the version is supported.
if( buffer_read( _buf_cache, buffer_string ) != "IMAGE_CACHE" ){
    show_error( "The file '" + string( argument0 ) + "' for the group '" + string( argument0 ) + "' is not an image cache!", false );
    buffer_delete( _buf_cache );
    return -1;
}
var _cache_version = buffer_read( _buf_cache, buffer_string );
switch( _cache_version ){
    case global.ex_image_cache_version: break; // Current version, no converting needed.
    
    default:
        show_error( "The image cache version in file '" + string( argument0 ) + "' is not supported!", false );
        buffer_delete( _buf_cache );
        return -1;
    break;
}
buffer_seek( _buf_cache, buffer_seek_start, 0 );
return _buf_cache;

