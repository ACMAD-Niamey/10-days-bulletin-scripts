dset ^Africa_0p1.dat
undef -9999.0
options 365_day_calendar
title Mask data.
xdef 851 linear -25 0.1
ydef 801 linear -40 0.1
zdef 1 levels 0
tdef 1 linear 00Z01JAN0001 1mn
vars 1
mask 0 99 background mask data
endvars
