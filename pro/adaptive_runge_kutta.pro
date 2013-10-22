;Fifth-order Runge-Kutta step with monitoring of local 
;truncation error to ensure accuracy and adjuststepsize. 
;Input are the dependent variable vector y[1..n] and its derivative dydx[1..n] 
;at the starting value of the independent variable x. Also input are the 
;stepsize to be attempted htry, the required accuracy eps, 
;and the vector yscal[1..n] against which the error is scaled. 
;On output, y and x are replaced by their new values, hdid is the 
;stepsize that was actually accomplished, and hnext is the estimated
;next stepsize. derivs is the user-supplied routine that computes the
;right-hand side derivatives.
pro rkqs, y, dydx, x, htry, eps, yscal, hdid, hnext,  deriv_func

	compile_opt IDL2, HIDDEN
	COMMON RK_SOLVER, ERRCON, SAFETY, PGROW, PSHRNK


	h=htry														;	Set stepsize to the initial trial value. 
	
	repeat begin
		rkck, y, dydx, x, h, ytemp, yerr, deriv_func	;	Take a step. 
		errmax=max(abs(yerr/yscal))						;	Evaluate accuracy. 			
		errmax /= eps											;	Scale relative to required tolerance. 
		if errmax le 1d then break							;	Step succeeded. Compute size of next step. 
		
		htemp=SAFETY*h*errmax^PSHRNK						; Truncation error too large, reduce stepsize.
		h = h ge 0d ? (htemp > 0.1d*h) : (htemp < 0.1d*h)	;No more than a factor of 10.
		
		xnew=x+h
		
		if xnew eq x then begin
			message,"stepsize underflow in rkqs"
		endif
		
	endrep until 0

	hnext = errmax gt ERRCON ? SAFETY*h*errmax^PGROW : 5d*h
	hdid=h
	x+=hdid 
	y=ytemp 

end


;Given values for n variables y[1..n] and their 
;derivatives dydx[1..n] known at x, use the fifth-order 
;Cash-Karp Runge-Kutta method to advance the solution over 
;an interval h and return the incremented variables as yout[1..n]. 
;Also return an estimate of the local truncation error in yout using
;the embedded fourth-order method. The user supplies the routine derivs(x,y,dydx), 
;which returns derivatives dydx at x.
pro rkck, y, dydx, x, h, yout, yerr, deriv_func

	COMPILE_OPT IDL2, HIDDEN

	a2=0.2d
	a3=0.3d
	a4=0.6d
	a5=1.0d
	a6=0.875d
	b21=0.2d
	b31=3.0/40.0d
	b32=9.0/40.0d
	b41=0.3d
	b42 = -0.9d
	b43=1.2d
	b51 = -11.0/54.0d
	b52=2.5d
	b53 = -70.0/27.0d
	b54=35.0/27.0d
	b61=1631.0/55296.0d
	b62=175.0/512.0d
	b63=575.0/13824.0d
	b64=44275.0/110592.0d
	b65=253.0/4096.0d
	c1=37.0/378.0d
	c3=250.0/621.0d
	c4=125.0/594.0d
	c6=512.0/1771.0d
	dc1=c1-2825.0/27648.0d
	dc3=c3-18575.0/48384.0d
	dc4=c4-13525.0/55296.0d
	dc5 = -277.00/14336.0d
	dc6=c6-0.25d
	
	
	ytemp=y+b21*h*dydx									;First Step
	
	ak2=call_function(deriv_func, x+a2*h, ytemp) ;Second Step
	
	ytemp=y+h*(b31*dydx+b32*ak2)
	ak3=call_function(deriv_func, x+a3*h, ytemp)	;Third step
	
	ytemp=y+h*(b41*dydx+b42*ak2+b43*ak3)
	ak4=call_function(deriv_func, x+a4*h, ytemp)	;Fourth step
	
	ytemp=y+h*(b51*dydx+b52*ak2+b53*ak3+b54*ak4)
	ak5=call_function(deriv_func, x+a5*h, ytemp)	;Fifth step
	
	ytemp=y+h*(b61*dydx+b62*ak2+b63*ak3+b64*ak4+b65*ak5)
	ak6=call_function(deriv_func, x+a6*h, ytemp)	;Sixth step
	
	;Accumulate increments with proper weights.
	yout=y+h*(c1*dydx+c3*ak3+c4*ak4+c6*ak6)
		
	;Estimate error as difference between fourth and fifth order methods.
	yerr=h*(dc1*dydx+dc3*ak3+dc4*ak4+dc5*ak5+dc6*ak6)


