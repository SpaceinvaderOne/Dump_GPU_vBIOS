#!/bin/bash
# Script to dump GPU vbios from any Unraid GPU 
# by SpaceinvaderOne

##### FILL IN THE  VARIABLES BELOW #######################################################################

##### ID of GPU to dump vbios from #####
#  How to get id of the GPU
#  You can find the id of the gpu to dump from Unraid GUI in tools/system devices
#  For example if gpu was "[1002:67df] 0c:00.0 VGA compatible controller"
#  The number is after the bracketed id - ie for the above after [1002:67df] so the gpuid would be "0c:00.0"
gpuid="0c:00.0"

####### If the gpu is primary or the only GPU in the server then set below to "yes" (lowercase)
primarygpu="yes"
		
#####Name the vbios for example gtx2080ti.rom	
vbiosname="gpu.rom"

##### Location to put vbios (change if you dont want to use below location) if location doesnt exist it will be created for you.
vbioslocation="/mnt/user/isos/vbios/"

########## DO NOT CHANGE BELOW THIS LINE #################################################################
dumpid="0000:$gpuid"

disconnectid=$(echo "$dumpid" | sed 's?:?\\:?g')

########## Script functions #################################################################
checklocation() {
	# check if vbios location exists and if not create it
	echo "Checking if location to put vbios file exists"
		if [ ! -d "$vbioslocation" ] ; then
 
			echo "Vbios folder created at "$mountlocation" "
			mkdir -vp "$vbioslocation" # make the directory as it doesnt exist
		else
			echo "Vbios folder "$mountlocation" already exists"
		fi
}

isgpuprimary () {
	# Check Primary GPU and wether gpu has already been disconnected
	# Disconnect GPU and set server to sleep mode then rescan bus
	if [ "$primarygpu" = "yes" ] ; then	
		if  [ ! -e /tmp/disconnectedbefore ] ; then	
			echo "disconnecting primary graphics card"
			echo "1" | tee -a /sys/bus/pci/devices/$disconnectid/remove
			echo "entered suspended (sleep) state press power button on server to continue"
			touch /tmp/disconnectedbefore
			echo -n mem > /sys/power/state
			echo "rescanning pci bus"
			echo "1" | tee -a /sys/bus/pci/rescan
			echo "Primary graphics card almost ready"
			echo "You must start then force stop a vm with the gpu passed through to it"
			echo "It is normal for the screen to be blank when doing this"
			echo "This step is important without which the vbios cant be dumped"
			echo "After doing this please rerun this script to finish dumping the vbios"
			exit
		else 
			echo "Primary GPU has already been disconnected and reconnected"
			echo "Will now thry and dump vbios named "$vbiosname" to "$vbioslocation""
		fi
			
	elif [ "$primarygpu" = "no" ] ; then			
			echo "Will now try and dump vbios named "$vbiosname" to "$vbioslocation""

		else 
			echo "primarygpu is set as "$primarygpu" this is not a recognised option"
			echo "Please set primarygpu to either yes or no "
		fi
}

dumpvbios() {
	echo " Checking if GPU need unbinding"
	echo "$dumpid"  > /sys/bus/pci/drivers/vfio-pci/unbind || echo "Didn't need to unbind"
	cd /sys/bus/pci/devices/"$dumpid"/
	echo 1 > rom
	echo "okay dumping vbios to "$vbioslocation" file named "$vbiosname""
	at rom > "$vbioslocation""$vbiosname"
	echo 0 > rom
}

cleanup() {
	if [ -e /tmp/disconnectedbefore ] ; then
		rm /tmp/disconnectedbefore
		echo "All done"
		exit
	else	
		echo "All done"
		exit
	fi
}

########## run functions #################################################################

checklocation
isgpuprimary
dumpvbios
cleanup
exit
