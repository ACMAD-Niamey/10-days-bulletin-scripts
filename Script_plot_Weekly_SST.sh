#!/bin/bash
LANG=en_US.utf8 

Dirout="/$HOME/SST_Anom_Maps/OISST/weekly"

mkdir -p $Dirout


cp -r src_file/lpoly_mres.asc .



lastSat=`date +"%Y%m%d" -d "last saturday"`
ndlstsrtd0=$(( ( $(date +%s) - $(date -d "$lastSat" +%s) ) /(24 * 60 * 60 ) ))
let ndlstsrtd=$ndlstsrtd0+6   # sunday before last Saturday
# ndlstsrtd0=$(($ndlstsrtd0+7))
# let ndlstsrtd=$ndlstsrtd0+6   # sunday before last Saturday

clmdlydatadir="/$HOME/DATA/oisst/clim/clm_daily"
dlydatadir="/$HOME/DATA/oisst/daily"

wks=1
while [ $wks -le 10 ]
    do
    #date info for the last week
    date1=`date --date "$ndlstsrtd day ago" "+%d%b%Y"`
    date2=`date --date "$ndlstsrtd0 day ago" "+%d%b%Y"`
    if [ $wks -eq 1 ]; then dateend="$date2";nbrd2=$ndlstsrtd0; fi
    if [ $wks -eq 4 ]; then datestart="$date1";nbrd1=$ndlstsrtd; fi
    echo $wks $date1 $date2

    day1=`date --date "$ndlstsrtd day ago" "+%d"`
    mth1=`date --date "$ndlstsrtd day ago" "+%b"`
    yr1=`date --date "$ndlstsrtd day ago" "+%Y"`

    day2=`date --date "$ndlstsrtd0 day ago" "+%d"`
    mth2=`date --date "$ndlstsrtd0 day ago" "+%b"`
    yr2=`date --date "$ndlstsrtd0 day ago" "+%Y"`
 
    ndays=$((ndlstsrtd-ndlstsrtd0+1))

    cp src_file/template_oisst_clim.daily.ctl oisst_clim_daily.ctl
    sed -i $opt "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|$date1|g;s|NNDAYS|$ndays|g" oisst_clim_daily.ctl

    cp src_file/template_oisst.day.mean.ctl oisst_day_mean.ctl
    sed -i $opt "s|DLDATADIR|${dlydatadir}|g" oisst_day_mean.ctl

    grads -blcx "plot_weekly_sst_anom.gs ${date1} ${date2} 1"
    #composite \( -dissolve 200% -geometry +680+230 -resize 60% src_file/logoacmad.png \) sst_anom.png sst_anom.png
    composite \( -dissolve 100% -geometry +700+103 -resize 40% src_file/logoacmad.png \) sst_anom.png sst_anom.png

    mv sst_anom.png sst_anom_Week${wks}.png
    convert -trim -trim -density 500 sst_anom_Week${wks}.png sst_anom_Week${wks}.png

    mv sst_anom_Week${wks}.png $Dirout/.

    rm -f oisst_clim_daily.ctl oisst_day_mean.ctl
    let ndlstsrtd0=$ndlstsrtd+1
    let ndlstsrtd=$ndlstsrtd0+6
    wks=$(($wks+1))
done


ndays=$((nbrd1-nbrd2+1))

cp src_file/template_oisst_clim.daily.ctl oisst_clim_daily.ctl
sed -i $opt "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|$datestart|g;s|NNDAYS|$ndays|g" oisst_clim_daily.ctl

cp src_file/template_oisst.day.mean.ctl oisst_day_mean.ctl
sed -i $opt "s|DLDATADIR|${dlydatadir}|g" oisst_day_mean.ctl

grads -blcx "plot_weekly_sst_anom.gs ${datestart} ${dateend} 1"
#composite \( -dissolve 200% -geometry +680+230 -resize 60% src_file/logoacmad.png \) sst_anom.png sst_anom.png
composite \( -dissolve 100% -geometry +700+103 -resize 40% src_file/logoacmad.png \) sst_anom.png sst_anom.png
mv sst_anom.png sst_anom_4Weeks.png
convert -trim -trim -density 500 sst_anom_4Weeks.png sst_anom_4Weeks.png
mv sst_anom_4Weeks.png $Dirout/.

rm -r oisst_clim_daily.ctl oisst_day_mean.ctl lpoly_mres.asc




