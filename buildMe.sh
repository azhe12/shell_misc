#!/bin/bash
#set -x
PROGRAM=$(basename $0)
ERROR_CODE=0
flag_repo=0
flag_setup_env=0
flag_build=0
time_now()
{
	echo -n $(date '+%s')
}

repo_code()
{
	case $1 in
		z4td|cp5dtg|cp5dug|cp5dtu|cp5dwg)
			repo init -u ssh://azhe_liu@10.33.8.6:29419/manifest.git -b htc -m jb-mr0-rel_shep_sprd8825_dsda_sense50.xml; repo sync
			;;
		google)
			repo init -u https://android.googlesource.com/platform/manifest -b android-4.3_r2.1;repo sync
			test $? = 0 && git clone https://android.googlesource.com/kernel/goldfish.git
			;;
        m7)
            repo init -u https://android.googlesource.com/platform/manifest -b htc -m kk-rel_shep_qct8064_qca_dsda_sense55_crc.xml;repo sync
            ;;
        dlx)
            repo init -u ssh://azhe_liu@10.33.8.6:29419/manifest.git -b htc -m jb-mr1.1-rel_shep_qct8064_dsda_dlxplusc-crc.xml;repo sync
            ;;
        gaia_dlx)
            repo init -u ssh://azhe_liu@10.33.8.6:29419/manifest.git -b htc -m gaia_shep_qct8064_dsda-crc_dlxplus-dwg-dtu-cos.xml;repo sync
            ;;
        gaia_shark)
            repo init -u ssh://10.33.8.6:29417/manifests.git -b htc -m gaia_shep_sprd8825_dsda_porting.xml;repo sync
            ;;
        a5)
            repo init -u ssh://azhe_liu@10.33.8.6:29419/manifest.git -b htc -m kk-mr1-rel_shep_qct-b_qca_dualsim_sense55.xml;repo sync
            ;;
		*)
			warning "unrecognize project $1"
			;;
	esac
}

setup_env()
{
	case $1 in
		cp5dug)
			export HTCFW_ENABLED=true; export HTC_BUILD_STUBS_FLAG=true; source build/envsetup.sh ; partner_setup cp5dug CP5DUG_Generic_WWE_DEBUG 
			;;
		cp5dtu)
			export HTCFW_ENABLED=true; export HTC_BUILD_STUBS_FLAG=true; source build/envsetup.sh ; partner_setup cp5dtu CP5DTU_Generic_WWE_DEBUG
			;;
		cp5dwg)
			export HTCFW_ENABLED=true; export HTC_BUILD_STUBS_FLAG=true; source build/envsetup.sh ; partner_setup cp5dwg CP5DWG_Generic_WWE_DEBUG
			;;
		z4td)
			export HTCFW_ENABLED=true; export HTC_BUILD_STUBS_FLAG=true; source build/envsetup.sh ; partner_setup z4td Z4TD_Generic_WWE_DEBUG
			;;
		csnu)
			export HTCFW_ENABLED=true; source build/envsetup.sh ; partner_setup htc_csnu CsnU_Generic_WWE_DEBUG ; partner_setup htc_csnu CsnU_CHT_WWE_DEBUG
			;;
		google)
			source build/envsetup.sh ;lunch full-eng
			;;
        dlx)
            export HTCFW_ENABLED=true; source build/envsetup.sh ; partner_setup dlpdwg DlpDWG_Generic_WWE_DEBUG ; partner_setup dlpdwg DlpDWG_CT_CHS_DEBUG 
            ;;
        gaia_dlx)
            export HTCFW_ENABLED=true; source build/envsetup.sh ; choosecombo 1 dlpdwg userdebug DEBUG
            ;;
        gaia_shark)
            export HTCFW_ENABLED=true; source build/envsetup.sh ; choosecombo 1 cp5dug userdebug DEBUG
            ;;
        a5dug)
            export HTCFW_ENABLED=true; source build/envsetup.sh ;  partner_setup htc_a5dug A5DUG_Generic_WWE_DEBUG ; 
            ;;
        a5ul)
            source build/envsetup.sh; partner_setup htc_a5ul A5UL_Generic_WWE_DEBUG
            ;;
        a3qhdul)
            export HTCFW_ENABLED=true; source build/envsetup.sh; partner_setup htc_a3qhdul A3QHDUL_Generic_WWE_DEBUG; 
            ;;
		*)
			warning "unrecognize project $1"
			;;
	esac
}
build()
{
	case $1 in
			cp5dug)
				setup_env cp5dug;make -j4 PRODUCT-cp5dug-userdebug
				;;
			cp5dtu)
				setup_env cp5dtu;make -j4 PRODUCT-cp5dtu-userdebug
				;;
			cp5dwg)
				setup_env cp5dwg;make -j4 PRODUCT-cp5dwg-userdebug
				;;
			z4td)
				setup_env z4td;make -j4 PRODUCT-z4td-userdebug
				;;
			google)
				setup_env google;make -j4
				;;
			csnu)
				setup_env csnu;make -j4 PRODUCT-htc_csnu-userdebug
				;;
            dlx)
                setup_env dlx; make -j4
                ;;
            gaia_dlx)
                setup_env gaia_dlx; make -j4
                ;;
            gaia_shark)
                setup_env gaia_shark; make -j4
                ;;
            a5dug)
                setup_env a5dug; make -j4 PRODUCT-htc_a5dug-userdebug
                ;;
            a5ul)
                setup_env a5ul;make -j4 PRODUCT-htc_a5ul-userdebug
                ;;
            a3qhdul)
                setup_env a3qhdul;make -j4 PRODUCT-htc_a3qhdul-userdebug
                ;;
			*)
				warning "unrecognize project $1"
				;;
	esac
}

usage()
{
	cat <<EOT 1>&2
		Usage: $PROGRAM [--repo|--setup|--build|--help] project
EOT
}

usage_exit()
{
	usage
	((ERROR_CODE+=1))
}
warning()
{
	echo $@ 1>&2
	((ERROR_CODE+=1))
}
START_TIME=$(time_now)

test $# -lt 2 && usage

for arg in $@
do
	case $arg in
		--help)
			usage
			;;
		--repo)
			flag_repo=1
			shift
			;;
		--setup)
			flag_setup_env=1
			shift
			;;
		--build)
			flag_build=1
			shift
			;;
		--*)
			warning "unknow agrument"
			usage_exit;
			;;
		*)
			break
	esac
done
test $ERROR_CODE = 0 && test $# != 1 && warning "support only project at same time"

PROJECT=$@
test $ERROR_CODE = 0 && test $flag_repo = 1 && repo_code $PROJECT
test $ERROR_CODE = 0 && test $flag_setup_env = 1 && setup_env $PROJECT
test $ERROR_CODE = 0 && test $flag_build = 1 && build $PROJECT
ELAPSE_TIME=$(($(time_now) - $START_TIME))

echo "\
/*************************** \
Done! Elipse:  $(($ELAPSE_TIME / 60))m $(($ELAPSE_TIME % 60))s \
****************************/"
#set +x
