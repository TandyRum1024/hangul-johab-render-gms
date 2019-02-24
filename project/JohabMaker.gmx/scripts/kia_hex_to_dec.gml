///kia_hex_to_dec(string)
var str = string_upper(argument[0])
var result = 0
for(var i = 0; i <= string_length(argument[0]); i++)
{
    var char = ord(string_char_at(str, i))
    result = result << 4
    if char >= 48 && char <= 57
        result += (char - 48)
    else if char >= 65 && char <= 70
        result += (char - 55)
}
return result
