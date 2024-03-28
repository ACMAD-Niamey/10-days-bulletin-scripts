DSET ^SSTAFILE
DTYPE   netcdf
TITLE   global daily analysis rainfall frequency
UNDEF   -999.0
*OPTIONS  template
XDEF 360 LINEAR   0.5 1.0
YDEF 180 LINEAR -89.5 1.0
TDEF 1   LINEAR 01Jan1990 1yr
ZDEF    1 LINEAR 1 1
VARS 1
  ssta 0 t,y,x precip           degree_Celsius
ENDVARS
