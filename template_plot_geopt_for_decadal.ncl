;----------------------------------------------------------------------
; 
;----------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

    dtadir = "./" 
    clmdir = "./" 
    
    lev = ZLVL
    day1   = "DAY1"
    day2   = "DAY2"
    mth    = "MTHD"
    mth_nm = "MTHNM"
    year   = YEAR
    year0  = year-1
    
    latS = -50.0
    latN = 50.0
    lonL = -60.0
    lonR = 120.0
    ;================================== END OF EDITION !!! ==========================
   
    ; ======================= Read the Climo file from netcdf =======================
    filclm      = clmdir +"cdas_clm_phi_"+lev+"_"+day1+""+mth+"-"+day2+""+mth+".nc"
    fclm        = addfile(filclm,"r")
    dtaclm0     = dble2flt(fclm->phi(:,0,:,:))
    dtaclm      = dtaclm0
    dtaclm!0    = "time"
    dtaclm!1    = "lat"
    dtaclm!2  	 = "lon"
    dtaclm&time = dtaclm0&T
    dtaclm&lat  = dtaclm0&Y
    dtaclm&lon  = dtaclm0&X
    
    dtaclm   = lonFlip(dtaclm)
    dtaclm     := dtaclm(0,{latS:latN},{lonL:lonR})
    ;printVarSummary(dtaclm)

    ; ======================= Read the Data from grib files =======================
    filyr1= dtadir +"cdas_phi_"+lev+"_"+year+""+mth_nm+""+day1+"-"+year+""+mth_nm+""+day2+".nc"
    filyr0= dtadir +"cdas_phi_"+lev+"_"+year0+""+mth_nm+""+day1+"-"+year0+""+mth_nm+""+day2+".nc"
    fyr1  = addfile(filyr1,"r")
    fyr0  = addfile(filyr0,"r")

    dta1   = dble2flt(fyr1->phi(0,0,:,:))
    dta0   = dble2flt(fyr0->phi(0,0,:,:))

    dta1   = lonFlip(dta1)
    dta0   = lonFlip(dta0)
    
    dta1   := dta1({latS:latN},{lonL:lonR})
    dta0   := dta0({latS:latN},{lonL:lonR})
    
    copy_VarCoords(dtaclm,dta1)
    copy_VarCoords(dtaclm,dta0)
    ;printVarSummary(dta1)

    ano1    = dta1 - dtaclm
    ano0    = dta0 - dtaclm

    copy_VarMeta(dta1,ano1) 
    copy_VarMeta(dta0,ano0) 

    printMinMax(dta1, True)
    printMinMax(dta0, True)
    printMinMax(dtaclm, True)

 ; ========== Make setting to generate plots ========================
   ; -------------------- shading setting ----------------------------------
    res                              = True ;
    res@gsnFrame                     = False
    res@gsnDraw                      = False
    res@gsnMaximize                  = True
    
    res@gsnAddCyclic                 = False
    res@mpOutlineBoundarySets        = "National"       ; National borders
    res@mpNationalLineThicknessF     = 1.0
    res@mpGeophysicalLineThicknessF  = 2.0
    ;res@mpNationalLineColor          = "white"            ; National borders
    ;res@mpGeophysicalLineColor       = "white"
    res@mpProjection                 = "CylindricalEquidistant" 
    res@mpMinLatF                    = min(ano1&lat)
    res@mpMaxLatF                    = max(ano1&lat) 
    res@mpMinLonF                    = min(ano1&lon) 
    res@mpMaxLonF                    = max(ano1&lon)
    ;res@mpOutlineDrawOrder	     = "Draw"

    res@cnFillOn                     = True                        ; turn on color fill
    ;res@cnFillMode                   = "CellFill"		; fill each grid cell without smoothing
    res@cnLevelSelectionMode         = "ExplicitLevels"
    res@cnLinesOn                    = False                       ; turn off the contour lines
    res@cnLineLabelsOn               = False                           ; turn the line labels off
	
    res@gsnStringFontHeightF         = 0.015
    res@gsnRightString               = " "              ;-- no right string
    res@gsnCenterString              = " "              ;-- no right string
    res@gsnLeftString                = " "              ;-- no left string
    
    res@tiXAxisString                = " "              ;-- don't draw x-axis labels
    res@tiMainFontHeightF            = 0.018

    res@lbLabelBarOn               = True
    ;res@lbOrientation                = "Vertical"


    ;res@lbTitleString   	= "hPa"
    res@lbTitlePosition		= "Right"
    res@lbTitleDirection	= "Across"
    cnLevels                   := ispan(-200,200,20)
    cnLevels(ind(cnLevels.eq.-20))= -10
    cnLevels(ind(cnLevels.eq.20))= 10
    res@cnLevels               := cnLevels
	
   ; -------------------- contour line setting ----------------------------------
	cres                           = True
	cres@gsnFrame                  = False
	cres@gsnDraw                   = False
    	cres@gsnRightString            = " "              ;-- no right string
    	cres@gsnCenterString           = " "              ;-- no right string
    	cres@gsnLeftString             = " "              ;-- no left string
    	cres@cnMonoLineThickness       = False
    	;cres@cnMonoLineDashPattern    = False
    	cres@cnMonoLineColor           = True
    	cres@cnLevelSelectionMode      = "ExplicitLevels"
	cres@cnLinesOn                = True                       ; turn off the contour lines
	cres@cnLineLabelsOn            = True                           ; turn the line labels off
	cres@cnLabelMasking            = True	
	cres@cnLineLabelBackgroundColor= "transparent"
	cres@cnLineLabelFontHeightF    = 0.01
	cres@cnInfoLabelOn             = False
        cres@cnLineDrawOrder           = "PostDraw"
	cres@cnLevels                  = (/5200,5400,5600,5800,6000/)
	cres@cnLineThicknesses         = (/2.0,2.0,2.0/)

     	cnLevels             := ispan(5000,6000,50) ;(/5200,5400,5600,5800,6000/) ;
     	cnLineThicknesses    := 3.0*cnLevels/cnLevels
     	cnLevelFlags         := toint(cnLevels/cnLevels) ; ; 1 ie LineONly, 2 ie LabelOnly, 3 ie LineAndLabel
     	;rqstdlevels          = (/5200,5400,5600,5800,6000/)
     	;idx1  = ind(cnLevels.eq.1011)
     	;idx2  = ind(cnLevels.eq.1015)
     	;idx3  = ind(cnLevels.eq.1019)
     	;cnLineThicknesses(idx1) = 3.0
     	;cnLineThicknesses(idx2) = 6.0
     	;cnLineThicknesses(idx3) = 3.0
        ;cnLevelFlags(idx1) = 3
     	;cnLevelFlags(idx2) = 3
     	;cnLevelFlags(idx3) = 3

	cres@cnLevels              := cnLevels
	cres@cnLineThicknesses     := cnLineThicknesses
	cres@cnMonoLevelFlag       := False
	cres@cnLevelFlags          := cnLevelFlags
	cres@cnLineLabelPlacementMode := "Computed"

    do iyr = 1,2
    	flout2 = "z"+lev+"_anom"
        anom   = ano1
	var    = dta1
        yearstr= year
        if (iyr.eq.2)
	  flout2 = "z"+lev+"_anom_lstyr"
          anom   = ano0
          var    = dta0
          yearstr = year -1
        end if
    	wks2 = gsn_open_wks("png",flout2)              ; send graphics to PNG file

    	;--------- plot  anomalies  -----------------
    	gsn_define_colormap(wks2,"MPL_RdPu")
    	gsn_define_colormap(wks2,"BlWhRe")
        gsn_define_colormap(wks2,"NCV_blu_red")
    
        ;cmap = RGBtoCmap("src_file/ncl_acmad_mslp_rgb.txt")
        ;gsn_define_colormap(wks2,cmap)

	res@tiMainString    = " Geopt @"+lev+"hPa and Anom. / Dek: "+day1+"-"+day2+" "+mth+" "+yearstr
    	mslpmap       = gsn_csm_contour_map_ce(wks2,anom(:,:),res)
    
    	;--------- plot total in contour -----------------
        mslpct                     = gsn_csm_contour(wks2,var(:,:),cres)
   
    	overlay(mslpmap,mslpct)
    	draw(mslpmap)
    	frame(wks2)
        filpng = flout2+".png"
        cmdrsz = "convert -trim "+filpng+" -density 500 -resize 1500 "+filpng
        system(cmdrsz)
    end do


end

