#define image_stream_finish
///image_stream_finish(group)
if( !image_stream_is_received( string( argument0 ) ) ){
    show_error( "The image stream has not finished yet " + chr(13) + "Group: " + string( argument0 ), true );
    return false;
}

enum __IS_FINISH {
    STREAM,
    TEXPAGES,
    AREAS,
    IMG_GRID,
    IMG_GRID_POS,
    IMG_DATA,
    IMG_SUBIMG,
    CLAMP,
    IMG_WIDTH,
    IMG_HEIGHT
}

// Stream data
var _l            = global.m_ex_image[? string( argument0 ) ];
var _l_image      = _l[| 0 ];
var _l_background = _l[| 1 ];
var _m_stream     = _l[| 2 ];

// Stream settings
var _clamp = _m_stream[? "clamp" ];
var _p_sprite    = _m_stream[? "sprite" ];
var _p_sprite_3d = _m_stream[? "sprite_3d" ];
var _width     = _m_stream[? "w" ];
var _height    = _m_stream[? "h" ];
var _sep       = _m_stream[? "sep" ];

// Draw settings
var _begin_alpha  = draw_get_alpha();
var _begin_colour = draw_get_colour();
draw_set_alpha( 1.0 );
draw_set_colour( c_white );
draw_enable_alphablend( false );

// CREATE THE DATA STRUCTURES NECESSARY FOR ADDING THE SPRITES ON THE TEXTURE PAGE
var _l_areas = ds_list_create();
var _q_trash = ds_queue_create();
var _l_texpage = ds_list_create();

// Session
var _session;
_session[ __IS_FINISH.STREAM ]   = _m_stream;
_session[ __IS_FINISH.TEXPAGES ] = _l_texpage;
_session[ __IS_FINISH.AREAS ]    = _l_areas;
_session[ __IS_FINISH.CLAMP ]    = _clamp;

__isf_texpage_create( _session );

while( ds_priority_size( _p_sprite ) ){ // LOOP THROUGH THE SPRITES AND ADD THEM TO THE TEXTURE PAGE WHERE POSSIBLE
    var _l_img_data = ds_priority_delete_max( _p_sprite );
    var _image_drawn = false;
    var _image_maindata_added = false;
    
    var _spr_number = _l_img_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ];
    var _g_image = ds_grid_create( __ISG_IMG.COUNT + _spr_number * __ISG_SUBIMG.COUNT + 1, 1 );
    ds_list_add( _l_image, _g_image );
    _session[ __IS_FINISH.IMG_GRID ] = _g_image;
    _session[ __IS_FINISH.IMG_GRID_POS ] = 0;
    _session[ __IS_FINISH.IMG_DATA ] = _l_img_data;
    _session[ __IS_FINISH.IMG_SUBIMG ] = 0;
    
    //show_debug_message( "Finishing " + string( _l_img_data[| __IS_STREAM_IMAGE.ID ] ) );
    
    switch( _l_img_data[| __IS_STREAM_IMAGE.TYPE ] ){
        case __IS.TYPE_LIST:
            var _p_image = _l_img_data[| __IS_STREAM_IMAGE.SPRITES ];
            
            while( ds_priority_size( _p_image ) ){
                var _subimg = ds_priority_delete_min( _p_image );
                
                var _min_area_id = __isf_find_area( _session, _l_img_data );
                if( _min_area_id == -1 ){ // Couldn't find an area for the subimage, no room on the texpage
                    __isf_texpage_create( _session );
                    _min_area_id = __isf_find_area( _session, _l_img_data );
                }
                
                __isf_subimg_to_area( _session, _subimg, 0, _min_area_id );
                
                ds_queue_enqueue( _q_trash, _subimg );
            }
            ds_list_destroy( _l_img_data );
        break;
        
        case __IS.TYPE_STRIP:
            var _spr = _l_img_data[| __IS_STREAM_IMAGE.SPRITES ];
            var _spr_number = sprite_get_number( _spr );
            
            for( var i = 0; i < sprite_get_number( _spr ); i++ ){
                var _min_area_id = __isf_find_area( _session, _l_img_data );
                if( _min_area_id == -1 ){ // Couldn't find an area for the subimage, no room on the texpage
                    __isf_texpage_create( _session );
                    _min_area_id = __isf_find_area( _session, _l_img_data );
                }
                
                __isf_subimg_to_area( _session, _spr, i, _min_area_id );
            }
            ds_queue_enqueue( _q_trash, _spr );
            ds_list_destroy( _l_img_data );
        break;
        
        case __IS.TYPE_SHEET:
            var _spr = _l_img_data[| __IS_STREAM_IMAGE.SPRITES ];
            var _spr_number = sprite_get_number( _spr );
            
            for( var i = 0; i < sprite_get_number( _spr ); i++ ){
                var _min_area_id = __isf_find_area( _session, _l_img_data );
                if( _min_area_id == -1 ){ // Couldn't find an area for the subimage, no room on the texpage
                    __isf_texpage_create( _session );
                    _min_area_id = __isf_find_area( _session, _l_img_data );
                }
                
                __isf_subimg_to_area( _session, _spr, i, _min_area_id );
            }
            ds_queue_enqueue( _q_trash, _spr );
            ds_list_destroy( _l_img_data );
        break;
        
        default:
            show_error( "Unknown image type found for " + _l_img_data[| __IS_STREAM_IMAGE.ID ] + " in group " + argument0, false );
        break;
    }
}
surface_reset_target();

