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

##### Runs checks on device to see if it is in fact a GPU. Recommended to leave set as "yes"
safety="yes"

########## DO NOT CHANGE BELOW THIS LINE #################################################################
dumpid="0000:$gpuid"

mygpu=$(lspci -s $gpuid)

disconnectid=$(echo "$dumpid" | sed 's?:?\\:?g')



########## Script functions #################################################################
checkgpuiscorrect() {
	mygpu=$(lspci -s $gpuid) || echo "That is NOT a valid PCI device. Please correct the id and rerun the script" 
	echo "You have selected this device to dump the vbios from"
	if grep -i 'VGA compatible controller' <<< "$mygpu"  ; then 
		if grep -i 'Intel' <<< "$mygpu"  ; then 
			echo "This looks like its an integrated INTEL GPU and vbios dump will most likely FAIL"
			echo "Please select a dedicated GPU to dump vbios from"
			echo "If you really want to try then rerun script changing variable to safety=off"
		else
			echo
			echo "This does look like a valid GPU to me. Continuing ........."
			echo
		fi
	elif  grep -i 'Audio Device' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like an AUDIO device"
	echo "Maybe you have selected the audio part of your GPU ?"
	echo "Please edit the script and make sure to put the id of ONLY the VGA part of your GPU"
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are all the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'USB controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a USB controller"
	echo "Some GPUs have a USB part to them. Maybe you selected that ?"
	echo "Please edit the script and make sure to put the id of ONLY the VGA part of your GPU"
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Serial bus controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a USB type C controller"
	echo "Some GPUs have a USB type C part to them. Maybe you selected that ?"
	echo "Please edit the script and make sure to put the id of ONLY the VGA part of your GPU"
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Network controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a NETWORK adapter "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Ethernet controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a NETWORK adapter "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'SATA controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a SATA controller "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Non-Volatile memory controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a NVME controller "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'PCI bridge' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a PCI bridge "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Host bridge' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a HOST bridge "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'SMBus' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a SMBus controller "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	elif  grep -i 'Encryption controller' <<< "$mygpu"  ; then 
	echo
	echo "This doesn't look like a GPU to me. It looks like a Encryption controller "
	echo "Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	else
	echo "$mygpu"
	echo
	echo "This doesn't look like a GPU to me. Please correct the id and rerun the script."
	echo "If you are 100 % sure this is the VGA part of your GPU then rerun script changing variable to safety=off"
	echo
	echo "These are the GPUs that I can see in your server"
	lspci | grep -i 'vga'
	exit
	fi
	
}


checklocation() {
	# check if vbios location exists and if not create it
	echo
	echo "Checking if location to put vbios file exists"
		if [ ! -d "$vbioslocation" ] ; then
 
			echo "Vbios folder created at "$mountlocation" "
			echo
			mkdir -vp "$vbioslocation" # make the directory as it doesnt exist
		else
			echo "Vbios folder "$mountlocation" already exists"
			echo
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
			echo "entered suspended (sleep) state ......"
			echo
			echo " PRESS POWER BUTTON ON SERVER TO CONTINUE"
			echo
			echo -n mem > /sys/power/state
			echo "rescanning pci bus"
			echo "1" | tee -a /sys/bus/pci/rescan
			echo "Primary graphics has now sucessfully been disconnected and reconnected"
			echo "It is ready to begin the dump vbios process"
			echo
			
	elif [ "$primarygpu" = "no" ] ; then			
			echo "This GPU is NOT set as Primary GPU so no need to disconnect and reconnect it"
			echo "*note* If the GPU is the Primary or only GPU in your server you will need to change this in the script otherwise the vbios dump will not be good. "
			echo "       If this is NOT a Primary GPU then vbios will be fine"
			echo

	else 
			echo "primarygpu is set as "$primarygpu" this is not a recognised option"
			echo "Please set primarygpu to either yes or no "
			exit
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
if [ "$safety" = "no" ] ; then	
echo "Safety checks are disabled. Continuing ......"
else
checkgpuiscorrect
fi
checklocation
buildtempvm
isgpuprimary
startstopvm
dumpvbios
cleanup
exit