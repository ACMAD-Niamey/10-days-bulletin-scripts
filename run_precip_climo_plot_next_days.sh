#!/bin/bash
LANG=en_US.utf8 
unameout="$(uname -s)"

curdate=$(($(date +%s)/(24 * 60 * 60)))

for prd in 5days 10days Wk1 Wk2
    do
    
    if [ $prd = "5days" ]; then init1=1; init2=$((init1+4)); fi
    if [ $prd = "10days" ]; then init1=1; init2=$((init1+9)); fi
    if [ $prd = "Wk1" ]; then init1=1; init2=$((init1+6)); fi
    if [ $prd = "Wk2" ]; then init1=7; init2=$((init1+6)); fi

    date1=`LC_ALL=en_US.utf8 date --date "-$init1 day ago" "+%d%b%Y"`
    date2=`LC_ALL=en_US.utf8 date --date "-$init2 day ago" "+%d%b%Y"`

    date1clm=`LC_ALL=en_US.utf8 date --date "-$init1 day ago" "+%d%b"`
    date2clm=`LC_ALL=en_US.utf8 date --date "-$init2 day ago" "+%d%b"`

    echo $date1 $date2
    echo $date1clm $date2clm
    ndays=$((init2-init1+1))

    ######### plot CPC-Unified ########################################################################
    bash get_cpcuni_clim_data.sh $init1 $init2
    
    cp src_file/save.gs .
    cp src_file/parsestr.gsf .
    cp src_file/qdims.gsf .

    sed -e "s|dateclm1|${date1clm}|g;s|dateclm2|${date2clm}|g;s|xday|$ndays|g" src_file/template_climo_cpcuni.gs > plot_next_wks_climo_cpcuni.gs
    sed -i "s|date1|${date1}|g;s|date2|${date2}|g;s|tpr|$ndays|g" plot_next_wks_climo_cpcuni.gs

    grads -bpc plot_next_wks_climo_cpcuni.gs
    composite -dissolve 100% -geometry +460+115 src_file/logoacmad.png Africa_rev_rfe_normal_precip.png Africa_rev_rfe_normal_precip.png
    convert -trim -density 500 Africa_rev_rfe_normal_precip.png Africa_rev_rfe_normal_precip.png
    mv Africa_rev_rfe_normal_precip.png Africa_CPC-Uni_Climo_${prd}.png

    composite -dissolve 100% -geometry +460+115 src_file/logoacmad.png Africa_rev_rfe_normal_precip_2.png Africa_rev_rfe_normal_precip_2.png
    convert -trim -density 500 Africa_rev_rfe_normal_precip_2.png Africa_rev_rfe_normal_precip_2.png
    mv Africa_rev_rfe_normal_precip_2.png Africa_CPC-Uni_Climo_${prd}_v2.png

    cdo -f nc import_binary Africa_rev_rfe_normal_precip.ctl Africa_rev_rfe_normal_precip.nc
    mv Africa_rev_rfe_normal_precip.nc Africa_CPC-Uni_Climo_${prd}.nc

    rm -f cpcuni_clim_rev.ctl plot_next_wks_climo_cpcuni.gs 
    rm -f Africa_rev_rfe_normal_precip.ctl Africa_rev_rfe_normal_precip.dat
    ##################################################################################################

    ######### plot ARC2       ########################################################################
    bash get_arc2_clim_data.sh $init1 $init2
 
    sed -e "s|dateclm1|${date1clm}|g;s|dateclm2|${date2clm}|g;s|xday|$ndays|g" src_file/template_climo_arc2.gs > plot_next_wks_climo_arc2.gs
    sed -i "s|date1|${date1}|g;s|date2|${date2}|g;s|tpr|$ndays|g" plot_next_wks_climo_arc2.gs

    grads -bpc plot_next_wks_climo_arc2.gs
    composite -dissolve 100% -geometry +440+115 src_file/logoacmad.png Africa_rev_rfe_normal_precip.png Africa_rev_rfe_normal_precip.png
    convert -trim -density 500 Africa_rev_rfe_normal_precip.png Africa_rev_rfe_normal_precip.png
    mv Africa_rev_rfe_normal_precip.png Africa_ARC2_Climo_${prd}.png

    composite -dissolve 100% -geometry +440+115 src_file/logoacmad.png Africa_rev_rfe_normal_precip_2.png Africa_rev_rfe_normal_precip_2.png
    convert -trim -density 500 Africa_rev_rfe_normal_precip_2.png Africa_rev_rfe_normal_precip_2.png
    mv Africa_rev_rfe_normal_precip_2.png Africa_ARC2_Climo_${prd}_v2.png

     cdo -f nc import_binary Africa_rev_rfe_normal_precip.ctl Africa_rev_rfe_normal_precip.nc
     mv Africa_rev_rfe_normal_precip.nc Africa_ARC2_Climo_${prd}.nc

    rm -f arc2_clim.ctl plot_next_wks_climo_arc2.gs
    rm -f Africa_rev_rfe_normal_precip.ctl Africa_rev_rfe_normal_precip.dat
    ##################################################################################################
    
    rm -f save.gs parsestr.gsf qdims.gsf
done
