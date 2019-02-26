///image_cache_delete(cache)
gml_pragma( "forceinline" );
/*
    Deletes the image cache
    
    -------------------------
        cache - The buffer that image_cache_create() or image_cache_load() returned.
    -------------------------
*/
buffer_delete( argument0 );
