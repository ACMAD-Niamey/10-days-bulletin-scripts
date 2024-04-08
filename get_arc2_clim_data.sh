#!/bin/bash
LANG=en_US.utf8 
unameout="$(uname -s)"

initday1=$1
initday2=$2

#
rm *.bin.*

echo $initday1 $initday2
clmdlydatadir="/home/phkt/CPC_WORK/DATA/arc2/CLIM/daily365"

ndays=$((initday2-initday1+1))

#------------------------------ getting the clim daily files ----------------------------------------------
echo "getting the $((initday2-initday1+1)) days ARC2 Clim data"
#

dy0=$initday1
dnum=0
while [ $dnum -lt $ndays ] 
    do

    if [ $unameout = "Darwin" ]; then
        dy1=`date -v ${dy0}d +%m%d`
    else
        dy1=`LC_ALL=en_US.utf8 date --date "-$dy0 day ago" "+%m%d"`
    fi
    
    ifile="${clmdlydatadir}/clim.bin.${dy1}"
    normalsize=2000
    actualsize=$(du -k ${ifile} | cut -f 1)
    if [ $actualsize -lt $normalsize ]; then rm -f ${ifile}; fi
    
    echo "downloading ARC2 clim file for" ${dy1}

    if [ ! -f "${clmdlydatadir}/clim.bin.${dy1}" ] ; then
        echo "***************** Retrieving " ${dy1} " data ****************************************************************"
        curl -O https://ftp.cpc.ncep.noaa.gov/fews/AFR_CLIM/ARC2/CLIMATOLOGY_DATA/DAILY_MEANS/clim.bin.${dy1}
    else
            echo "The target file is already on the local distant"
            ls -lrt ${clmdlydatadir}/clim.bin.${dy1}
    fi
    dy0=`bc <<< "$dy0+1"`
    dnum=`bc <<< "$dnum+1"`
done
mv *.bin.* ${clmdlydatadir}/.

#------------------------------ editing the control files ----------------------------------------------
if [ $unameout = "Darwin" ]; then
    dt1=`date -v ${initday1}d +%d%b%Y`
    opt="bk"
else
    dt1=`LC_ALL=en_US.utf8 date --date "-${initday1} day ago" "+%d%b%Y"`
fi

echo $dt1 $ndays

clmdlydatadir="${clmdlydatadir}/"
sed -e "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|$dt1|g;s|NNDAYS|$ndays|g" src_file/template_arc2_clim.ctl > arc2_clim.ctl 
