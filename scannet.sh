 #!bin/bash
 if ["$1" == "" ]
 then
 echo "specify IP address"

else
 for x in  `seq 1 254`; do
 ping $1.$x -c 1 | grep "64 byte" | cut -d " " -f 4 | tr -d ":" & 
 done 
fi