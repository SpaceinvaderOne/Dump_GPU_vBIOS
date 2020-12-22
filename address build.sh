#!/bin/bash
#test to convert id to xml address (not working in userscripts)
id="0000:0e:00.0"
addressid=$(echo "<address domain='0x${id:0:4}' bus='0x${id:5:2}' slot='0x${id:8:2}' function='0x${id:11:1}'/>")
echo $addressid
exit

