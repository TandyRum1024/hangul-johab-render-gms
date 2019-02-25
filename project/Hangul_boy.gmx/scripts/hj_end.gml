///hj_end()
/*
    한글 조합형 관련해서 할당한 메모리를 빼주는 함수입니다.
    게임이 끝나거나 할때 호출시켜주세요.
*/

ds_map_destroy(global.hjCacheData);
ds_map_destroy(global.hjCacheWid);
ds_map_destroy(global.hjCacheMisc);
