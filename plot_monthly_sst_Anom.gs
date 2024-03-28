function name(args)
date1=subwrd(args,1)
date2=subwrd(args,2)
prd=subwrd(args,3)
signscale=1.0

say '============== 'prd


*************************************************************
'reinit'
'set display color white'
'c'
'set grads off'


* - - - - - - -- - - - -- - - - -- - - - - - -- - - - - -- - - - -
*/////////////////////////////////////////////////////////////////
'open oisst_clim_daily.ctl'
'open src_file/365dcal/oisst_wolrd_mask_0p25.ctl'
'set lat -68 68'
'set lon 20 380'
'define mask = -1.0*mask.2(t=1)'
'close 2'
'define dtaclm = ave(sst.1,time='date1',time='date2')'
'close 1'

* - - - - - - -- - - - -- - - - -- - - - - - -- - - - - -- - - - -
*/////////////////////////////////////////////////////////////////
'open oisst_day_mean.ctl'
'set lat -68 68'
'set lon 20 380'
'define dta = ave(sst.1,time='date1',time='date2')'

'define dta = dta - dtaclm'
'define dta = smth9(smth9(dta))'

'q dims'
linlon = sublin(result,2); linlat = sublin(result,3)
lonl   = subwrd(linlon,6); lonr   = subwrd(linlon,8)
lats   = subwrd(linlat,6); latn   = subwrd(linlat,8)

ylint = (latn - lats)/4; xlint = (lonr - lonl)/6
xlint = math_int(math_abs(xlint)); ylint = math_int(math_abs(ylint))

'set t 1'

*******************set axis layout ********************************
'set vpage 0 11 0 8.5'
'set parea 0.7 10.2 0.5 8.0'
'set xlopts 1 6 0.15'
'set ylopts 1 6 0.15'
'set grid on'
'set xlint 30.0'
'set ylint 20.0'

'set grads off'

'define dta = maskout(dta,mask)'

************************************************
'set gxout shaded'
'set rgb 73 80 80 80'
'set rgb 208 200 200 200'
'set clevs -1 1'
'set ccols 208 0 208'
'd mask'


'src_file/acmad_sst_colors'
clevvl= '-5.5 -5.0 -4.5 -4.0 -3.5 -3.0 -2.5 -2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5'
ccolr= '100 100 100 100 100 100 100 100 101 102 103 104 104 105 106 107 108 108 108 108 108 108 108 108'
'set gxout shaded'
'set clevs 'clevvl
'set ccols 'ccolr
'd dta*'signscale
'src_file/xcbar_cpt -fh 0.15 -fw 0.085 -ft 6 -fs 1 -fo 0 -edge square -line on'

'set gxout contour'
clevvl= '-4.5 -4.0 -3.5 -3.0 -2.5 -2.0 -1.5 -1.0 -0.5 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5'
'set clevs 'clevvl
'set ccols 1'
'set clab off'
*'d dta*'signscale

*'set rgb 73 80 80 80'
*'set rgb 208 200 200 200'
*'src_file/basemap L 208 1 M' 

'set strsiz 0.15 0.25'
'set string 1 c 10 0'
'draw title SST Anom. for 'prd

'printim sst_anom.png'
'c'
'quit'
