#!/bin/bash
LANG=en_US.utf8 
unameout="$(uname -s)"

initday1=$1
initday2=$2

#
rm PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.*

echo $initday1 $initday2

clmdlydatadir="DATA/cpcuni/clim/daily"
mkdir -p ${clmdlydatadir}

ndays=$((initday2-initday1+1))

#------------------------------ getting the clim daily files ----------------------------------------------
echo "getting the $((initday2-initday1+1))-days CPC-Unified Clim data"
#

dy0=$initday1
dnum=0
while [ $dnum -lt $ndays ] 
    do
    
    if [ $unameout = "Darwin" ]; then
        dy1clim=`date -v +${dy0}d +%m%d`
    else
        dy1clim=`LC_ALL=en_US.utf8 date --date "-$dy0 day ago" "+%m%d"`
    fi

    ifile="${clmdlydatadir}/cpcuni.clim.daily.${dy1clim}"
    normalsize=1000
    actualsize=$(du -k ${ifile} | cut -f 1)
    if [ $actualsize -lt $normalsize ]; then rm -f ${ifile}; fi
    
    echo "downloading CPC-Unified clim file for" ${dy1clim}
    
    if [ ! -f "${clmdlydatadir}/cpcuni.clim.daily.${dy1clim}" ] ; then
        echo "***************** Retrieving " ${dy1clim} " data ****************************************************************"
        curl -O https://www.ftp.cpc.ncep.noaa.gov/International/cpcuni_clim/cpcu_clim_${dy1clim}.bin
        mv cpcu_clim_${dy1clim}.bin   ${clmdlydatadir}/cpcuni.clim.daily.${dy1clim}
    else
        echo "The target file is already on the local distant"
        ls -lrt ${clmdlydatadir}/cpcuni.clim.daily.${dy1clim}
    fi
    dy0=`bc <<< "$dy0+1"`
    dnum=`bc <<< "$dnum+1"`
done

#------------------------------ editing the control files ----------------------------------------------
if [ $unameout = "Darwin" ]; then
    dt1=`date -v +${initday1}d +%d%b%Y`
    opt="bk"
else
    dt1=`LC_ALL=en_US.utf8 date --date "-$initday1 day ago" "+%d%b%Y"`
fi

echo $dt1 $ndays

clmdlydatadir="${clmdlydatadir}/"
sed -e "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|$dt1|g;s|NNDAYS|$ndays|g" src_file/template_cpcuni_clim.ctl > cpcuni_clim_rev.ctl
