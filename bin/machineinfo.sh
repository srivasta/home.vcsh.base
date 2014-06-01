#                               -*- Mode: Sh -*- 
# machineinfo.sh --- 
# Author           : Manoj Srivastava ( srivasta@anzu.internal.golden-gryphon.com ) 
# Created On       : Thu Mar 27 14:16:49 2008
# Created On Node  : anzu.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Thu Mar 27 14:32:22 2008
# Last Machine Used: anzu.internal.golden-gryphon.com
# Update Count     : 3
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

# displays info about your processor
cat /proc/cpuinfo   > cpuinfo.log 2>&1

# displays info about your memory
cat /proc/meminfo   > meminfo.log 2>&1 

# displays memory usage
free -m  -t         > memusage.log 2>&1 

# dump DMI table contents
dmidecode           > dmi_table.log 2>&1 

# to see how much ram is installed 
ls -al /proc/kcore  > ram.log       2>&1

# displays disk usage information
df -h               > diskusage.log 2>&1

# displays all devices connected to your PCI bus
lspci -vv           > pci_dev.log   2>&1

# displays all devices connected to your USB bus
lsusb -vv           > usb_dev.log   2>&1

# list hardware
lshw                > hardware.log  2>&1

#############################################################################
# fdisk -l  -- displays all disks/partitions that your computer knows about #
# lshw-gtk                                                                  #
# /proc/ide       -- to see the detected IDE drives                         #
# /proc/bus/scsi  -- to see the identified scsi systems                     #
# /proc/sys/dev/cdrom/info -- to see capabilities of CD drives.             #
#############################################################################
