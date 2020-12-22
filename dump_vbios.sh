#!/bin/bash
# Script to dump GPU vbios from any Unraid GPU 
# by SpaceinvaderOne

##### FILL IN THE  VARIABLES BELOW #######################################################################

##### ID of GPU to dump vbios from #####
#  How to get id of the GPU
#  You can find the id of the gpu to dump from Unraid GUI in tools/system devices
#  For example if gpu was "[1002:67df] 0c:00.0 VGA compatible controller"
#  The number is after the bracketed id - ie for the above after [1002:67df] so the gpuid would be "0c:00.0"
gpuid="0e:00.0"

####### If the gpu is primary or the only GPU in the server then set below to "yes" (lowercase)
primarygpu="no"
		
#####Name the vbios for example gtx2080ti.rom	
vbiosname="gpuvbios.rom"

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

buildtempvm() {
cat > /tmp/dumpvbios.xml << EOF
<?xml version='1.0' encoding='UTF-8'?>
<domain type='kvm'>
<name>dumpvbios</name>
<memory unit='KiB'>1048576</memory>
<currentMemory unit='KiB'>1048576</currentMemory>
<memoryBacking>
<nosharepages/>
</memoryBacking>
<vcpu placement='static'>1</vcpu>
<cputune>
<vcpupin vcpu='0' cpuset='0'/>
</cputune>
<os>
<type arch='x86_64' machine='pc-q35-3.0'>hvm</type>
</os>
<cpu mode='host-passthrough' check='none' >
</cpu>
<on_poweroff>destroy</on_poweroff>
<on_reboot>restart</on_reboot>
<on_crash>restart</on_crash>
<devices>
<emulator>/usr/local/sbin/qemu</emulator>
<controller type='pci' index='1' model='pcie-root-port'>
<model name='pcie-root-port'/>
<target chassis='1' port='0x8'/>
</controller>
<hostdev mode='subsystem' type='pci' managed='yes' xvga='yes'>
<driver name='vfio'/>
<source>
<address domain='0x${dumpid:0:4}' bus='0x${dumpid:5:2}' slot='0x${dumpid:8:2}' function='0x${dumpid:11:1}'/>;
</source>
</hostdev>
</devices>
</domain>
EOF
}

isgpuprimary () {
	# Check Primary GPU and wether gpu has already been disconnected
	# Disconnect GPU and set server to sleep mode then rescan bus
	if [ "$primarygpu" = "yes" ] ; then	
			echo "disconnecting primary graphics card"
			echo "1" | tee -a /sys/bus/pci/devices/$disconnectid/remove
			echo "entered suspended (sleep) state"
			echo " PRESS POWER BUTTON ON SERVER TO CONTINUE"
			echo -n mem > /sys/power/state
			echo "rescanning pci bus"
			echo "1" | tee -a /sys/bus/pci/rescan
			echo "Primary graphics has now sucessfully been disconnected and reconnected"
			echo "It is ready to begin the dump vbios process"
			echo
			
	elif [ "$primarygpu" = "no" ] ; then			
			echo "This GPU is not primary so no need to disconnect and reconnect it"
			echo

	else 
			echo "primarygpu is set as "$primarygpu" this is not a recognised option"
			echo "Please set primarygpu to either yes or no "
	fi
}


startstopvm() {
	
	echo "Defining temp vm with gpu attached"
	virsh define /tmp/dumpvbios.xml 
	echo "Starting the temp vm to allow dump"
	virsh start dumpvbios
	echo "Waiting for a few seconds ....."
	echo
	sleep 9
	echo "Stopping the temp vm "
	virsh destroy dumpvbios
	echo "Removing the temp vm"
	virsh undefine dumpvbios

}

dumpvbios() {
	echo " Checking if GPU need unbinding ........"
	echo
	echo "$dumpid"  > /sys/bus/pci/drivers/vfio-pci/unbind || echo "Please ignore the above error. Didn't need to unbind GPU"
	cd /sys/bus/pci/devices/"$dumpid"/
	echo 1 > rom
	echo
	echo "Okay dumping vbios file named "$vbiosname" to the location "$vbioslocation" "
	cat rom > "$vbioslocation""$vbiosname" || echo "Something went wrong vbios not dumped correctly"
	echo 0 > rom
}

cleanup() {
	if [ -e /tmp/dumpvbios.xml ] ; then
		rm /tmp/dumpvbios.xml 
		echo
		echo "All done :)"
		exit
	else
		echo	
		echo "All done :)"
		exit
	fi
}

########## run functions #################################################################

checklocation
buildtempvm
isgpuprimary
startstopvm
dumpvbios
cleanup
exit