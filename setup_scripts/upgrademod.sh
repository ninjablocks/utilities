#!/bin/bash


if [[ shasum /lib/modules/`uname -r`/kernel/drivers/net/wireless/8192cu.ko != "4074aa90269a4cc0ad136a7dc93ef4b3fc65a2d3" ]] 
then
	echo "need to upgrade module"
fi