
	;Number of points
	n=1000
	
	;Maximum r/lambda
	rolmax=60

	;Create an array of values for r/lambda
	x=(dindgen(n)-(n-1)/2. )*2d/(n-1)  *rolmax

	;Determine the sampling interval
	t=x[1]-x[0]
	
	;Create an array of frequencies as per IDL documentation on FFT()
	f=[reverse(-dindgen(n/2-1)-1), dindgen(n/2+1)]/n/t
	
	;Evaluate the electric field in two dimensions
	er2d=dblarr(n,n)
	for i=0,n-1 do for j=0,n-1 do er2d[i,j]=exp(-0.5d*( x[i]^2 +x[j]^2 )/4d)

	;Compute the analytic power per wavelength 
	apow2d=(8 * !DPI * exp(-2d*(!DPI*f*2)^2))^2/2d
	
	;Compute the FFT of the field and go ahead ans convert it to power
	pow2d=abs(shift(fft(er2d),-n/2-1,-n/2-1))^2/2d
	
	;Normalize the results of IDL's fft
	pow2d=pow2d*(8d * !DPI)^2/2d /max(pow2d)


	;Plot a slice of the electric field 
	plot,x,er2d[n/2,*],charsize=1.7,xrange=[-10,10],$
		title='E(r), normalized profile',xtitle='r/l',ytitle='E(r)/Eo',charthick=2

	window,1

	;Plot a slice of the power 
	plot,f,pow2d[n/2,*]/max(pow2d[n/2,*]),charsize=1.6,xrange=[-1,1],$
		title='Normalized power 0.5*(E(r)/Eo/lambda)^2 !C (solid, numeric, analytic X)' ,$
		ymargin=[3.2,4],xtitle='theta (radians)',ytitle='Normalized Power'
		
	;Overplot the analytic power
	oplot,f,apow2d,psym=7
	

end
