FUNCTION get_cpos, oplot=oplot, psym=psym,  print=print
;+
; get the cursor postion, and overplot it if /oplot set
;-
cursor, x, y, /down
;
IF keyword_set(print) THEN print, 'Location: ', x, y
IF keyword_set(oplot) THEN BEGIN
  IF NOT keyword_set(psym) THEN psym = 4
  oplot, [x], [y], psym = psym
ENDIF
return, [x, y]
END
