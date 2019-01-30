///draw_image(image,subimg,x,y)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
draw_background_part(
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ], 
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ],
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ],
    argument0[# __ISG_IMG.WIDTH, 0 ],
    argument0[# __ISG_IMG.HEIGHT, 0 ],
    argument2 - argument0[# __ISG_IMG.XORIGIN, 0 ],
    argument3 - argument0[# __ISG_IMG.YORIGIN, 0 ]
);

