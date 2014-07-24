#!/bin/bash
PROJECT=$1

case $1 in
	z4td|cp5dug)
		repo init -u ssh://10.33.8.6:29419/manifest.git -b htc -m jb-mr0-rel_shep_sprd8825_dsda_sense50.xml; repo sync
		;;
	*)
		;;
esac
