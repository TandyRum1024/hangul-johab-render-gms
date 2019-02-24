///image_save_sheet(ind,fname,row_count)
var _subimg_count = argument0[# __ISG_IMG.SUBIMAGES, 0 ];
var _row_count = argument2;
var _col_count = ceil( _subimg_count / _row_count );

var _surf = surface_create( argument0[# __ISG_IMG.WIDTH, 0 ] * _row_count, argument0[# __ISG_IMG.HEIGHT, 0 ] * _col_count );
surface_set_target( _surf );
    draw_clear_alpha( 0, 0 );
    for( var n = 0; n < _subimg_count; n++ ){
        var _x = n mod _row_count;
        var _y = n div _row_count;
        draw_background_part(
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.BACK, 0 ], 
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.X, 0 ],
            argument0[# __ISG_IMG.COUNT + n * __ISG_SUBIMG.COUNT + __ISG_SUBIMG.Y, 0 ],
            argument0[# __ISG_IMG.WIDTH, 0 ],
            argument0[# __ISG_IMG.HEIGHT, 0 ],
            _x * argument0[# __ISG_IMG.WIDTH, 0 ],
            _y * argument0[# __ISG_IMG.HEIGHT, 0 ]
        );
    }
surface_reset_target();

surface_save( _surf, argument1 );
surface_free( _surf );
