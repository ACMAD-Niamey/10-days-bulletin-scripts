'reinit'
'sdfopen ecmwf_s2s_precip.nc'
*'open src_file/Africa_0p1.ctl'
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
'set lat -40 40'
'set lon -20 55'
'set time date1'

'define rcum=0*lat'
'define sum10 = 0*lat'
'define sum20 = 0*lat'
'define sum50 = 0*lat'
'define sum100 = 0*lat'

mn=1
while (mn<=50)
 say "----------------" mn
* 'set z 'mn
* 'define rf    = sum(precip,time=date1,time=date2)'

 'set time date1 date2'
 'define rf0   = precip(z='mn')'
 'set t 1'
 'define rf    = sum(rf0,time=date1,time=date2)'

 'define rf10  = const(const(maskout(rf,rf-10.0),1),0,-u)'
 'define rf20  = const(const(maskout(rf,rf-20.0),1),0,-u)'
 'define rf50  = const(const(maskout(rf,rf-50.0),1),0,-u)'
 'define rf100 = const(const(maskout(rf,rf-100.0),1),0,-u)'

 'define rcum  = rcum + rf'
 'define sum10 = sum10 + rf10'
 'define sum20 = sum20 + rf20'
 'define sum50 = sum50 + rf50'
 'define sum100= sum100 + rf100'

 mn=mn+1
endwhile

 'define rcum   = rcum / 50'
 'define prob10  = sum10 / 50'
 'define prob20  = sum20 / 50'
 'define prob50  = sum50 / 50'
 'define prob100 = sum100 / 50'

'define rcum=if(rcum,<,0,0,rcum)'

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

'exec src_file/acmad_RR_colors_2'
'set clevs   20 25 30 35 40 45 50 55 65 70 80 90 100 110 120 130 140 150 175 200 250'
'set ccols 0 28 29 30 31 32 33 34 35 36 37 38 39  40  41  42  43  44  45  46  47  48 49'
'set grads off'
'set grid off'
'set mpdraw off'
'd rcum'

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
'set strsiz  0.15'
'draw string 'xmid' 'ytop+0.625' xday-Days Cumulative Rainfall (mm)'
'set string 1 c 5'
'set strsiz 0.09 0.175'
'set strsiz 0.15'
'draw string 'xmid' 'ytop+0.40' ECMWF (Ens. Mean) Fcst / Init. date: idate'
'draw string 'xmid' 'ytop+0.15' Valid: date1 to date2'

*'set string 1 c 5'
*'draw string 'xmid' 'ybel-0.4' Data Source: ECMWF (Ens. Mean)'

xskip=0.08; yskip=0.2
x1=xright+xskip; x2=x1+0.2
y1=ybel+yskip; y2=ytop-yskip
'src_file/xcbar 'x1' 'x2' 'y1' 'y2' -fw 0.125 -fh 0.15 -edge square -line on'

*'set rgb 16 0   255 255'
*'set rgb 16 127 255 212'
'set rgb 16 180 104 230'
'set rgb 17 255 0   0'
'set gxout contour'
'set clab off'
'set cthick 15'
'set clevs 50 100'
'set ccols 16 17'
'd rcum'
*'d smth9(rcum)'

xskip=0.2; yskip=0.2
x1=xleft+xskip; x2=x1+0.5
y1=ybel+yskip*10; y2=y1-yskip

'set line 16 1 15'
'draw line 'x1' 'y1' 'x2' 'y1
'set line 17 1 15'
'draw line 'x1' 'y2' 'x2' 'y2

'set string 1 l 3'
'set strsiz  0.15'
'draw string 'x2+0.1' 'y1' 50 mm'
'draw string 'x2+0.1' 'y2' 100 mm'

'set line 96 1 1'
'draw shp src_file/AFR_adm2'
'set line 1 1 6'
'draw shp src_file/AFR_adm1'
'printim ecmwf_precip_ens_mean.png'
'clear'

* Rainfall Exceedance Probability (>10mm)
itr=1
while (itr<=4) 
 if (itr = 1); trsld=10; endif
 if (itr = 2); trsld=20; endif
 if (itr = 3); trsld=50; endif
 if (itr = 4); trsld=100; endif
'src_file/define_colors'
'set gxout shaded'
'set grads off'
'set xlint 'xlnt''
'set ylint 'ylnt''
'set xlopts 1 6 0.15'
'set ylopts 1 6 0.15'
'set clevs 5 10 20 30 40 50 60 70 80 90 95'
'set ccols 0 31 33 35 37 39 43 22 24 26 28 68 69'
'd prob'trsld'*100.0'

'set string 1 c 6'
'set strsiz  0.15'
'draw string 'xmid' 'ytop+0.625' ECMWF xday-Days Exceedance Pro. > 'trsld' mm'
'set string 1 c 5'
'set strsiz 0.09 0.175'
'set strsiz 0.15'
'draw string 'xmid' 'ytop+0.40' Init. date: idate'
'draw string 'xmid' 'ytop+0.15' Valid: date1 to date2'

*'draw string 'xmid' 'ytop+0.40' ECMWF (Ens. Mean) Fcst / Init. date: idate'
*'draw string 'xmid' 'ytop+0.15' Valid: date1 to date2'

xskip=0.08; yskip=0.2
x1=xright+xskip; x2=x1+0.2
y1=ybel+yskip; y2=ytop-yskip
'src_file/xcbar 'x1' 'x2' 'y1' 'y2' -fw 0.125 -fh 0.15 -edge square -line on'

'set line 96 1 1'
'draw shp src_file/AFR_adm2'
'set line 1 1 6'
'draw shp src_file/AFR_adm1'
'printim ecmwf_precip_prob'trsld'.png'
'clear'
 itr=itr+1
endwhile


'quit'
