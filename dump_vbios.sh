#!/bin/bash
# Script to dump GPU vbios from any Unraid GPU 
# by SpaceinvaderOne

##### Read the readme for how to use this script #####

##### FILL IN THE  VARIABLES BELOW #######################################################################

###################
gpuid="xxxxxx"
###################
		
#####Name the vbios for example gtx2080ti.rom	

### Naming of the vbios is optional ....  if you do not rename it here then the script will name it based off the details found about the gpu dumped

###################
vbiosname="gpu vbios.rom"
###################

##### Location to put vbios (change if you dont want to use below location) if location doesnt exist it will be created for you.

###################
vbioslocation="/mnt/user/isos/vbios/"
###################

##### Runs checks on device to see if it is in fact a GPU. Recommended to leave set as "yes"

###################
safety="yes"
###################

########## DO NOT CHANGE BELOW THIS LINE #################################################################

gpuid=$(echo "$gpuid" | sed 's/ *$//')

gpuid=$(echo "$gpuid" | sed 's/^ *//g')

dumpid="0000:$gpuid"

mygpu=$(lspci -s $gpuid)

disconnectid=$(echo "$dumpid" | sed 's?:?\\:?g')

disconnectid2=$(echo "$disconnectid" | sed 's/\(.*\)0/\11/')

vganame=$( lspci | grep -i "$gpuid" )

forcereset="no"



########## Script functions #################################################################
checkgpuiscorrect() {
	mygpu=$(lspci -s $gpuid) || { notvalidpci; exit; } 
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

notvalidpci() {
	echo "That is NOT a valid PCI device. Please correct the id and rerun the script"
 	echo
 	echo "These are all the GPUs that I can see in your server. Please choose one of these"
 	lspci | grep -i 'vga'
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
	if [ "$forcereset" = "yes" ] ; then	
			echo "Disconnecting the graphics card"
			echo "1" | tee -a /sys/bus/pci/devices/$disconnectid/remove
			echo "Entered suspended (sleep) state ......"
			echo
			echo " PRESS POWER BUTTON ON SERVER TO CONTINUE"
			echo
			echo -n mem > /sys/power/state
			echo "Rescanning pci bus"
			echo "1" | tee -a /sys/bus/pci/rescan
			echo "Graphics card has now sucessfully been disconnected and reconnected"
			echo "It is now ready to begin the dump vbios process"
			echo
			
	elif [ "$forcereset" = "no" ] ; then			
			echo "I will try and dump the vbios without disconnecting and reconnecting the GPU"
			echo "This normally only works if the GPU is NOT the Primary or the only GPU"
			echo "I will check the vbios at the end. If it seems wrong I will then retry after disconnecting the GPU"
			echo

	else 
			echo "forcereset is set as "$forcereset" this is not a recognised option"
			echo "Please set forcereset to either yes or no "
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
	# if no name was given for vbios then make name from vga name from lspci
	if [ "$vbiosname" = "gpu vbios.rom" ] ; then
		vbiosname=$( echo "$vganame" |  awk 'NR > 1 {print $1}' RS='[' FS=']' )
	fi
	echo
	cd /sys/bus/pci/devices/"$dumpid"/ 
	echo 1 > rom
	echo
	echo "Okay dumping vbios file named "$vbiosname" to the location "$vbioslocation" "
	cat rom > "$vbioslocation""$vbiosname" || needtobind
	echo 0 > rom
}

needtobind() {
	echo
	echo "Um.... somethings gone wrong and I couldn't dump the vbios for some reason"
	echo "Sometimes when this happens all we need to do to fix this is 'stub' or 'bind to the vfio' the gpu and reboot the server"
	echo
	echo "This can be done in Unraid 6.8.3 with the use of the vfio config plugin or if you are on Unraid 6.9 or above it can be done"
	echo "directly from the gui in Tools/System Devices .....So please do this and run the script again"
	echo
	exit 
}


cleanup() {
	if [ -e /tmp/dumpvbios.xml ] ; then
		rm /tmp/dumpvbios.xml 
	fi
}


checkvbios() {
	filepath="$vbioslocation""$vbiosname"
	if [ -n "$(find "$filepath" -prune -size -2000c)" ]; then
		needtobind
	
	
	elif [ -n "$(find "$filepath" -prune -size -70000c)" ]; then
	    printf '%s is less than 70kb\n' "$filepath"
		echo "This seems too small. Probably the GPU is Primary and needs disconnecting and reconnecting to get proper vbios"
		echo
		echo "Running again"
		forcereset="yes"
		buildtempvm
		isgpuprimary
		startstopvm
		dumpvbios
		cleanup
		if [ -n "$(find "$filepath" -prune -size -70000c)" ]; then
		    printf '%s is less than 70kb\n' "$filepath"
			echo "This seems small but maybe its correct. Please try it. All done !"
			exit
		fi
		echo
		echo "vbios seems to be correct. All done :)"
		exit
		
	else
	echo
	echo "vbios seems to be correct. All done :)"
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
checkvbios
exit
