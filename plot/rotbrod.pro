pro 	rotbrod, ww,ss,v,ssm,eps,nres,plot=pl,out=ot

if n_params() eq 0 then begin
	print,'ROTBROD,ww,ss,v,ssm[,eps,nres,plot=pl,out=ot]' 
return
endif
;ROTATIONAL BROADENING WITH VELOCITY,V (sin i) and NRES*2 points in the
;rotational profile, (there are nres pts per Doppler width)
;spectrum,SS and wave. WW, smoothed spectrum in SSM
;note:  do not use too wide a wavelength span at one time (1000 Dop. wids)
;PLOT:  1 on, 0 off
;**programers' note: the explosion at the end of ssm is a problem
;Oct-94 GB Modified to change NRES default to increase with V
if n_params() le 4 then eps = 0.6		;Default values
if n_params() le 5 then nres = max([10,v])
	c = 2.998e5
	npp = n_elements(ww)   &   stw = ww(0)
	dlam = ww(npp/2)*v/c   &   dc = nres/dlam
	span = ww(npp-1)-ww(0)
	np = long(span*dc)   
	if np le npp then begin
	w=ww  & s=ss 
	end else begin
	in=findgen(np) & w=stw+in/dc		;make a finer wavelength scale
if keyword_set(ot) then print, 'Dispersion ',dc,  $
	   '  p/A.  Using ',np,'points'
	s = spline(ww,ss,w)			;interpolate onto finer scale
	end
;pad out ends
	sec1 = fltarr(nres + 2)
	sec1 = sec1 + randomn(seed,nres +2)*1.e-8	;call randomn
	sec2 = sec1   &   sec1 = sec1 + s(0)   &   sec2 = sec2 + s(np-1)
	s = [sec1,s,sec2]
	np = n_elements(s)
	nw = nres + 2   &   sum = 0.0
	pr = fltarr(nw)
;***compute ROTATIONAL BROADENING FUNCTION (Gray)
	con1 = 2*(1.-eps)/(!pi*dlam*(1.-eps/3.))
	con2 = eps/(2.*(1.-eps/3.)*dlam)
;WARNING***the doppler width is not adjusted for shifting central lambda
	for n=0,nw-1 do begin
		dl = n/dc   &   dls = 1.-(dl/dlam)*(dl/dlam)
		if dls le 0. then dls = 1.e-10
		pr(n) = con1 *sqrt(dls) + con2 * dls
		sum = sum + pr(n) * 2
	endfor
	sum = sum - pr(0)
	pr = pr/sum   &   cen = pr(0)
	prf = pr(1:nw-1)   &   prb = reverse(prf)	;call reverse
	rotpr = [prb,cen,prf]   &   npr = n_elements(rotpr)  
	if keyword_set(pl) then begin
		!p.multi=[0,1,2]
		plot,rotpr,psym = 2
	endif
;***CONVOLVE WITH SPECTRUM
	rotcv = fltarr(n_elements(s))   &   rotcv(np/2-npr/2) = rotpr
	nrotcv = n_elements(rotcv)
	rotcv = rotcv(1:nrotcv-2)
	sm = convol(s,rotpr)			;call convol
	if keyword_set(ot) then print,'Subscript where min of rotcv:',where(rotcv eq max(rotcv))
;***clip back to original spectrum
	sm = sm(nres + 2:np-nres-3)
	ssm = sm(0:npp-2)
	nw = ww(0:npp-2)
	ssm = spline(w,sm,ww)
	if keyword_set(pl) then begin
		plot,ww,ss
		oplot,ww,ssm-.5
		!p.multi=0
	endif
end



