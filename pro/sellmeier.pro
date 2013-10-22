;Source http://arxiv.org/ftp/arxiv/papers/0805/0805.0096.pdf
;Temperature-dependent refractive index of CaF2 and Infrasil 301 
;Douglas B. Leviton∗, Bradley J. Frey, Timothy J. Madison
;lambda in microns, temp in kelvins
function sellmeier, lambda, temp, material

   if material eq 'CaF2' then begin
      if (where(lambda gt 5.6d or lambda lt .4d))[0] ne -1 then $
         message, 'lambda out of range. Interpolation required.'
      if (where(temp gt 300d or temp lt 25d))[0] ne -1 then $
         message, 'temp out of range. Interpolation required.'
   
		lTcoeff=[[7.94375d-2, 0.258039, 34.0169],$
			[-2.20758d-4, -2.12833d-3, 6.26867d-2],$
			[2.07862d-6, 1.20393d-5, -6.14541d-4],$
			[-9.60254d-9, -3.06973d-8, 2.31517d-6],$
			[1.31401d-11, 2.79793d-11, -2.99638d-9]]

		sTcoeff=[[1.04834, -3.32723d-3, 3.72693],$
			[-2.21666d-4, 2.34683d-4, 1.49844d-2],$
			[-6.73446d-6, 6.55744d-6, -1.47511d-4],$
			[1.50138d-8, -1.47028d-8, 5.54293d-7],$
			[-2.77255d-11, 2.75023d-11, -7.17298d-10]]
   endif else if material eq 'Infrasil 301' then begin
      if (where(lambda gt 3.6d or lambda lt .5d))[0] ne -1 then $
         message, 'lambda out of range. Interpolation required.'
      if (where(temp gt 300d or temp lt 35d))[0] ne -1 then $
         message, 'temp out of range. Interpolation required.'
         
		lTcoeff=[[4.500743d-3, 9.383735d-2, 9.757183],$
			[-2.825065d-4, -1.374171d-6, 1.864621d-3],$
			[3.136868d-6, 1.316037d-8, -1.058414d-5],$
			[-1.121499d-8, 1.252909d-11, 1.730321d-8],$
			[1.236514d-11, -4.641280d-14, 1.719396d-12]]
			
		sTcoeff=[[0.105962, 0.995429, 0.865120],$
			 [9.359142d-6, -7.973196d-6, 3.731950d-4],$
			 [4.941067d-8, 1.006343d-9, -2.010347d-6],$
			 [4.890163d-11, -8.694712d-11, 2.708606d-9],$ 
			 [1.492126d-13, -1.220612d-13, 1.679976d-12]]
			 
   endif else begin
      message, 'Unknown material'
   endelse

   T=double(temp)
   l=double(lambda)
   Tpowarr=T^indgen(5) ## (dblarr(3)+1d)

   n=sqrt( total( total(sTcoeff*Tpowarr,2)*l^2 /$
                   (l^2 - total(lTcoeff*Tpowarr,2)^2) ) +1d)

   return,n
end