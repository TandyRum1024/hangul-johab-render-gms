///kia_input(input)
var _char = ord(kia_type)
var _result = ""
if argument0 < 0 || argument0 > 25 {return ""}
if ds_list_find_value(kia_conso,argument0) // consonant
{
    if kia_type = ""
    {
        var _input = ds_list_find_value(kia_uc,argument0)
        if keyboard_check(vk_shift) && (_input = 0 || _input = 6 || _input = 17 || _input = 20 || _input = 23) { _input++ }
        kia_type = chr($3131+_input)
        return ""
    }
    else
    {
        if _char >= $3131 && _char < $314F // c
        {
            var _input = ds_list_find_value(kia_uc,argument0)
            var _origin = _char - $3131
            if ds_list_find_index(kia_uc_base,_origin) != -1
            {
                for(i=ds_list_find_index(kia_uc_base,_origin);i<ds_list_size(kia_uc_base);i++)
                {
                    if _origin = ds_list_find_value(kia_uc_base,i) && _input = ds_list_find_value(kia_uc_add,i)
                    {
                        _origin = ds_list_find_value(kia_uc_result,i)
                        kia_type = chr($3131 + _origin)
                        return ""
                    }
                }
            }
            return kia_recursive(argument0)
        }
        if _char >= $314F && _char <= $3163 // v
        {
            _result = kia_type
            kia_type = ""
            kia_input(argument0)
            return _result
        }
        if _char >= $AC00 && kia_third(_char) = 0 // c+v
        {
            var _input = ds_list_find_value(kia_fc,argument0)
            if keyboard_check(vk_shift)
            {
                if _input = 1 || _input = 19 { _input++ }
                if _input = 7 || _input = 17 || _input = 22 { return kia_recursive(argument0) }
            }
            kia_type = chr((kia_first(_char)*21+kia_second(_char))*28+_input+$AC00)
            return ""
        }
        if _char >= $AC00 && kia_third(_char) != 0 // c+v+c
        {
            var _input = ds_list_find_value(kia_fc,argument0)
            var _origin = kia_third(_char)
            if keyboard_check(vk_shift)
            {
                if _input = 1 || _input = 19 { _input++ }
                if _input = 17 || _input = 22 { return kia_recursive(argument0) }
            }
            if ds_list_find_index(kia_final_base,_origin) != -1
            {
                for(i=ds_list_find_index(kia_final_base,_origin);i<ds_list_size(kia_final_base);i++)
                {
                    if _origin = ds_list_find_value(kia_final_base,i) && _input = ds_list_find_value(kia_final_add,i)
                    {
                        _origin = ds_list_find_value(kia_final_result,i)
                        kia_type = chr((kia_first(_char)*21+kia_second(_char))*28+_origin+$AC00)
                        return ""
                    }
                }
            }
            return kia_recursive(argument0)
        }
    }
}
else // vowel
{
    if kia_type = ""
    {
        var _input = ds_list_find_value(kia_uc,argument0)
        if keyboard_check(vk_shift) && (_input = 1 || _input = 5) { _input += 2 }
        kia_type = chr($314F+_input)
    }
    else
    {
        if _char >= $3131 && _char < $314F // c
        {
            if ds_list_find_index(kia_first_convert,_char-$3131) != -1
            {
                var _input = ds_list_find_value(kia_c,argument0)
                if keyboard_check(vk_shift) && (_input = 1 || _input = 5) { _input += 2 }
                kia_type = chr((ds_list_find_index(kia_first_convert,_char-$3131)*21+_input)*28+$AC00)
            }
            var _find = ds_list_find_index(kia_uc_result,_char-$3131)
            if _find != -1
            {
                var _result = chr(kia_uc_base[|_find]+$3131)
                kia_type = chr(kia_uc_add[|_find]+$3131)
                kia_input(argument0)
                return _result
            }
        }
        if _char >= $314F && _char <= $3163 // v
        {
            var _input = ds_list_find_value(kia_uc,argument0)
            var _origin = _char - $314F
            if ds_list_find_index(kia_vowel_base,_origin) != -1
            {
                for(i=ds_list_find_index(kia_vowel_base,_origin);i<ds_list_size(kia_vowel_base);i++)
                {
                    if _origin = ds_list_find_value(kia_vowel_base,i) && _input = ds_list_find_value(kia_vowel_add,i)
                    {
                        _origin = ds_list_find_value(kia_vowel_result,i)
                        kia_type = chr($314F+_origin)
                        return ""
                    }
                }
            }
            return kia_recursive(argument0)
        }
        if _char >= $AC00 && kia_third(_char) = 0 // c+v
        {
            var _input = ds_list_find_value(kia_c,argument0)
            var _origin = kia_second(_char)
            if ds_list_find_index(kia_vowel_base,_origin) != -1
            {
                for(i=ds_list_find_index(kia_vowel_base,_origin);i<ds_list_size(kia_vowel_base);i++)
                {
                    if _origin = ds_list_find_value(kia_vowel_base,i) && _input = ds_list_find_value(kia_vowel_add,i)
                    {
                        _origin = ds_list_find_value(kia_vowel_result,i)
                        kia_type = chr((kia_first(_char) * 21 + _origin ) * 28 + $AC00)
                        return ""
                    }
                }
            }
            return kia_recursive(argument0)
        }
        if _char >= $AC00 && kia_third(_char) != 0 // c+v+c
        {
            var _input = ds_list_find_value(kia_c,argument0)
            if keyboard_check(vk_shift) && (_input = 1 || _input = 5) { _input += 2 }
            if ds_list_find_index(kia_final_result,kia_third(_char)) != -1
            {
                _result = chr((kia_first(_char)*21+kia_second(_char))*28+ds_list_find_value(kia_final_base,ds_list_find_index(kia_final_result,kia_third(_char)))+$AC00)
                kia_type = chr((ds_list_find_value(kia_final_convert,kia_third(_char))*21+_input)*28+$AC00)
                return _result
            }
            else
            {
                _result = chr((kia_first(_char)*21+kia_second(_char))*28+$AC00)
                kia_type = chr((ds_list_find_value(kia_final_convert,kia_third(_char))*21+_input)*28+$AC00)
                return _result
            }
        }
    }
}
return _result
