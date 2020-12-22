

gpuid="0e:00.0"
dumpid="0000:$gpuid"





build1=$(echo "$dumpid" | sed "s?0000?<address domain='0x0000'?") 
build2=$(echo "$build1" | sed "s?:? bus='0x?") 
build3=$(echo "$build2" | sed "s?:?' slot='0x?")
build4=$(echo "$build3" | sed "s?\.?' function='0x?")
address=$(echo "$build4" | sed  "s?.*?&'/>?") 
echo $address




