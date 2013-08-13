PRO hline, yval, linestyle = linestyle, color = color
;
;+
;  hline, yval, linestyle = linestyle, color = color
;
; produce an horizontal line at yval
;-
;
IF n_elements(yval) EQ 0 THEN yval = 0.
IF NOT keyword_set(linestyle) THEN linestyle = 0
IF NOT keyword_set(color) THEN BEGIN
  IF !d.name EQ 'PS' THEN color = 0 ELSE color = !d.n_colors-1
ENDIF
;
IF !x.type THEN $
  oplot, 10.^!x.crange, [1.,1.]*yval, linestyle = linestyle, color = color $
ELSE $
  oplot, !x.crange, [1.,1.]*yval, linestyle = linestyle, color = color
;
END
