///image_group_create(name)
/*
    Creates a new image group
    
    -------------------------
        name - The group name that you will be using to reference to the group later.
    -------------------------
    
    RETURNS eiher the name of the new group or -1 which means that the function failed because the grup already exists.
*/
if( !ds_map_exists( global.m_ex_image, argument0 ) ){
    var _l = ds_list_create();
    ds_map_add_list( global.m_ex_image, argument0, _l );
    _l[| 0 ] = ds_list_create(); // 'Image' list
    _l[| 1 ] = ds_list_create(); // Background list
    ds_list_mark_as_list( _l, 0 );
    ds_list_mark_as_list( _l, 1 );
    return argument0;
} else {
    return -1;
}
