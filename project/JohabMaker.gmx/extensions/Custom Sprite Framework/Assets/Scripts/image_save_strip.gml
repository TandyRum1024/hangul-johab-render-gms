///image_save_strip(ind,fname)
var _subimg_count = argument0[# __ISG_IMG.SUBIMAGES, 0 ];

var _surf = surface_create( argument0[# __ISG_IMG.WIDTH, 0 ] * _subimg_count, argument0[# __ISG_IMG.HEIGHT, 0 ] );
surface_set_target( _surf );
    draw_clear_alpha( 0, 0 );
    for( var n = 0; n < _subimg_count; n++ ){
        draw_background_part(
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.BACK, 0 ], 
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.X, 0 ],
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.Y, 0 ],
            argument0[# __ISG_IMG.WIDTH, 0 ],
            argument0[# __ISG_IMG.HEIGHT, 0 ],
            argument0[# __ISG_IMG.WIDTH, 0 ] * n,
            0
        );
    }
surface_reset_target();

surface_save( _surf, argument1 );
surface_free( _surf );