end



;User storage for intermediate results. Preset kmax and dxsav in the calling program. 
;If kmax ̸= 0 results are stored at approximate intervals dxsav in the arrays xp[1..kount],
; yp[1..nvar] [1..kount], where kount is output by odeint. Defining declarations for these 
; variables, with memory allocations xp[1..kmax] and yp[1..nvar][1..kmax] for the arrays, 
; should be in the calling program.

 
 

;+
; :Description:
;		Runge-Kutta driver with adaptive stepsize control. 
;		Integrate starting values ystart[1..nvar] from x1 to x2 
;		with accuracy eps, storing intermediate results in global variables. 
;		h1 should be set as a guessed first stepsize, hmin as the minimum 
;		allowed stepsize (can be zero). On output nok and nbad are the number 
;		of good and bad (but retried and fixed) steps taken, and ystart is 
;		replaced by values at the end of the integration interval. derivs 
;		is the user-supplied routine for calculating the right-hand side 
;		derivative, while rkqs is the name of the stepper routine to be used.
;		
;		Adapted from Num Recip in C. Ugh.
;		
; :Params:
;    ystart
;    x1
;    x2
;    eps
;    h1
;    hmin
;    nok
;    nbad
;    deriv_func
;
; :Keywords:
;    xeval
;    yeval
;
; :Author: J. Bailey, placed in public domain 12/5/09
;-
function adaptive_runge_kutta, ystart, x1, x2, eps, h1, hmin, nok, nbad, deriv_func, $
										xeval=xp, yeval=yp

	COMPILE_OPT IDL2

	COMMON RK_SOLVER, ERRCON, SAFETY, PGROW, PSHRNK
	SAFETY=0.9d
	PGROW=-0.2d
	PSHRNK=-0.25d
	ERRCON=(5d/SAFETY)^(1d/PGROW)
	
	MAXSTP=10000
	TINY=1.0d-30
	
	xp=dblarr(MAXSTP)
	yp=dblarr(n_elements(ystart),MAXSTP)
	
	x=x1
	h= x2 >x1 ? abs(h1) : -abs(h1)
	nok = 0
	nbad = 0
	kount = 0 
	kmax=MAXSTP	;maximum number of points to keep
	dxsav=TINY	;smallest step to save
	
	y=ystart
	
	if kmax gt 0 then xsav=x-dxsav*2d	;	Assures storage of first step. 
	
	for nstp=1, MAXSTP do begin	;	Take at most MAXSTP steps.
	
		dydx=call_function(deriv_func, x, y)
	
		;Scaling used to monitor accuracy.
		;This general-purpose choice can be modified if need be. 	
		yscal=abs(y)+abs(dydx*h)+TINY 
			
	
		if kmax gt 0 and kount lt kmax-1 and abs(x-xsav) gt abs(dxsav) then begin
			xp[kount]=x		;	Store intermediate results. 
			yp[*,kount++]=y
			xsav=x
		endif
		
		if (x+h-x2)*(x+h-x1) gt 0d then h=x2-x;	If stepsize can overshoot, decrease.
	
		rkqs, y, dydx, x, h, eps, yscal, hdid, hnext, deriv_func 
	
		if (hdid eq h) then nok++ else nbad++ 
		
		if (x-x2)*(x2-x1) ge 0d then begin	;Are we done?

			if kmax ne 0 then begin
				xp[kount]=x							;	Save final step.
				yp[*,kount++]=y
			endif

			xp=xp[indgen(kount)]
			yp=yp[*,indgen(kount)]
			return,y									;Normal exit.
		endif
		
		if abs(hnext) le hmin then begin
			message,"Step size too small in odeint",/info
			retun
		endif
			
		h=hnext;
	endfor
	message,"Too many steps in routine odeint"



end
