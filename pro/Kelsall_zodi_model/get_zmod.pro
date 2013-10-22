@zmodel_init
;---------------------------------------------------------------------
; Function GET_ZMOD
;
; Function to compute the Kelsall et al. 1998 (ApJ,508,44) ZODI model 
; intensity for a given set of LOS, Wavelength, and Time.
;
; Written By: 	BA Franz
; Date:		23 January 1995
;
; Usage:
;     zodi = GET_ZMOD(lambda,day,lon,lat)
;
; Inputs:
;     lambda - nominal DIRBE wavelength(s) in microns (any combination
;               of 1.25, 2.2, 3.5, 4.9, 12, 25, 60, 100, 140, 240) 
;     day    - 1990 day number(s), where 1.0 = 1 Jan 1990
;     lon    - ecliptic longitude(s)
;     lat    - ecliptic latitude(s)
;
;     note: lambda, day, lon, lat can be any mixture of scalars or arrays,
;           but all arrays must be of same length.
;
; Outputs:
;
;     zodi - scalar or array of zodi model intensity in MJy sr-1
;            For comparison with DIRBE data, this is 'quoted' intensity
;            at the nominal wavelength(s) for an assumed source
;            spectrum nu*F_nu = constant
;
; Optional Keyword Inputs:
;
;     zpar=zpar - array of zodi model params.  If not specified, the
;                 default will be restored from zpars.xdr
;     no_colcorr=no_colcorr - if set, the result will be actual
;                  intensity at the specified wavelength(s) instead of
;                  quoted intensity for a spectrum nu*F_nu = constant
;              
;---------------------------------------------------------------------
function get_zmod,lambda,day,lon,lat,zpar=zpar,no_colcorr=no_colcorr

if (n_elements(zpar) eq 0) then begin
    aend    = 0
    astart  = 0
    chisqr  = 0
    covar   = 0
    sigma_a = 0
    freevars= 0
    wiring  = 0
    restore,'./IDLHomework/default/Kelsall_zodi_model/zpars.xdr'
    zpar = aend
endif
;showpars,zpar

data = mk_zdata(lambda,day,lon,lat)

zkernel,data,zpar,z,no_colcorr=no_colcorr

return,z
end
