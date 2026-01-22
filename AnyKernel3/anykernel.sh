# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Karbit kernel by RizkyMaulana for AOSP New
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=moonstone
device.name2=sunstone
device.name3=stone
device.name4=gemstone
device.name5=miholi
supported.versions=
supported.patchlevels=
'; } # end properties

### AnyKernel install
# boot shell variables
block=boot;
is_slot_device=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
split_boot;
flash_boot;
## end boot install
