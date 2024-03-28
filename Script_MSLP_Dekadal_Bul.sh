#!/bin/bash
LANG=en_US.utf8 
Dkdsdate=${1}
Dkdndate=${2}
clmyr1=${3}
clmyr2=${4}

################### Last Decade MSLP : Slide 5
 Startdate="$Dkdsdate";  enddate="$Dkdndate"
 nddksrt=$(( ( $(date +%s) - $(date -d "$Startdate" +%s) ) /(24 * 60 * 60 ) )); nddkend=$(( ( $(date +%s) - $(date -d "$enddate" +%s) ) /(24 * 60 * 60 ) ))
 day1=`date --date "$nddksrt day ago" "+%d"`; mth1=`date --date "$nddksrt day ago" "+%b"`; yr1=`date --date "$nddksrt day ago" "+%Y"`
 day2=`date --date "$nddkend day ago" "+%d"`; mth2=`date --date "$nddkend day ago" "+%b"`; yr2=`date --date "$nddkend day ago" "+%Y"`
 mth1p=`date --date "$nddksrt day ago" "+%m"`; mth2p=`date --date "$nddkend day ago" "+%m"`; yr1p=$(($yr1-1)); yr2p=$(($yr2-1))
 day2s=$(($day2-1))

 if [ $day1 -eq 1 ]; then dekdnum=1; fi
 if [ $day1 -eq 11 ]; then dekdnum=2; fi
 if [ $day1 -eq 21 ]; then dekdnum=3; fi

 clmmslplink="https://iridl.ldeo.columbia.edu/expert/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.MSL/.pressure/dekadalAverage/T/%2801%20Jan%201949%29/%2831%20Dec%201949%29/RANGE/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.MSL/.pressure/dekadalAverage/T/%28${day1}%20${mth1}%20${clmyr1}%29/%28${day2}%20${mth2}%20${clmyr2}%29/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/36/splitstreamgrid/%5BT2%5Daverage/T/2/index/T/dekadaledgesgrid/partialgrid/2/1/roll/pop/replaceGRID/T/%28days%20since%201949-01-01%29/streamgridunitconvert/T/T/dekadaledgesgrid/first/secondtolast/subgrid//calendar//365/def/gridS/365/store/modulus/pop/periodic/setgridtype/partialgrid/replaceGRID/%5BX/Y%5DREORDER/2/1/roll/pop//fullname/%28pressure%20${clmyr1}-${clmyr2}%20clim%29/def//long_name/%28pressure%20${clmyr1}-${clmyr2}%20clim%29/def/Y/%2850S%29/%2850N%29/RANGEEDGES/X/%2860W%29/%28120E%29/RANGEEDGES/100/div/data.nc"

 obsmslplink="https://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.MSL/.pressure/T/%28${day1}%20${mth1}%20${yr1}%29/%28${day2}%20${mth2}%20${yr2}%29/RANGEEDGES/%5BT%5D//keepgrids/average/100/div/-999/setmissing_value//name//mslp/def/data.nc"

 obsmslplinklastyr="https://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.MSL/.pressure/T/%28${day1}%20${mth1}%20${yr1p}%29/%28${day2}%20${mth2}%20${yr2p}%29/RANGEEDGES/%5BT%5D//keepgrids/average/100/div/-999/setmissing_value//name//mslp/def/data.nc"
 
 clmmslpncfile="cdas_clm_mslp_${day1}${mth1}-${day2}${mth2}.nc"
 mslpncfile="cdas_mslp_${Startdate}-${enddate}.nc"
 mslpncfilelstyr="cdas_mslp_${yr1p}${mth1p}${day1}-${yr2p}${mth2p}${day2}.nc"
 echo $mslpncfilelstyr

 wget -O ${clmmslpncfile} ${clmmslplink}
 wget -O ${mslpncfile} ${obsmslplink}
 wget -O ${mslpncfilelstyr} ${obsmslplinklastyr}

 cp template_plot_mslp_for_decadal.ncl plot_mslp_for_decadal.ncl
 sed -i $opt "s|DAY1|${day1}|g; s|DAY2|${day2}|g; s|MTHD|${mth1}|g; s|MTHNM|${mth2p}|g; s|YEAR|${yr1}|g" plot_mslp_for_decadal.ncl
 ncl plot_mslp_for_decadal.ncl

 convert -trim -trim -density 500 mslp_anom.png mslp_anom.png
 convert -trim -trim -density 500 mslp_anom_lstyr.png mslp_anom_lstyr.png

 rm -rf plot_mslp_for_decadal.ncl src_file cdas*.ctl cdas*bin
