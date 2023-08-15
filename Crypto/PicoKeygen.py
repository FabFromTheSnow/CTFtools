import hashlib

key_part_static1_trial = "picoCTF{1n_7h3_|<3y_of_"
key_part_static2_trial = "}"

oui = "GOUGH"
a = hashlib.sha256(oui.encode()).hexdigest()

key_part_dynamic1_trial = a[4] + a[5] + a[3] + a[6] + a[2] + a[7] + a[1] + a[8]

flag = key_part_static1_trial + key_part_dynamic1_trial + key_part_static2_trial
print(flag)
