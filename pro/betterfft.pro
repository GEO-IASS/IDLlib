pro betterFFT, x, y, FTy, freq

	dx=x[1]-x[0]
	n=n_elements(x)
	norm_fact=1d/dx/n
	
	n_even=n+1 mod 2
	
	freq_max=1d/2d/dx
	freq_min = n_even ? freq_max*(n-2d)/n : -freq_max 	; not 100% on false value
	freq = dindgen(n)/(n-1) * (freq_max-freq_min) + freq_min


	shft = n_even ? n/2 - 1 : -1								; FALSE VALUE NOT CORRECT
	  

	FTy=shift( fft(y), shft)
	FTy = abs(FTy)/ norm_fact

end

function betterFFT2D, x, y, FTy, freq=freq

	dx=x[1]-x[0]
	n=n_elements(x)
	norm_fact=1d/n/dx
	
	n_even=n+1 mod 2
	
	freq_max=1d/2d/dx
	freq_min = n_even ? -freq_max*(n-2d)/n : -freq_max 	; not 100% on false value
	freq = dindgen(n)/(n-1) * (freq_max-freq_min) + freq_min


	shft = n_even ? n/2 - 1 : -1								; FALSE VALUE NOT CORRECT
	  

	FTy=shift( fft(y), shft, shft)
	;print,max(abs(fty)*n*dx/!dpi)
	print,max(abs(fty))/ norm_fact
	FTy = abs(FTy) / norm_fact

	return, FTy
end

function Airyi,i,x

	wxn=where(x lt 0d)
	wxp=where(x ge 0d)

	y=dblarr(n_elements(x))
	
	if wxp[0] ne -1 then $	
		y[wxp]=sqrt(x[wxp]/3d)*beselk(2d*x[wxp]^(3/2d)/3d,abs(i))/!DPI

	if wxn[0] ne -1 then $	
		y[wxn]=sqrt(abs(x[wxn]))*(beselj(2d*abs(x[wxn])^(3/2d)/3d,  i)+$
							 		beselj(2d*abs(x[wxn])^(3/2d)/3d,- i))/3d
							 		
	return, y
	
end

function airy, r,f,rad_apature,l

	m=!DPI*rad_apature/l*r/sqrt(f^2+r^2)
	return, (!DPI*rad_apature^2 * BeselJ(2d*m,1)/m)
end


function cir_step, x, y, r

	return, x^2+y^2 le r^2

end




	

	n=2000	
	min_x=-750
	max_x=750
	rad_apature=.243
	rdish=50
	l=.243
	f=65
	pos=dindgen(n)/(n-1) * (max_x-min_x) + min_x
	apertureFnotap=dblarr(n,n)
	apertureFtap=dblarr(n,n)
	
	for i=0,n-1 do for j=0,n-1 do apertureFnotap[i,j]=cir_step(pos[i],pos[j],rdish)
	ftynotap=betterFFT2D(pos,apertureFnotap,freq=freq)
	
	for i=0,n-1 do for j=0,n-1 do apertureFtap[i,j]=airy(sqrt(pos[i]^2+pos[j]^2),f,rad_apature,l)
	ftytap=betterFFT2D(pos,apertureFtap*apertureFnotap,freq=freq)
	
	ls=[0,2]
	cs=1.4
	!p.multi=[0,1,2]
	ps_open,file='./Desktop/tst.eps',/encapsulated,offsets=[1,.5]
;	window,0
	plot,pos,apertureFtap[n/2-1,*]/max(apertureFtap),charsize=cs,$
		title='Aperture Function of Telescope',$
		ytitle='Aperture Response',$
		xtitle='Radial position on dish (m)',xrange=[-50,50]
	oplot,pos,apertureFnotap[n/2-1,*]/max(apertureFnotap),linestyle=ls[1]
	legend,['Tapered','Untapered'],linestyle=ls,chars=cs,/bottom,/center
	
;	window,1
	plot,freq,ftynotap[n/2-1,*]/max(ftynotap),charsize=cs,$
		title='Angular respose pattern of antenna',$
		xtitle='Position angle from beam axis (rad)',$
		ytitle='Antenna Response (normalized to untapered beam response)',linestyle=ls[1],xrange=[-.1,.1]
	oplot,freq,ftytap[n/2-1,*]/max(ftynotap)
	legend,['Tapered','Untapered'],linestyle=ls,chars=cs,/right

	ps_close,/noid,/noprint
	!p.multi=0
	ps_open,file='./Desktop/tst1.eps',/encapsulated,offsets=[1,.5]
	shade_surf,ftytap[where(freq le .1 and freq ge -.1),min(where(freq le .1 and freq ge -.1)):max(where(freq le .1 and freq ge -.1))]/max(ftynotap),freq[where(freq le .1 and freq ge -.1)],freq[where(freq le .1 and freq ge -.1)],charsize=cs+1,$
		title='Angular respose of tapered antenna',$
		xtitle='Position angle from beam axis (rad)',$
		ytitle='Position angle from beam axis (rad)',$
		ztitle='Antenna Response!C(normalized to untapered beam response) ',xr=[-.1,.1],yr=[-.1,.1]
	ps_close,/noid,/noprint
	!p.multi=0
	ps_open,file='./Desktop/tst2.eps',/encapsulated,offsets=[1,.5]		
	shade_surf,ftynotap[where(freq le .1 and freq ge -.1),min(where(freq le .1 and freq ge -.1)):max(where(freq le .1 and freq ge -.1))]/max(ftynotap),freq[where(freq le .1 and freq ge -.1)],freq[where(freq le .1 and freq ge -.1)],charsize=cs+1,$
		title='Angular respose of untapered antenna',$
		xtitle='Position angle from beam axis (rad)',$
		ytitle='Position angle from beam axis (rad)',$
		ztitle='Normalized Antenna Response ',xr=[-.1,.1],yr=[-.1,.1]

	ps_close,/noid,/noprint

end



		