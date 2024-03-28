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
'sdfopen CLMUOBSFILE'
'sdfopen CLMVOBSFILE'
'set lat -90 90'
'set lon -180 180'
'define clmu = u.1(t=1)'
'define clmv = v.2(t=1)'
'close 2'
'close 1'

'sdfopen UOBSFILE'
'sdfopen VOBSFILE'
'set lat -90 90'
'set lon -180 180'

'set t 1'

'define obsu = uwnd.1(t=1)'
'define obsv = vwnd.2(t=1)'
'define obsdiv = hdivg(obsu,obsv)*1e05'

'define anou = obsu - clmu'
'define anov = obsv - clmv'
'define anodiv = hdivg(anou,anov)*1e05'

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
ylint = (latn - lats)/4
xlint = (lonr - lonl)/6
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

'src_file/define_colors'
***************************************************************************
****************** Total Wind and Divergence 
***************************************************************************
'set gxout shaded'
'set clevs -1.5 -1.0 -0.5 -0.25 0.25 0.5 1.0 1.5'
'set ccols 48 46 44 42 0 72 74 76 78'
'd obsdiv'
'src_file/xcbar_cpt -fh 0.15 -fw 0.12 -ft 6 -fo 0 -edge square -line on'
*'src_file/cbarmerc2.gs'

'set line 99 1 6'
'draw shp src_file/WMO_basemap.shp'

*'set gxout vector'
'set arrscl 0.25 10'
'set gxout stream'
'd obsu;obsv'

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
'draw string 'xmid' 'ytop+0.6' CDAS 'LVL'hPa Divergence and Wind Tot.'
'draw string 'xmid' 'ytop+0.3' Dekad: 'DAY1'-'DAY2' 'MTH' 'YEAR
'printim wnd_tot.png'
'c'

***************************************************************************
****************** Wind and Divergence Anomalies
***************************************************************************
'set xlab auto'
'set ylab auto'
'set grid off'
'set xlint 'xlint
'set ylint 'ylint
'set grads off'
'set gxout shaded'
'set clevs -1.5 -1.0 -0.5 -0.25 0.25 0.5 1.0 1.5'
'set ccols 48 46 44 42 0 72 74 76 78'
'd anodiv'
'src_file/xcbar_cpt -fh 0.15 -fw 0.12 -ft 6 -fo 0 -edge square -line on'
*'src_file/cbarmerc2.gs'

'set line 99 1 6'
'draw shp src_file/WMO_basemap.shp'

*'set gxout vector'
'set arrscl 0.25 10'
'set gxout stream'
'd anou;anov'

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
'draw string 'xmid' 'ytop+0.6' CDAS 'LVL'hPa Divergence and Wind Anom.'
'draw string 'xmid' 'ytop+0.3' Dekad: 'DAY1'-'DAY2' 'MTH' 'YEAR
'printim wnd_anom.png'
'c'

'quit'
