#!/bin/bash

echo -e "==========================="
echo -e "= START COMPILING KERNEL  ="
echo -e "==========================="
bold=$(tput bold)
normal=$(tput sgr0)

# Scrip option
while (( ${#} )); do
    case ${1} in
        "-Z"|"--zip") ZIP=true ;;
    esac
    shift
done
[[ -z ${ZIP} ]] && { echo "${bold}LOADING-_-....${normal}"; }

# Inherit kernelsu next
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy

export KBUILD_BUILD_USER="rizky-maulana-builder"
export TZ=Asia/Jakarta
#export KBUILD_BUILD_VERSION=186
#export KBUILD_BUILD_TIMESTAMP="Fri Dec 26 08:43:17 WIB 2025"
export KBUILD_BUILD_HOST="pangu-build-component-system-906899-cv5m1-jpcp4-8wrc6"
export KERNELDIR="$(pwd)"
export KERNELNAME="Karbit"
export SRCDIR="${KERNELDIR}"
export OUTDIR="${KERNELDIR}/out"
export ANYKERNEL="${KERNELDIR}/AnyKernel3"
export DEFCONFIG="stone_defconfig"
export ZIP_DIR="${KERNELDIR}/files"
export IMAGE="${OUTDIR}/arch/arm64/boot/Image"
export VARI="AOSP"
#export DTBO="${OUTDIR}/arch/arm64/boot/dtbo.img"
export PATH="$(pwd)/clang/bin:$PATH"

if [[ $1 = "-r" || $1 = "--regen" ]]; then
make O=out ARCH=arm64 $DEFCONFIG savedefconfig
cp out/defconfig arch/arm64/configs/$DEFCONFIG
exit
fi

if [[ $1 = "-c" || $1 = "--clean" ]]; then
rm -rf out
fi

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG
make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld HOSTCC=clang HOSTCXX=clang++ READELF=llvm-readelf HOSTAR=llvm-ar AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt
    echo -e "==========================="
    echo -e "   COMPILE KERNEL COMPLETE "
    echo -e "==========================="

# Make ZIP using AnyKernel
# ================
export ZIPNAME="${KERNELNAME}-Kernel-stone-${VARI}-$(date +%Y%m%d-%H%M%S).zip";
export FINAL_ZIP="${ZIP_DIR}/${ZIPNAME}";
rm -rf ${ZIP_DIR};
mkdir ${ZIP_DIR};
echo -e "Copying kernel image";
cp -rf -v "${IMAGE}" "${ANYKERNEL}/";
#cp -rf -v "${DTBO}" "${ANYKERNEL}/";
cd ${KERNELDIR};
cd ${ANYKERNEL};
zip -r9 ${FINAL_ZIP} *;
curl -LSs "https://raw.githubusercontent.com/lordgaruda/GoFile-Upload/master/upload.sh" | bash -s ${FINAL_ZIP};
cd ${KERNELDIR};
rm -rf "${ANYKERNEL}/Image";

if [[ ":v" ]]; then
exit
fi
