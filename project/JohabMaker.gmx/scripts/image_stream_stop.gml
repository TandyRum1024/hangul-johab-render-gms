///image_stream_stop(group)
if( ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = global.m_ex_image[? argument0 ];
    
    // If the stream is active, clear it
    if( ds_list_size( _l ) == 3 ){
        var _m_stream = _l[| 2 ];
        ds_list_destroy( _m_stream[? "loading" ] );
        
        var _p_sprite = _m_stream[? "sprite" ];
        while( ds_priority_size( _p_sprite ) > 0 ){
            var _priority = ds_priority_find_priority( _p_sprite, ds_priority_find_max( _p_sprite ) );
            var _load_data = ds_priority_delete_max( _p_sprite );
            switch( _load_data[| __IS_STREAM_IMAGE.TYPE ] ){
                case __IS.TYPE_STRIP:
                    sprite_delete( _load_data[| __IS_STREAM_IMAGE.SPRITES ] );
                break;
                
                case __IS.TYPE_LIST:
                    var _p_subimages = _load_data[| __IS_STREAM_IMAGE.SPRITES ];
                    while( ds_priority_size( _p_subimages ) ){
                        var _spr = ds_priority_delete_min( _p_subimages );
                        sprite_delete( _spr );
                    }
                break;
                
                case __IS.TYPE_SHEET:
                    if( _priority <= 1 ){
                        background_delete( _load_data[| __IS_STREAM_IMAGE.SPRITES ] );
                    } else {
                        sprite_delete( _load_data[| __IS_STREAM_IMAGE.SPRITES ] );
                    }
                break;
            }
            
            ds_list_destroy( _load_data );
        }
        ds_priority_destroy( _p_sprite );
        
        var _p_sprite_3d = _m_stream[? "sprite_3d" ];
        while( ds_priority_size( _p_sprite ) > 0 ){
            var _load_data = ds_priority_delete_max( _p_sprite_3d );
            sprite_delete( _load_data[| __IS_STREAM_IMAGE.SPRITES ] );
            ds_list_destroy( _load_data );
        }
        ds_priority_destroy( _p_sprite_3d );
        
        ds_map_destroy( _m_stream );
        ds_list_delete( _l, 2 );
    }
}
