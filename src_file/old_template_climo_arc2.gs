'reinit'
'open arc2_clim.ctl'
'open src_file/Africa_0p1.ctl'
'set display color white'
'clear'
*
masksplot=1
nd = xday
*
*
file2='src_file/Africa_latlon'
  result=read(file2)
  rstr=sublin(result,2)
  country=subwrd(rstr,1)
  lat1=subwrd(rstr,2)
  lat2=subwrd(rstr,3)
  lon1=subwrd(rstr,4)
  lon2=subwrd(rstr,5)
  xlnt=subwrd(rstr,6)
  ylnt=subwrd(rstr,7)
*
'set lat 'lat1' 'lat2''
'set lon 'lon1' 'lon2''
'set time date1'
*
'define pclim = tpr*ave(pmer2.1, time=date1,time=date2)'
'define pclim=if(pclim,<,0,0,pclim)'



'define pclimrate = pclim/'nd')'
'define drymask = const(const(maskout(pclimrate,pclimrate-0.75),1),-1,-u)'

if (masksplot = 1)
 'define pclim=maskout(pclim,mask.2(t=1))'
endif
'define drymask = maskout(drymask,mask.2(t=1))'

'set string 1 c 1 0'
*

***************************** Plot the Total Rainfall Climatology *****************************
'set mpdraw off'
*
'set vpage 0.0 8.5 0.75 10.25'
'set xlopts 1 6 0.15'
'set ylopts 1 6 0.15'
'set grads off'
'set gxout shaded'
'set xlint 'xlnt''
'set ylint 'ylnt''
'set grid off'

'set clevs -1'
'set ccols 94 94'
*'d drymask'

'src_file/acmad_RR_colors'
clevvl= '5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195'
ccolr= '100 101 102 102 102 103 103 103 103 103 104 104 104 104 104 105 105 105 105 105 106 106 106 106 106 106 106 106 106 106 107 107 107 107 107 107 107 107 107 108'
varunit='mm'

clevvl= '25 50 75 100 125 150 175 200'
ccolr= '100 101 102 104 104 104 104 104 104'
'set gxout shaded'
'set clevs 'clevvl
'set ccols 'ccolr
'set mpdraw off'
'd pclim'

** ------ Figure out where the title will go -------------------------
'q gxinfo'
xlims=sublin(result,3)
ylims=sublin(result,4)
ybel=subwrd(ylims,4)
ytop=subwrd(ylims,6)
xleft=subwrd(xlims,4)
xright=subwrd(xlims,6)
xmid=xleft+(xright-xleft)/2

width=xright-xleft
height=ytop-ybel


'set string 1 c 6'
'set strsiz  0.2'
'draw string 'xmid' 'ytop+0.625' ARC2 xday-Day Total Precip ('varunit')'
'draw string 'xmid' 'ytop+0.25' Clim. Period: dateclm1 to dateclm2'

 xskip=0.2; yskip=0.2
 x1=xleft+xskip; x2=x1+0.3
 ymid=(ytop-ybel)/2.0; lbltp=ymid*2/3.0
 y1=ybel+yskip; y2=y1+lbltp
 bxhgt=(y2-y1)/5.0; bxhgt2=bxhgt/2.0

 'src_file/xcbar 'x1' 'x2' 'y1' 'y2' -fw 0.1 -fh 0.1 -fc 0 -edge square -line on'
 
 'set string 1 l 7'
 'set strsiz  0.15'
 'draw string 'x2+0.1' 'y1+0.05' 0'
 'draw string 'x2+0.1' 'y1+bxhgt+0.1' 25'
 'draw string 'x2+0.1' 'y1+2.0*bxhgt+bxhgt2' 50'
 'draw string 'x2+0.1' 'y1+3.0*bxhgt+bxhgt2+0.15' 75'
 
'set line 96 1 1'
'draw shp src_file/AFR_adm2'
'set line 1 1 6'
'draw shp src_file/AFR_adm1'
'printim Africa_rev_rfe_normal_precip.png '
*'!convert -trim -density 500 Africa_rev_rfe_normal_precip.png Africa_rev_rfe_normal_precip.png'
'clear'

'quit'