// Clear memory
while( ds_queue_size( _q_trash ) > 0 ){
    sprite_delete( ds_queue_dequeue( _q_trash ) );
}
// CREATE THE BACKGROUND (TEXTUREPAGE)
for( var n = 0; n < ds_list_size( _l_texpage ); n += 2 ){
    var _back_temp = background_create_from_surface( _l_texpage[| n ], 0, 0, surface_get_width( _l_texpage[| n ] ), surface_get_height( _l_texpage[| n ] ), false, false );
    background_assign( _l_texpage[| n + 1 ], _back_temp );
    ds_list_add( _l_background, _l_texpage[| n + 1 ] );
    background_delete( _back_temp );
    surface_free( _l_texpage[| n ] );
}


// 3D specific images.
while( ds_priority_size( _p_sprite_3d ) > 0 ){
    var _l_img      = ds_priority_delete_max( _p_sprite_3d );
    var _spr        = _l_img[| __IS_STREAM_IMAGE.SPRITES ];
    var _identifier = _l_img[| __IS_STREAM_IMAGE.ID ];
    var _subimg     = sprite_get_number( _spr );
    var _xorig      = _l_img[| __IS_STREAM_IMAGE.XORIG ];
    var _yorig      = _l_img[| __IS_STREAM_IMAGE.YORIG ];
    var _w          = sprite_get_width( _spr );
    var _surface    = surface_create( _w, sprite_get_height( _spr ) );
    
    var _g_image = ds_grid_create( __ISG_IMG.COUNT + _subimg * __ISG_SUBIMG.COUNT + 1, 1 );
    ds_list_add( _l_image, _g_image );
    var _pos = 0;
    _g_image[# __ISG_IMG.ID, 0 ] = _identifier;                    // IDENTIFIER
    _g_image[# __ISG_IMG.SUBIMAGES, 0 ] = _subimg;                        // SUBIMAGE
    _g_image[# __ISG_IMG.WIDTH, 0 ] = _w;                             // SUBIMAGE WIDTH
    _g_image[# __ISG_IMG.HEIGHT, 0 ] = sprite_get_height( _spr );      // SUBIMAGE HEIGHT
    _g_image[# __ISG_IMG.XORIGIN, 0 ] = _xorig;                         // XORIGIN
    _g_image[# __ISG_IMG.YORIGIN, 0 ] = _yorig;                         // YORIGIN
    
    _g_image[# __ISG_IMG.BBOX_LEFT, 0 ]   = sprite_get_bbox_left( _spr );
    _g_image[# __ISG_IMG.BBOX_TOP, 0 ]    = sprite_get_bbox_top( _spr );
    _g_image[# __ISG_IMG.BBOX_RIGHT, 0 ]  = sprite_get_bbox_right( _spr );
    _g_image[# __ISG_IMG.BBOX_BOTTOM, 0 ] = sprite_get_bbox_bottom( _spr );
    
    _pos += __ISG_IMG.COUNT;
    
    for( var n = 0; n < _subimg; n++ ){
        surface_set_target( _surface );
        draw_clear_alpha( 0, 0 );
        draw_sprite_part( _spr, n, 0, 0, n * _w + _w, sprite_get_height( _spr ), 0, 0 );
        surface_reset_target();
        var _back_subimg = background_create_from_surface( _surface, 0, 0, _w, sprite_get_height( _spr ), false, false );
        ds_list_add( _l_background, _back_subimg );
        _g_image[# _pos + __ISG_SUBIMG.BACK, 0 ] = _back_subimg; // BACKGROUND
        _g_image[# _pos + __ISG_SUBIMG.X, 0 ] = 0;            // X
        _g_image[# _pos + __ISG_SUBIMG.Y, 0 ] = 0;            // Y
        _pos += __ISG_SUBIMG.COUNT;
    }
    _g_image[# ds_grid_width( _g_image ) - 1, 0 ] = _l_img[| __IS_STREAM_IMAGE.FPATH ]; // FNAME
    
    surface_free( _surface );
    sprite_delete( _spr );
    ds_list_destroy( _l_img );
}
draw_enable_alphablend( true );

draw_set_alpha( _begin_alpha );
draw_set_colour( _begin_colour );

// Clear memory
ds_list_destroy( _l_areas );
ds_priority_destroy( _p_sprite );
ds_priority_destroy( _p_sprite_3d );
ds_list_destroy( _m_stream[? "loading" ] );
ds_queue_destroy( _q_trash );
ds_list_destroy( _l_texpage );    
ds_list_delete( global.m_ex_image[? string( argument0 ) ], 2 );

return true;

#define __isf_find_area
///__isf_find_area(session,image_data)
var _l_areas = argument0[ __IS_FINISH.AREAS ];
var _min_area_size = $10000000000000;
var _min_area_id   = -1;
var _w = argument1[| __IS_STREAM_IMAGE.WIDTH ];
var _h = argument1[| __IS_STREAM_IMAGE.HEIGHT ];


for( var n = 0; n < ds_list_size( _l_areas ); n += 4 ){
    if( _w <= _l_areas[| n + 2 ] and _h <= _l_areas[| n + 3 ] ){
        if( ( ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2 ) < _min_area_size ){
            _min_area_size = ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2;
            _min_area_id = n;
        }
    }
}

return _min_area_id;

#define __isf_texpage_create
///__isf_texpage_create(session)

var _l_areas = argument0[ __IS_FINISH.AREAS ];
var _l_texpage = argument0[ __IS_FINISH.TEXPAGES ];
var _m_stream = argument0[ __IS_FINISH.STREAM ];

var _w = _m_stream[? "w" ];
var _h = _m_stream[? "h" ];
var _sep = _m_stream[? "sep" ];

ds_list_clear( _l_areas );
ds_list_add( _l_areas, _sep, _sep, _w - _sep, _h - _sep );

var _back = background_create_colour( _w, _h, c_black );
ds_list_add( _l_texpage, surface_create( _w, _h ), _back);
surface_reset_target();
surface_set_target( _l_texpage[| ds_list_size( _l_texpage ) - 2 ] );
draw_clear_alpha( 0,0 );



#define __isf_subimg_to_area
///__isf_subimg_to_area( session, sprite, subimg, area_id);
///__isf_subimg_to_area(l_texpage, l_img, subimage_count, spr, subimg, l_areas, area_id, g_image, pos_in_grid)

var _l_texpage = argument0[ __IS_FINISH.TEXPAGES ];
var _l_data   = argument0[ __IS_FINISH.IMG_DATA ];
var _spr_number = _l_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ];
var _l_areas = argument0[ __IS_FINISH.AREAS ];
var _g_image = argument0[ __IS_FINISH.IMG_GRID ];
var _pos = argument0[ __IS_FINISH.IMG_GRID_POS ];
var _m_stream = argument0[ __IS_FINISH.STREAM ];

var _clamp = argument0[ __IS_FINISH.CLAMP ];

var _spr     = argument1;
var _subimg  = argument2;
var _area_id = argument3;

var _sep = _m_stream[? "sep" ];

var _subimg_w = _l_data[| __IS_STREAM_IMAGE.WIDTH ];
var _subimg_h = _l_data[| __IS_STREAM_IMAGE.HEIGHT ];



draw_sprite_part( 
    _spr, _subimg, 
    _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ], _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ], 
    _subimg_w, _subimg_h, 
    _l_areas[| _area_id ], _l_areas[| _area_id + 1 ] 
);
_image_drawn = true;

if( _pos == 0){
    // ADD THE MAIN DATA OF THE SPRITE TO THE SPRITE DATA STRUCTURE
    _g_image[# __ISG_IMG.ID, 0 ]          = _l_data[| __IS_STREAM_IMAGE.ID ];
    _g_image[# __ISG_IMG.SUBIMAGES, 0 ]   = _spr_number;
    _g_image[# __ISG_IMG.WIDTH, 0 ]       = _subimg_w;
    _g_image[# __ISG_IMG.HEIGHT, 0 ]      = _subimg_h;
    _g_image[# __ISG_IMG.XORIGIN, 0 ]     = _l_data[| __IS_STREAM_IMAGE.XORIG ] - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
    _g_image[# __ISG_IMG.YORIGIN, 0 ]     = _l_data[| __IS_STREAM_IMAGE.YORIG ] - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
    _g_image[# __ISG_IMG.BBOX_LEFT, 0 ]   = sprite_get_bbox_left( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
    _g_image[# __ISG_IMG.BBOX_TOP, 0 ]    = sprite_get_bbox_top( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
    _g_image[# __ISG_IMG.BBOX_RIGHT, 0 ]  = sprite_get_bbox_right( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
    _g_image[# __ISG_IMG.BBOX_BOTTOM, 0 ] = sprite_get_bbox_bottom( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
    _pos += __ISG_IMG.COUNT;
}

// ADD THE SUBIMAGE OF THE SPRITE TO THE SPRITE DATA STRUCTURE
_g_image[# _pos + __ISG_SUBIMG.BACK, 0 ] = _l_texpage[| ds_list_size( _l_texpage ) - 1 ];
_g_image[# _pos + __ISG_SUBIMG.X, 0 ]    = _l_areas[| _area_id ];
_g_image[# _pos + __ISG_SUBIMG.Y, 0 ]    = _l_areas[| _area_id + 1 ];

_pos += __ISG_SUBIMG.COUNT;

if( argument0[@ __IS_FINISH.IMG_SUBIMG ] == _spr_number - 1 ){
    _g_image[# _pos, 0 ] = _l_data[| __IS_STREAM_IMAGE.FPATH ]; // FNAME
    _pos += 1;
}

// ADD THE NEW EMPTY AREAS TO THE AREA LIST


if( _subimg_h < _l_areas[| _area_id + 3 ] ){
    ds_list_add( _l_areas, 
        _l_areas[| _area_id ],                        // X
        _l_areas[| _area_id + 1 ] + _subimg_h + _sep, // Y
        _l_areas[| _area_id + 2 ],                    // W
        _l_areas[| _area_id + 3 ] - _subimg_h - _sep  // H
    );
    /*var p = ds_list_size( _l_areas ) - 4; // Area debugging for texpages
    draw_set_colour( irandom( c_white ) );
    draw_rectangle(
        _l_areas[| p ], _l_areas[| p + 1 ],
        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
        false
    );*/
}
if( _subimg_w < _l_areas[| _area_id + 2 ] ){
    ds_list_add( _l_areas, 
        _l_areas[| _area_id ] + _subimg_w + _sep,     // X
        _l_areas[| _area_id + 1 ],                    // Y
        _l_areas[| _area_id + 2 ] - _subimg_w - _sep, // W
        _subimg_h                                     // H
    );
    /*var p = ds_list_size( _l_areas ) - 4; // Area debugging for texpages
    draw_set_colour( irandom( c_white ) );
    draw_rectangle(
        _l_areas[| p ], _l_areas[| p + 1 ],
        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
        false
    );*/
}


/*Don't uncomment. This is just the vertical version of the above

if( _subimg_w < _l_areas[| _area_id + 2 ] ){
    ds_list_add( _l_areas, 
        _l_areas[| _area_id ] + _subimg_w + _sep,     // X
        _l_areas[| _area_id + 1 ],                    // Y
        _l_areas[| _area_id + 2 ] - _subimg_w - _sep, // W
        _l_areas[| _area_id + 3 ]
    );
    var p = ds_list_size( _l_areas ) - 4;
    draw_set_colour( irandom( c_white ) );
    draw_rectangle(
        _l_areas[| p ], _l_areas[| p + 1 ],
        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
        false
    );
}

if( _subimg_h < _l_areas[| _area_id + 3 ] ){
    ds_list_add( _l_areas, 
        _l_areas[| _area_id ],     // X
        _l_areas[| _area_id + 1 ] + _subimg_h + _sep, // Y
        _subimg_w + _sep, // W
        _l_areas[| _area_id + 3 ] - _subimg_h - _sep  // H
    );
    var p = ds_list_size( _l_areas ) - 4;
    draw_set_colour( irandom( c_white ) );
    draw_rectangle(
        _l_areas[| p ], _l_areas[| p + 1 ],
        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
        false
    );
}*/


// REMOVE THE CURRENT AREA FROM THE AREA LIST
repeat( 4 )
    ds_list_delete( _l_areas, _area_id );

argument0[@ __IS_FINISH.IMG_GRID_POS ] = _pos;
argument0[@ __IS_FINISH.IMG_SUBIMG ] += 1;