#!/bin/bash
LANG=en_US.utf8 

################################################################################################################################
clmdlydatadir="/$HOME/DATA/oisst/clim/clm_daily"
dlydatadir="/$HOME/DATA/oisst/daily"

Dirout="/$HOME/SST_Anom_Maps/OISST"

################################################################################################################################
######################################## GET PRODUCTS FOR THE PAST OBSERVED SITUATIONS #########################################
################################################################################################################################

initday=3
for prd in 7 10 30 60 90 180
    do

    pend=`bc <<< "$initday"`; pstrt=`bc <<< "$initday+${prd}-1"`
    date1=`LC_ALL=en_US.utf8 date --date "$pstrt day ago" "+%Y%m%d"`
    date2=`LC_ALL=en_US.utf8 date --date "$pend day ago" "+%Y%m%d"`

    dayStrt=`LC_ALL=en_US.utf8 date --date "$pstrt day ago" "+%d%b%Y"`
    dayEnd=`LC_ALL=en_US.utf8 date --date "$pend day ago" "+%d%b%Y"`

    init1=$(( ( $(date +%s) - $(date -d "$date1" +%s) ) /(24 * 60 * 60 ) ))
    init2=$(( ( $(date +%s) - $(date -d "$date2" +%s) ) /(24 * 60 * 60 ) ))

    ndays=$((init1-init2+1))

    echo "Plot the last ${prd} days anomalies / $dayStrt $dayEnd $ndays"
 
    outdir="${Dirout}"
    mkdir -p $outdir

    cp -f src_file/lpoly_mres.asc .
    cp src_file/template_oisst_clim.daily.ctl oisst_clim_daily.ctl
    cp src_file/template_oisst.day.mean.ctl oisst_day_mean.ctl

    sed -i $opt "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|${dayStrt}|g;s|NNDAYS|$ndays|g" oisst_clim_daily.ctl 
    sed -i $opt "s|DLDATADIR|${dlydatadir}|g" oisst_day_mean.ctl

    grads -blcx "plot_sst_anom_rev.gs ${dayStrt} ${dayEnd} $ndays"
    composite \( -dissolve 100% -geometry +700+103 -resize 40% src_file/logoacmad.png \) sst_anom.png sst_anom.png
    convert -trim -trim -density 500 sst_anom.png sst_anom.png
    mv sst_anom.png ${outdir}/sst_anom_last_${prd}-days.png
    
    rm -r oisst_clim_daily.ctl oisst_day_mean.ctl lpoly_mres.asc
    bash Script_plot_sst_Anom_rev.sh $initday $prd
done
#********************************************************************************************************************
#********************************************************************************************************************
#********************************************************************************************************************

