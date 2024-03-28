function name(args)
date1=subwrd(args,1)
say '============== 'date1

*************************************************************
'reinit'
'set display color white'
'c'
'set grads off'

* - - - - - - -- - - - -- - - - -- - - - - - -- - - - - -- - - - -
*/////////////////////////////////////////////////////////////////
***************** Read Climo data ************************************
'sdfopen CLMFILE'
'set lat -90 90'
'set lon -180 180'
'define clm = rhum.1(t=1)'
'close 1'

'sdfopen OBSFILE'
'set lat -90 90'
'set lon -180 180'

'set t 1'
'define obs = rhum.1(t=1)'
'define anom = obs - clm'

'set lat -50 50'
'set lon -40 60'

'q dims'
xtnd=sublin(result,2)
ytnd=sublin(result,3)

linlon = xtnd
linlat = ytnd
lonl   = subwrd(linlon,6)
lonr   = subwrd(linlon,8)
lats   = subwrd(linlat,6)
latn   = subwrd(linlat,8)
ylint = (latn - lats)/10
xlint = (lonr - lonl)/10
xlint = math_int(math_abs(xlint))
ylint = math_int(math_abs(ylint))

Nwcur=subwrd(xtnd,11)
Necur=subwrd(xtnd,13)
Nscur=subwrd(ytnd,11)
Nncur=subwrd(ytnd,13)
picw=Necur-Nwcur+1
pich=Nncur-Nscur+1
if( pich >= picw )
 'set vpage 0 8.5 0 11'
 'set parea 1. 7. 1.5 9.5'
say "yes "pich" "picw
else
 'set vpage 0 11 0 8.5'
 'set parea 1.5 9.5 1.5 7.5'
say "no "pich" "picw
endif
'c'

'set grads off'
*******************set axis layout ********************************
'set xlopts 1 6 0.2'
'set ylopts 1 6 0.2'
'set xlab auto'
'set ylab auto'
'set grid off'
'set xlint 'xlint
'set ylint 'ylint
'set grads off'


************************************************
clevvl= '-35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0'
'src_file/color_cpt -levs 'clevvl' -kind slategray->burlywood->white->blue->navy'

'd anom'
'src_file/xcbar_cpt -fh 0.15 -fw 0.12 -ft 6 -fs 1 -fo 0 -edge square -line on'

'set line 99 1 5'
'draw shp src_file/WMO_basemap.shp'

'set gxout contour'
clevvl= '10 20 40 60 70 80'
'set clevs 'clevvl
'set cthick 1'
'set ccols 1'
'd obs'

'set clevs 40'
'set cthick 6'
'set ccols 5'
'd obs'

'set clevs 60'
'set cthick 10'
'set ccols 3'
'd obs'

'set clevs 70'
'set cthick 10'
'set ccols 8'
'd obs'

'set clevs 80'
'set cthick 10'
'set ccols 2'
'd obs'

*********************** Figure out where the title will go **********************
'q gxinfo'
xlims=sublin(result,3)
ylims=sublin(result,4)
ytop=subwrd(ylims,6)
xleft=subwrd(xlims,4)
xright=subwrd(xlims,6)
xmid=xleft+(xright-xleft)/2

'set string 1 c'
'set strsiz 0.2'
'set string 1 c 10 0'
'draw string 'xmid' 'ytop+0.6' CDAS 'LVL'hPa Rel. Hum. and Anom.'
'draw string 'xmid' 'ytop+0.3' Dekad: 'DAY1'-'DAY2' 'MTH' 'YEAR

'printim rhum_anom.png'
'c'
'quit'
