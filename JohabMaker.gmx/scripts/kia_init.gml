///kia_init()
kia_conso = ds_list_create()
ds_list_add(kia_conso,1,0,1,1,1,1,1,0,0,0)
ds_list_add(kia_conso,0,0,0,0,0,0,1,1,1,1)
ds_list_add(kia_conso,0,1,1,1,0,1)

kia_uc = ds_list_create()
ds_list_add(kia_uc,16,17,25,22,6,8,29,8,2,4)
ds_list_add(kia_uc,0,20,18,13,1,5,17,0,3,20)
ds_list_add(kia_uc,6,28,23,27,12,26)

kia_c = ds_list_create()
ds_list_add(kia_c,6,17,14,11,3,5,18,8,2,4)
ds_list_add(kia_c,0,20,18,13,1,5,7,0,2,9)
ds_list_add(kia_c,6,17,12,16,12,15)

kia_fc = ds_list_create()
ds_list_add(kia_fc,16,0,23,21,7,8,27,0,0,0)
ds_list_add(kia_fc,0,0,0,0,0,0,17,1,4,19)
ds_list_add(kia_fc,0,26,22,25,0,24)

kia_first_convert = ds_list_create()
ds_list_add(kia_first_convert,0,1,3,6,7,8,16,17,18,20)
ds_list_add(kia_first_convert,21,22,23,24,25,26,27,28,29)

kia_final_convert = ds_list_create()
ds_list_add(kia_final_convert,-1,0,1,9,2,12,18,3,5,0)
ds_list_add(kia_final_convert,6,7,9,16,17,18,6,7,9,9)
ds_list_add(kia_final_convert,10,11,12,14,15,16,17,18)

kia_uc_base = ds_list_create()
kia_uc_add = ds_list_create()
kia_uc_result = ds_list_create()
ds_list_add(kia_uc_base,0,3,3,8,8,8,8,8,8,8,17)
ds_list_add(kia_uc_add,20,23,29,0,16,17,20,27,28,29,20)
ds_list_add(kia_uc_result,2,4,5,9,10,11,12,13,14,15,19)

kia_vowel_base = ds_list_create()
kia_vowel_add = ds_list_create()
kia_vowel_result = ds_list_create()
ds_list_add(kia_vowel_base,8,8,8,13,13,13,18)
ds_list_add(kia_vowel_add,0,1,20,4,5,20,20)
ds_list_add(kia_vowel_result,9,10,11,14,15,16,19)

kia_final_base = ds_list_create()
kia_final_add = ds_list_create()
kia_final_result = ds_list_create()
ds_list_add(kia_final_base,1,4,4,8,8,8,8,8,8,8,17)
ds_list_add(kia_final_add,19,22,27,1,16,17,19,25,26,27,19)
ds_list_add(kia_final_result,3,5,6,9,10,11,12,13,14,15,18)

kia_type = ""
