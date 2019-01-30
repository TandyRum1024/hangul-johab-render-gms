///draw_image_ext(image,subimg,x,y,xscale,yscale,rot,colour,alpha)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
draw_background_general(
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ], 
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ],
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ],
    argument0[# __ISG_IMG.WIDTH, 0 ],
    argument0[# __ISG_IMG.HEIGHT, 0 ],
    argument2 - lengthdir_x( argument0[# __ISG_IMG.XORIGIN, 0 ], argument6 )*argument4 - 
                lengthdir_x( argument0[# __ISG_IMG.YORIGIN, 0 ], argument6 - 90 )*argument5,
    argument3 - lengthdir_y( argument0[# __ISG_IMG.XORIGIN, 0 ], argument6 )*argument4 - 
                lengthdir_y( argument0[# __ISG_IMG.YORIGIN, 0 ], argument6 - 90 )*argument5,
    argument4,
    argument5,
    argument6,
    argument7,
    argument7,
    argument7,
    argument7,
    argument8
);
