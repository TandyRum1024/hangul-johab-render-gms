///draw_image_pos(sprite,subimg,x1,y1,x2,y2,x3,y3,x4,y4,alpha)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
var _bck = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];

var _u_x = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ] / background_get_width( _bck );
var _u_y =  argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ] / background_get_height( _bck );
var _u_w = argument0[# __ISG_IMG.WIDTH, 0 ] / background_get_width( _bck );
var _u_h = argument0[# __ISG_IMG.HEIGHT, 0 ] / background_get_height( _bck );

draw_set_alpha( argument10 );
draw_primitive_begin_texture( pr_trianglelist, background_get_texture( _bck ) );
    draw_vertex_texture( argument2, argument3, _u_x, _u_y );
    draw_vertex_texture( argument4, argument5, _u_x+_u_w, _u_y );
    draw_vertex_texture( argument6, argument7, _u_x+_u_w, _u_y+_u_h );
    
    draw_vertex_texture( argument8, argument9, _u_x, _u_y+_u_h );
    draw_vertex_texture( argument2, argument3, _u_x, _u_y );
    draw_vertex_texture( argument6, argument7, _u_x+_u_w, _u_y+_u_h );
draw_primitive_end();
