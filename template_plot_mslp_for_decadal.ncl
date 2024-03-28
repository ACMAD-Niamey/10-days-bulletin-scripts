;----------------------------------------------------------------------
; 
;----------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

    dtadir = "./" 
    clmdir = "./" 
    
    day1   = "DAY1"
    day2   = "DAY2"
    mth    = "MTHD"
    mth_nm = "MTHNM"
    ;dknm  = 1	;DKNUM
    year   = YEAR
    year0  = year-1
    ;================================== END OF EDITION !!! ==========================
   
    ; ======================= Read the Climo file from netcdf =======================
    filmslp      = clmdir +"cdas_clm_mslp_"+day1+""+mth+"-"+day2+""+mth+".nc"
    fmslp        = addfile(filmslp,"r")
    mslpclm0     = fmslp->pressure 
    mslpclm      = mslpclm0
    mslpclm!0    = "time"
    mslpclm!1    = "lat"
    mslpclm!2  	 = "lon"
    mslpclm&time = mslpclm0&T
    mslpclm&lat  = mslpclm0&Y
    mslpclm&lon  = mslpclm0&X
    
    mslpclm     := mslpclm(0,:,:)

    ;utc_date = cd_calendar(mslpclm&time, 0)
    ;month  = tointeger(utc_date(:,1))
    ;idxmth = ind(month.eq.toint(mth_nm))
    ;mslpclm := mslpclm(idxmth,:,:)
    ;;printVarSummary(mslpclm)
    ;mslpclm     := mslpclm(dknm-1,:,:)
    ;printVarSummary(mslpclm)
 
    latS = min(mslpclm&lat)
    latN = max(mslpclm&lat)
    lonL = min(mslpclm&lon)
    lonR = max(mslpclm&lon)

    ; ======================= Read the Data from grib files =======================
    filmslpyr1= dtadir +"cdas_mslp_"+year+""+mth_nm+""+day1+"-"+year+""+mth_nm+""+day2+".nc"
    filmslpyr0= dtadir +"cdas_mslp_"+year0+""+mth_nm+""+day1+"-"+year0+""+mth_nm+""+day2+".nc"
    fmslpyr1  = addfile(filmslpyr1,"r")
    fmslpyr0  = addfile(filmslpyr0,"r")

    mslp1   = fmslpyr1->mslp(0,:,:)
    mslp0   = fmslpyr0->mslp(0,:,:)

    mslp1   = lonFlip(mslp1)
    mslp0   = lonFlip(mslp0)
    
    mslp1   := mslp1({latS:latN},{lonL:lonR})
    mslp0   := mslp0({latS:latN},{lonL:lonR})
    
    copy_VarCoords(mslpclm,mslp1)
    copy_VarCoords(mslpclm,mslp0)

    printVarSummary(mslp1)

    ano1    = mslp1
    ano0    = mslp0

    ano1    = mslp1 - mslpclm
    ano0    = mslp0 - mslpclm
    


 ; ========== Make setting to generate plots ========================
   ; -------------------- shading setting ----------------------------------
    res                              = True ;
    res@gsnFrame                     = False
    res@gsnDraw                      = False
    res@gsnMaximize                  = True
    
    res@gsnAddCyclic                 = False
    res@mpOutlineBoundarySets        = "National"       ; National borders
    res@mpNationalLineThicknessF     = 2.0
    res@mpGeophysicalLineThicknessF  = 5.0
    res@mpNationalLineColor          = "white"            ; National borders
    res@mpGeophysicalLineColor       = "white"
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
    res@cnLevels               := ispan(-12,12,1)
	
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
	cres@cnLevels                  = (/70,80,90/)
	cres@cnLineThicknesses         = (/2.0,2.0,2.0/)
	;cres@cnLineColors             = (/"lightseagreen","green","darkgreen"/) ; (/"cyan","greenyellow","green"/)

     	cnLevels             := (/985,987,989,991,993,995,997,999,1001,1003,1005,1007,1009,1011,1013,1015,1017,1019,1021,1023,1025,1027,1029,1031,1033,1035,1037,1039/)
     	cnLineThicknesses    := 1.0*cnLevels/cnLevels
     	cnLevelFlags         := toint(cnLevels/cnLevels) ; ; 1 ie LineONly, 2 ie LabelOnly, 3 ie LineAndLabel
     	rqstdlevels      = (/1011,1015,1019/)
     	idx1  = ind(cnLevels.eq.1011)
     	idx2  = ind(cnLevels.eq.1015)
     	idx3  = ind(cnLevels.eq.1019)
     	cnLineThicknesses(idx1) = 3.0
     	cnLineThicknesses(idx2) = 6.0
     	cnLineThicknesses(idx3) = 3.0
     
     	cnLevelFlags(idx1) = 3
     	cnLevelFlags(idx2) = 3
     	cnLevelFlags(idx3) = 3
     
        ;cnLineColors               := ""+ cnLevels
        ;cnLineColors(:)             = ""
        ;cres@cnLineColors          := cnLineColors
	cres@cnLevels              := cnLevels
	cres@cnLineThicknesses     := cnLineThicknesses
	cres@cnMonoLevelFlag       := False
	;cres@cnLineLabelsOn         = True
	cres@cnLevelFlags          := cnLevelFlags
	cres@cnLineLabelPlacementMode := "Computed"

    do iyr = 1,2
    	flout2 = "mslp_anom"
        anom   = ano1
	var    = mslp1
        yearstr= year
        if (iyr.eq.2)
	  flout2 = "mslp_anom_lstyr"
          anom   = ano0
          var    = mslp0
          yearstr = year -1
        end if
    	wks2 = gsn_open_wks("png",flout2)              ; send graphics to PNG file

    	;--------- plot daily Mean Sea Level Pressure Departure  -----------------
    	gsn_define_colormap(wks2,"MPL_RdPu")
    	gsn_define_colormap(wks2,"BlWhRe")
        cmap = RGBtoCmap("src_file/ncl_acmad_mslp_rgb.txt")
        gsn_define_colormap(wks2,cmap)

	res@tiMainString    = " MSLP Obs. vs Anom. for the Dekad: "+day1+"-"+day2+" "+mth+" "+yearstr
    	mslpmap       = gsn_csm_contour_map_ce(wks2,anom(:,:),res)
    
    	;--------- plot MSLP in contour -----------------
        mslpct                     = gsn_csm_contour(wks2,var(:,:),cres)
   
    	overlay(mslpmap,mslpct)
    	draw(mslpmap)
    	frame(wks2)
        filpng = flout2+".png"
        cmdrsz = "convert -trim "+filpng+" -density 500 -resize 1500 "+filpng
        system(cmdrsz)
    end do


end

