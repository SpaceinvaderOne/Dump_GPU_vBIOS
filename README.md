## **DUMP_GPU_vBIOS**
**Script to dump the vBios from any GPU even if a primary GPU**

This script is designed to be used on an Unraid server (using the user scripts plugin) but could easily be adapted to run on any Linux based OS
The script will dump the vBios of any connected GPU. It will dump the vbios wether the GPU is primary sedondary or only GPU etc.

**How the script works.**
1. It will take take the id of a GPU, make a temporary seabios vm with the card attached, then quickly start and stop the vm with GPU passed through. This will put the GPU in the correct state to dump the vBios.
2. It will then delete the temporary vm as no longer needed.
3. It will dump the vbios of the card then check the size of the vbios. 
4. If the vbios looks correct it will finish the process and put the vbios in the location specified in the script (default /mnt/user/isos/vbios) 
5. However if the vbios looks incorrect and the vbios is under 70kb then it was probably dumped from a primary GPU. This is because the vbios was shadowed during the boot process and so the resulting vbios is a small file which is not correct. So the script will now disconnect the GPU then put the server to sleep. Next it will prompt you to press the power button to resume the server from its sleep state. Once server is woken the script will rescan the pci bus reconnecting the GPU. This now allows the primary gpu to be able to have the vbios dumped correctly. Script will then redump the vbios again putting the vbios in the loaction specified in the script (defualt /mnt/user/isos/vbios)


**Using the script.**

1. Copy the script from here onto your Unraid server as a userscript.
2. Run the script first without making any modifications.
3. Script will report an error saying  "That is NOT a valid PCI device. Please correct the id and rerun the script" as no GPU has been selected. It will list the GPUs in your server. From this list take the ID of the GPU from which you want to dump the vbios. For example "0c:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590]" the id is the first block of character ie 0c:00.0
4. Copy the id and edit the script variable gpuid="xx:xx.x"  removing the contents between the quotations replacing it with the ID for example gpuid="0c:00.0"
5. Give the vbios a name by replacing the contens of the variable vbiosname="gpu vbios.rom" to the name of your gpu etc.
  -- *note if no name is given then script will try and name the vbios based on the the info it finds from lspci*
6. optional - The default location of where the vbios will be dumped is in the isos share in a folder called vbios. You can change this by changing the variable vbioslocation="/mnt/user/isos/vbios/" to the location of your choosing.
7. Save changes and run the script.


**Notes about the script**

The script will put the server to sleep in order to reset a primary GPU in order for a sucessful dump. So your server must support sleep if you want to dump a primary GPU. For other non primary GPUs this is not necessary.

For best results power down server then start server (not reboot)  before using script. Make sure whilst running script no vms or containers are running.

There are some checks the script will make to check that you have in fact put in the id of the gpu and not some other hardware. However these checks can be disabled by changing the varaiable from safety="yes" to safety="no"

Changing the variable forcereset="no" to forcereset="yes" will make the script always forcereset the gpu before dumping vbios (if set to no it will only force reset if it thinks its dumping a primary gpu)
