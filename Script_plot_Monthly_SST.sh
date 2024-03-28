#!/bin/bash
LANG=en_US.utf8 
MTH=${1}
YEAR=${2}

if [ "$#" -lt 2 ]
    then 
    echo "***************************************************************************************************************************"
    echo "--                                        You need to provide 2 arguments                                  ----------------"
    echo "***************************************************************************************************************************"
    echo 
    echo "The first and the second arguments, correspond respectively to the target Month and Year (eg. Aug 2020)"
    echo 
    echo "The action should be like ..."
    echo
    echo "bash Script_plot_Monthly_SST.sh Jan 2021"
    echo   
    exit
fi
################################################################################################################################
trgtmth="${MTH}"
trgtyr="${YEAR}"
clmdlydatadir="/$HOME/DATA/oisst/clim/clm_daily"
dlydatadir="/$HOME/DATA/oisst/daily"

Dirout00="/$HOME/SST_Anom_Maps/OISST/monthly"

################################################################################################################################
#################### GET PRODUCTS FOR THE PAST OBSERVED SITUATIONS                  ############################################
################################################################################################################################

### get last month informations #########################
M=1
for X in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do [ "$trgtmth" = "$X" ] && break ; M=`expr $M + 1`; done
if [ $M -lt 10 ]; then M="0$M"; fi

trgtmth_n="$M" 
day1="01"
day2=`LC_ALL=en_US.utf8 date -d "$trgtyr/$trgtmth_n/1 + 1 month - 1 day" "+%d"` 
if [ ${trgtmth_n} -eq "02" ]; then day2="28"; fi

date1="${trgtyr}${trgtmth_n}${day1}"
date2="${trgtyr}${trgtmth_n}${day2}"
echo $date1 $date2

init1=$(( ( $(date +%s) - $(date -d "$date1" +%s) ) /(24 * 60 * 60 ) ))
init2=$(( ( $(date +%s) - $(date -d "$date2" +%s) ) /(24 * 60 * 60 ) ))

ndays=$((init1-init2+1))
echo $ndays


dayStrt=${day1}${trgtmth}${trgtyr}
dayEnd=${day2}${trgtmth}${trgtyr}
#################### Generate Observed SST Anomalies ###########################################################################
cp -r src_file/lpoly_mres.asc .

cp src_file/template_oisst_clim.daily.ctl oisst_clim_daily.ctl
sed -i $opt "s|CLMDLDATADIR|${clmdlydatadir}|g;s|STDATE|${dayStrt}|g;s|NNDAYS|$ndays|g" oisst_clim_daily.ctl

cp src_file/template_oisst.day.mean.ctl oisst_day_mean.ctl
sed -i $opt "s|DLDATADIR|${dlydatadir}|g" oisst_day_mean.ctl


prd="${trgtmth}${trgtyr}"
echo $prd


  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo ${sstancfile}
  echo "----------------------------------------------------------------------------------------"
  echo ""
  outdir="${Dirout00}/${YEAR}"
  mkdir -p $outdir
  prd="${trgtmth}${trgtyr}"
  grads -blcx "plot_monthly_sst_Anom.gs ${dayStrt} ${dayEnd} ${prd}"
  composite \( -dissolve 100% -geometry +700+103 -resize 40% src_file/logoacmad.png \) sst_anom.png sst_anom.png

  mv sst_anom.png sst_anom_${prd}.png
  convert -trim -trim -density 500 sst_anom_${prd}.png sst_anom_${prd}.png
  
  mv sst_anom_${prd}.png ${outdir}/.
  rm -r oisst_clim_daily.ctl oisst_day_mean.ctl lpoly_mres.asc

