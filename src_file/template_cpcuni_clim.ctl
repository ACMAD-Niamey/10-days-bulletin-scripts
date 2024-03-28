DSET CLMDLDATADIRcpcuni.clim.daily.%m2%d2
*
TITLE global daily analysis (grid box mean, the grid shown is the center of the grid box)
*
OPTIONS template little_endian 365_day_calendar
*
UNDEF -999.0
*
XDEF 720 LINEAR   0.25 0.50
*
YDEF 360 LINEAR -89.75 0.50
*
ZDEF 1 LEVELS 1
*
TDEF NNDAYS linear STDATE 1dy
*
VARS 1
rain     1  00 the grid analysis (0.1mm/day)
ENDVARS
