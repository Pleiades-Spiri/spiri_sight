#!/bin/bash
exposure=0
gain=0
data=0
READGAINCTRL=""
READEXPOSURECTRL=""
WRITEGAINCTRL=""
WRITEEXPOSURECTRL=""
MAXMINCTRL=""
DEVICE=""
CONFIGFILE=""
HELP=""

for i in "$@"
do

HELP=`echo $i | grep -wo "\--h"`
READGAINCTRL=`echo $i | grep -wo "\-rg"`
READEXPOSURECTRL=`echo $i | grep -wo "\-re"`
MAXMINCTRL=`echo $i | grep -wo "\-mm"`
LOWLIGHTCOND=`echo $i | grep -wo "\-llc"`
HIGHLIGHTCOND=`echo $i | grep -wo "\-hlc"`

case $i in
    -rg=*|--readgain=*)
    READGAINCTRL="${i#*=}"
    shift # past argument=value
    ;;
    -re=*|--readexposure=*)
    READEXPOSURECTRL="${i#*=}"
    shift # past argument=value
    ;;
    -wg=*|--writegain=*)
    WRITEGAINCTRL="${i#*=}"
    shift # past argument=value
    ;;
    -we=*|--writeexposure=*)
    WRITEEXPOSURECTRL="${i#*=}"
    shift # past argument=value
    ;;
    -mm=*|--maxminctrls=*)
    MAXMINCTRL="${i#*=}"
    shift # past argument=value
    ;;
    -llc=*|--lightcondlow=*)
    LOWLIGHTCOND="${i#*=}"
    shift # past argument=value
    ;;
    -hlc=*|--lightcondhigh=*)
    HIGHLIGHTCOND="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--device=*)
    DEVICE="${i#*=}"
    shift # past argument=value
    ;;
    --h*|--help*)
    HELP="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done

read_gain(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		v4l2-ctl -d "/dev/video$DEVICE" -C  gain
	fi
}

read_exposure(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		v4l2-ctl -d "/dev/video$DEVICE" -C coarse_time 
	fi
}
	
write_gain(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		gain=$WRITEGAINCTRL
		v4l2-ctl -d "/dev/video$DEVICE" -c  gain=$gain
	fi
}

write_exposure(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		exposure=$WRITEEXPOSURECTRL
		v4l2-ctl -d "/dev/video$DEVICE" -c coarse_time=$exposure 
	fi
}

min_and_max_ctrls(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		v4l2-ctl -d "/dev/video$DEVICE" -l | grep -w gain 
		v4l2-ctl -d "/dev/video$DEVICE" -l | grep -w coarse_time
	fi
}

low_light_cond(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		v4l2-ctl -d "/dev/video$DEVICE" -c gain=520 
		v4l2-ctl -d "/dev/video$DEVICE" -c coarse_time=667 
	fi
}

high_light_cond(){
	if [ "$DEVICE" == "" ]
	then
		echo "Device needed"
	else
		v4l2-ctl -d "/dev/video$DEVICE" -c gain=66 
		v4l2-ctl -d "/dev/video$DEVICE" -c coarse_time=260
	fi
}

help(){
echo "***************************************************************************************************************************"
echo "*                                 ______  _      _____  _____   ___  ______  _____  _____                                 *"
echo "*                                 | ___ \| |    |  ___||_   _| / _ \ |  _  \|  ___|/  ___|                                *"
echo "*                                 | |_/ /| |    | |__    | |  / /_\ \| | | || |__  \  \__                                 *"
echo "*                                 |  __/ | |    |  __|   | |  |  _  || | | ||  __|  \___ \                                *"
echo "*                                 | |    | |____| |___  _| |_ | | | || |/ / | |___ ____/ /                                *"
echo "*                                 \_|    \_____/\____/  \___/ \_| |_/|___/  \____/ \____/                                 *"
echo "*                                                                                                                         *"
echo "*********************************************  controls-utility Instructions **********************************************"
echo "*                                                                                                                         *"
echo "*             - Controls values: Display the maximum, minimum, actual and default value of the gain and exposure.         *"
echo "*                                 Use -mm and set the device.                                                             *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -mm                                                *" 
echo "*                                                                                                                         *" 
echo "*             - Read gain value: Use the argument \"-rg\", and the device to read current gain value                        *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -rg                                                *"
echo "*                                                                                                                         *" 
echo "*             - Read exposure value: Use the argument \"-re\", and the device to read current exposure value                *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -re                                                *"
echo "*                                                                                                                         *"
echo "*             - Write gain value: Use the argument \"-wg\", and the device to write the gain desired                        *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -wg=\"200\"                                          *" 
echo "*                                                                                                                         *"
echo "*             - Write exposure value: Use the argument \"-we\", and the device to write the gain desired                    *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -we=\"200\"                                          *" 
echo "*                                                                                                                         *"
echo "*             - Low light conditions: Use the argument \"-llc\", and the device                                             *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -llc                                               *" 
echo "*                                                                                                                         *"
echo "*             - High light conditions: Use the argument \"-hlc\", and the device                                            *"
echo "*                                example: ./controls-utility.sh -d=\"0\" -hlc                                               *" 
echo "*                                                                                                                         *"
echo "*             - Help instructions: Use the argument \"--h\"                                                                 *"
echo "*                                example: ./controls-utility.sh --h                                                       *"
echo "*                                                                                                                         *" 
echo "***************************************************************************************************************************"
}

if [ "$READGAINCTRL" != "" ]
	then
	read_gain
fi
if [ "$READEXPOSURECTRL" != "" ]
	then
	read_exposure
fi
if [ "$WRITEGAINCTRL" != "" ]
	then
	write_gain
fi
if [ "$WRITEEXPOSURECTRL" != "" ]
	then
	write_exposure
fi
if [ "$LOWLIGHTCOND" != "" ]
	then
	low_light_cond
fi
if [ "$HIGHLIGHTCOND" != "" ]
	then
	high_light_cond
fi
if [ "$MAXMINCTRL" != "" ]
	then
	min_and_max_ctrls
fi
if [ "$HELP" != "" ]
	then
	help
fi
