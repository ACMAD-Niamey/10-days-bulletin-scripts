#!/bin/bash
LANG=en_US.utf8 
clmyr1=1991
clmyr2=2020



###############################################################################################
curday=`LC_ALL=en_US.utf8 date "+%d"`
curmth=`LC_ALL=en_US.utf8 date "+%m"`
curyr=`LC_ALL=en_US.utf8  date "+%Y"`
curdate=`LC_ALL=en_US.utf8  date "+%Y-%b-%d"`

if [ $curday -ge 1 ] && [ $curday -le 10 ]
  then
  dekd=3
  trgtmth=`LC_ALL=en_US.utf8 date --date "last month" "+%m"`
  trgtmth_s=`LC_ALL=en_US.utf8 date --date "last month" "+%b"`
  trgtyr=`LC_ALL=en_US.utf8 date --date "last month" "+%Y"`
  day1="21"
  day2=`LC_ALL=en_US.utf8 date -d "$trgtyr/$trgtmth/1 + 1 month - 1 day" "+%d"`
  if [ ${trgtmth} -eq "02" ]; then day2="28"; fi
else
  trgtmth=`LC_ALL=en_US.utf8 date "+%m"`
  trgtmth_s=`LC_ALL=en_US.utf8 date "+%b"`
  trgtyr=`LC_ALL=en_US.utf8 date "+%Y"`
  if [ $curday -gt 10 ] && [ $curday -le 20 ]; then dekd=1; day1="01"; day2="10"; fi
  if [ $curday -gt 20 ] && [ $curday -le 31 ]; then dekd=2; day1="11"; day2="20"; fi
fi
date1="${trgtyr}${trgtmth}${day1}"
date2="${trgtyr}${trgtmth}${day2}"


################################################################################################################################
#################### GET PRODUCTS FOR THE PAST OBSERVED SITUATIONS ############################################
################################################################################################################################
bash Script_MSLP_Dekadal_Bul.sh  ${date1} ${date2} ${clmyr1} ${clmyr2}
bash Script_GEOPT_Dekadal_Bul.sh ${date1} ${date2} ${clmyr1} ${clmyr2}
bash Script_WND_Dekadal_Bul.sh   ${date1} ${date2} ${clmyr1} ${clmyr2}
bash Script_RHUM_Dekadal_Bul.sh  ${date1} ${date2} ${clmyr1} ${clmyr2}
