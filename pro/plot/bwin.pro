PRO bwin, wno, wide = wide, tall = tall
;
;+
; bwin, [wno]: 
;
;         open a 900 by 850 'big' window.
;
;  /tall: open a  512 by 850 'tall' window
;  /wide: open a 1100 by 640 'wide' window
;-
IF n_elements(wno) EQ 0 THEN wno =  0
;
tall = keyword_set(tall)
wide = keyword_set(wide)
IF wide THEN BEGIN
  window, wno, xsize = 1100
  return
END

IF tall THEN BEGIN
  window, wno, ysize = 850
  return
END

window, wno, xsize = 900, ysize = 850
return

END
