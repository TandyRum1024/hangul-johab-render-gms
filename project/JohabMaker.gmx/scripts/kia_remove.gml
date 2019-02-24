///kia_remove()
var _char = ord(kia_type)
if _char >= $3131 && _char < $314F
{
    if ds_list_find_index(kia_uc_result,_char-$3131) != -1
    {
        kia_type = chr(ds_list_find_value(kia_uc_base,ds_list_find_index(kia_uc_result,_char-$3131))+$3131)
        return false
    }
    kia_type = ""
    return false
}
if _char >= $314F && _char <= $3163
{
    if ds_list_find_index(kia_vowel_result,_char-$314F) != -1
    {
        kia_type = chr(ds_list_find_value(kia_vowel_base,ds_list_find_index(kia_vowel_result,_char-$314F))+$314F)
        return false
    }
    kia_type = ""
    return false
}
if _char >= $AC00 && kia_third(_char) = 0
{
    if ds_list_find_index(kia_vowel_result,kia_second(_char)) != -1
    {
        kia_type = chr((kia_first(_char)*21+ds_list_find_value(kia_vowel_base,ds_list_find_index(kia_vowel_result,kia_second(_char))))*28+$AC00)
        return false
    }
    kia_type = chr(ds_list_find_value(kia_first_convert,kia_first(_char))+$3131)
    return false
}
if _char >= $AC00 && kia_third(_char) != 0
{
    if ds_list_find_index(kia_final_result,kia_third(_char)) != -1
    {
        kia_type = chr((kia_first(_char)*21+kia_second(_char))*28+ds_list_find_value(kia_final_base,ds_list_find_index(kia_final_result,kia_third(_char)))+$AC00)
        return false
    }
    kia_type = chr((kia_first(_char)*21+kia_second(_char))*28+$AC00)
    return false
}
return true
