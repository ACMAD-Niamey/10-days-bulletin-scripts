#!/bin/bash
LANG=en_US.utf8 
Dkdsdate=${1}
Dkdndate=${2}
clmyr1=${3}
clmyr2=${4}


#################### Geopotential Heights for the last dekad at 500hPa: Slide 6

 Startdate="$Dkdsdate";  enddate="$Dkdndate"
 nddksrt=$(( ( $(date +%s) - $(date -d "$Startdate" +%s) ) /(24 * 60 * 60 ) )); nddkend=$(( ( $(date +%s) - $(date -d "$enddate" +%s) ) /(24 * 60 * 60 ) ))
 day1=`date --date "$nddksrt day ago" "+%d"`; mth1=`date --date "$nddksrt day ago" "+%b"`; yr1=`date --date "$nddksrt day ago" "+%Y"`
 day2=`date --date "$nddkend day ago" "+%d"`; mth2=`date --date "$nddkend day ago" "+%b"`; yr2=`date --date "$nddkend day ago" "+%Y"`
 mth1p=`date --date "$nddksrt day ago" "+%m"`; mth2p=`date --date "$nddkend day ago" "+%m"`; yr1p=$(($yr1-1)); yr2p=$(($yr2-1))
for lvl in 500
  do
  var="phi"

  clmz500link="https://iridl.ldeo.columbia.edu/expert/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/dekadalAverage/P/%28${lvl}%29/VALUES/T/%2801%20Jan%201949%29/%2831%20Dec%201949%29/RANGE/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/dekadalAverage/P/%28${lvl}%29/VALUES/T/%28${day1}%20${mth1}%20${clmyr1}%29/%28${day2}%20${mth2}%20${clmyr2}%29/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/36/splitstreamgrid/%5BT2%5Daverage/T/2/index/T/dekadaledgesgrid/partialgrid/2/1/roll/pop/replaceGRID/T/%28days%20since%201949-01-01%29/streamgridunitconvert/T/T/dekadaledgesgrid/first/secondtolast/subgrid//calendar//365/def/gridS/365/store/modulus/pop/periodic/setgridtype/partialgrid/replaceGRID/%5BX/Y%5DREORDER/2/1/roll/pop//fullname/%28${var}%20${clmyr1}-${clmyr2}%20clim%29/def//long_name/%28${var}%20${clmyr1}-${clmyr2}%20clim%29/def/data.nc"

 obsz500link="http://iridl.ldeo.columbia.edu/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/T/%28${day1}%20${mth1}%20${yr1}%29/%28${day2}%20${mth2}%20${yr2}%29/RANGEEDGES/P/%28${lvl}%29/VALUES/%5BT%5D//keepgrids/average/-999/setmissing_value//name//${var}/def/data.nc"

 obsz500linkp="http://iridl.ldeo.columbia.edu/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/T/%28${day1}%20${mth1}%20${yr1p}%29/%28${day2}%20${mth2}%20${yr2p}%29/RANGEEDGES/P/%28${lvl}%29/VALUES/%5BT%5D//keepgrids/average/-999/setmissing_value//name//${var}/def/data.nc"

 clmz500ncfile="cdas_clm_${var}_${lvl}_${day1}${mth1}-${day2}${mth2}.nc"
 z500ncfile="cdas_${var}_${lvl}_${Startdate}-${enddate}.nc"
 z500ncfilep="cdas_${var}_${lvl}_${yr1p}${mth1p}${day1}-${yr2p}${mth2p}${day2}.nc"

 wget -O ${clmz500ncfile} ${clmz500link}
 wget -O ${z500ncfile} ${obsz500link}
 wget -O ${z500ncfilep} ${obsz500linkp}

 cp template_plot_geopt_for_decadal.ncl plot_geopt_for_decadal.ncl
 sed -i $opt "s|DAY1|${day1}|g; s|DAY2|${day2}|g; s|MTHD|${mth1}|g; s|MTHNM|${mth2p}|g; s|YEAR|${yr1}|g; s|ZLVL|${lvl}|g" plot_geopt_for_decadal.ncl
 ncl plot_geopt_for_decadal.ncl
 
 convert -trim -trim -density 500 z${lvl}_anom.png z${lvl}_anom.png
 convert -trim -trim -density 500 z${lvl}_anom_lstyr.png z${lvl}_anom_lstyr.png

 rm -rf plot_geopt_for_decadal.ncl src_file cdas*.ctl cdas*bin
done
