## **DUMP_GPU_VBIOS**
Script to dump the vbios from any GPU even if primary gpu on an Unraid Server

This script is designed to be used on an Unraid server (using the user scripts plugin) but could easily be adapted to run on any Linux based OS
The script will dump the vbios of any connected GPU. It will dump the vbios wether the gpu is primary sedondary or only etc.

How the script works.
1. It will take take the id of a gpu, make a temporary seabios vm with the card attached, then quickly start and stop the vm with gpu passed through. This will put the GPU in the correct state to dump the vbios.
2. It will then delte the temporary vm as no longer needed.
3. It will dump the vbios of the card then check the size of the vbios. 
a. If the vbios looks correct it will finish the process and put the vbios  in the loaction specified in the script (defualt /mnt/user/isos/vbios) 
     b. However if the vbios looks incorrect and the vbios is under 70kb then it was probably dumped from a primary gpu and the vbios was shadowed resulting in an incorrect small file. So the script will now disconnect the gpu then put the server to sleep, prompting you to press the power button to resume the server from its sleep state. Once server is woken the script will rescan the pci bus connecting the GPU. This now allows the primary gpu to be able to have the vbios dumped correctly. Script will then redump the vbios again putting the vbios in the loaction specified in the script (defualt /mnt/user/isos/vbios)

