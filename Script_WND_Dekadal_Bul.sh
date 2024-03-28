#!/bin/bash
LANG=en_US.utf8
Dkdsdate=${1}
Dkdndate=${2}
clmyr1=${3}
clmyr2=${4}


 
#################### Wind characteristic during the last dekad at 925, 850, 700hPa: Slide 11
mkdir Slide11
 Startdate="$Dkdsdate";  enddate="$Dkdndate"
 nddksrt=$(( ( $(date +%s) - $(date -d "$Startdate" +%s) ) /(24 * 60 * 60 ) )); nddkend=$(( ( $(date +%s) - $(date -d "$enddate" +%s) ) /(24 * 60 * 60 ) ))
 day1=`date --date "$nddksrt day ago" "+%d"`; mth1=`date --date "$nddksrt day ago" "+%b"`; yr1=`date --date "$nddksrt day ago" "+%Y"`
 day2=`date --date "$nddkend day ago" "+%d"`; mth2=`date --date "$nddkend day ago" "+%b"`; yr2=`date --date "$nddkend day ago" "+%Y"`
 mth1p=`date --date "$nddksrt day ago" "+%m"`; mth2p=`date --date "$nddkend day ago" "+%m"`; yr1p=$(($yr1-1)); yr2p=$(($yr2-1))

for lvl in 925 850 700 200
  do
  for var in "u" "v"
     do
	clmwndlink="https://iridl.ldeo.columbia.edu/expert/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/dekadalAverage/P/%28${lvl}%29/VALUES/T/%2801%20Jan%201949%29/%2831%20Dec%201949%29/RANGE/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/dekadalAverage/P/%28${lvl}%29/VALUES/T/%28${day1}%20${mth1}%20${clmyr1}%29/%28${day2}%20${mth2}%20${clmyr2}%29/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/36/splitstreamgrid/%5BT2%5Daverage/T/2/index/T/dekadaledgesgrid/partialgrid/2/1/roll/pop/replaceGRID/T/%28days%20since%201949-01-01%29/streamgridunitconvert/T/T/dekadaledgesgrid/first/secondtolast/subgrid//calendar//365/def/gridS/365/store/modulus/pop/periodic/setgridtype/partialgrid/replaceGRID/%5BX/Y%5DREORDER/2/1/roll/pop//fullname/%28${var}wnd%20${clmyr1}-${clmyr2}%20clim%29/def//long_name/%28${var}wnd%20${clmyr1}-${clmyr2}%20clim%29/def/data.nc"

  	obswndlink="http://iridl.ldeo.columbia.edu/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/T/%28${day1}%20${mth1}%20${yr1}%29/%28${day2}%20${mth2}%20${yr2}%29/RANGEEDGES/P/%28${lvl}%29/VALUES/%5BT%5D//keepgrids/average/-999/setmissing_value//name//${var}wnd/def/data.nc"

  	obswndlinkp="http://iridl.ldeo.columbia.edu/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.PressureLevel/.${var}/T/%28${day1}%20${mth1}%20${yr1p}%29/%28${day2}%20${mth2}%20${yr2p}%29/RANGEEDGES/P/%28${lvl}%29/VALUES/%5BT%5D//keepgrids/average/-999/setmissing_value//name//${var}wnd/def/data.nc"

   clmwndncfile="cdas_clm_${var}wnd_${lvl}_${day1}${mth1}-${day2}${mth2}.nc"
   wndncfile="cdas_${var}wnd_${lvl}_${Startdate}-${enddate}.nc"
   wndncfilep="cdas_${var}wnd_${lvl}_${yr1p}${mth1p}${day1}-${yr2p}${mth2p}${day2}.nc"

   wget -O ${clmwndncfile} ${clmwndlink}
   wget -O ${wndncfile} ${obswndlink}
   wget -O ${wndncfilep} ${obswndlinkp}

   if [ $var = "u" ]; then ufile="${wndncfile}"; upfile="${wndncfilep}"; clmufile="${clmwndncfile}"; fi
   if [ $var = "v" ]; then vfile="${wndncfile}"; vpfile="${wndncfilep}"; clmvfile="${clmwndncfile}"; fi
  done
 
 ############# plot for the current year ############################################################"
 cp template_plot_wind_for_decadal.gs plot_wind_for_decadal.gs
 sed -i $opt "s|CLMUOBSFILE|${clmufile}|g; s|CLMVOBSFILE|${clmvfile}|g" plot_wind_for_decadal.gs
 sed -i $opt "s|UOBSFILE|${ufile}|g; s|VOBSFILE|${vfile}|g; s|LVL|${lvl}|g" plot_wind_for_decadal.gs
 sed -i $opt "s|DAY1|${day1}|g; s|DAY2|${day2}|g; s|MTH|${mth1}|g; s|YEAR|${yr1}|g" plot_wind_for_decadal.gs
 grads -bpc plot_wind_for_decadal.gs

 mv wnd_tot.png wnd_tot_obs_${lvl}_dekadal.png
 mv wnd_anom.png wnd_anom_obs_${lvl}_dekadal.png

 convert -trim -trim -density 500 wnd_tot_obs_${lvl}_dekadal.png wnd_tot_obs_${lvl}_dekadal.png
 convert -trim -trim -density 500 wnd_anom_obs_${lvl}_dekadal.png wnd_anom_obs_${lvl}_dekadal.png


 ############# plot for the same dekad but one year ago ############################################################"
 rm -r plot_wind_for_decadal.gs
 cp template_plot_wind_for_decadal.gs plot_wind_for_decadal.gs
 sed -i $opt "s|CLMUOBSFILE|${clmufile}|g; s|CLMVOBSFILE|${clmvfile}|g" plot_wind_for_decadal.gs
 sed -i $opt "s|UOBSFILE|${upfile}|g; s|VOBSFILE|${vpfile}|g; s|LVL|${lvl}|g" plot_wind_for_decadal.gs
 sed -i $opt "s|DAY1|${day1}|g; s|DAY2|${day2}|g; s|MTH|${mth1}|g; s|YEAR|${yr1p}|g" plot_wind_for_decadal.gs
 grads -bpc plot_wind_for_decadal.gs

 mv wnd_tot.png wnd_lstyr_tot_obs_${lvl}_dekadal.png
 mv wnd_anom.png wnd_lstyr_anom_obs_${lvl}_dekadal.png

 convert -trim -trim -density 500 wnd_lstyr_tot_obs_${lvl}_dekadal.png wnd_lstyr_tot_obs_${lvl}_dekadal.png
 convert -trim -trim -density 500 wnd_lstyr_anom_obs_${lvl}_dekadal.png wnd_lstyr_anom_obs_${lvl}_dekadal.png

 rm -rf plot_wind_for_decadal.gs src_file cdas*.ctl cdas*bin
done
