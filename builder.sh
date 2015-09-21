#!/bin/bash

BUILDFOR=$1
##barrier_breaker or chaos_calmer
PATH_MAIN=/vm/1/openwrt
CONFIGS=/vm/1/openwrt/OpenWRT-Softether-builder/openwrt_configs
PACKAGES=/vm/1/openwrt/packs/$BUILDFOR/
BUILDROOT=/vm/1/openwrt/$BUILDFOR
MAKEFILE=/tmp/OpenWRT-package-softether/softethervpn/Makefile
UPDATEMAKEFILE=/vm/1/openwrt/OpenWRT-Softether-builder/update_makefile.py
CORES=3

cleaner (){
	rm -rf $BUILDROOT
}

construct_mips(){
	cd $PATH_MAIN
	svn co svn://svn.openwrt.org/openwrt/branches/$BUILDFOR
	cd $BUILDFOR
	echo "src-cpy softethervpn /tmp/OpenWRT-package-softether" >> feeds.conf.default
	./scripts/feeds update
	./scripts/feeds install softethervpn
}

get_ipk(){
	cd $PATH_MAIN/$BUILDROOT
	make prepare -j$CORES
	make package/softethervpn/compile V=99 -j$CORES
	find $BUILDROOT -name "softether*.ipk" -type f -exec /bin/mv {} $PACKAGES/ \;
}



cd $PATH_MAIN

git clone https://github.com/Alberts00/OpenWRT-package-softether /tmp/OpenWRT-package-softether
python3 $UPDATEMAKEFILE $MAKEFILE

construct_mips
cp $CONFIGS/$BUILDFOR/.config_ar71xx $BUILDROOT/$BUILDFOR/.config
get_ipk



cp $CONFIGS/$BUILDFOR/.config_atheros $BUILDROOT/$BUILDFOR/.config
get_ipk


cp $CONFIGS/$BUILDFOR/.config_brcm47xx $BUILDROOT/$BUILDFOR/.config
get_ipk


cp $CONFIGS/$BUILDFOR/.config_brcm63xx $BUILDROOT/$BUILDFOR/.config
get_ipk


cp $CONFIGS/$BUILDFOR/.config_ramips_24ksec $BUILDROOT/$BUILDFOR/.config
get_ipk
cleaner

rm -rf /tmp/OpenWRT-package-softether

