#enc ''.join([chr((ord(flag[i]) << 8) + ord(flag[i + 1])) for i in range(0, len(flag), 2)])
encrypted_string = "灩捯䍔䙻ㄶ形楴獟楮獴㌴摟潦弸弲㘶㠴挲ぽ"

decrypted_chars = []

for char in encrypted_string:
    code_point = ord(char)
    
    high_byte = (code_point >> 8) & 0xFF
    low_byte = code_point & 0xFF
    
    decrypted_chars.append(chr(high_byte))
    decrypted_chars.append(chr(low_byte))

decrypted_string = ''.join(decrypted_chars)
print(decrypted_string)
