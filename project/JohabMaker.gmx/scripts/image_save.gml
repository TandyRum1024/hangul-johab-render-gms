///image_save(ind,subimg,fname)
var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;

var _surf = surface_create( argument0[# __ISG_IMG.WIDTH, 0 ], argument0[# __ISG_IMG.HEIGHT, 0 ] );

surface_set_target( _surf );
    draw_clear_alpha( 0, 0 );
    draw_background_part(
        argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ], 
        argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ],
        argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ],
        argument0[# __ISG_IMG.WIDTH, 0 ],
        argument0[# __ISG_IMG.HEIGHT, 0 ],
        0,
        0
    );
surface_reset_target();
surface_save( _surf, argument2 );
surface_free( _surf );
