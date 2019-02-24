///draw_image_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)
gml_pragma("forceinline"); // YYC performance boost

var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
draw_background_part_ext(
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ],  
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ] + argument2,
    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ] + argument3,
    argument4,
    argument5,
    argument6,
    argument7,
    argument8,
    argument9,
    argument10,
    argument11
);
