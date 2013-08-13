PRO vline, xval, linestyle = linestyle, color = color
;
;+
;  vline, yval, linestyle = linestyle, color = color
;
; produce an vertical line at yval
;-
IF n_elements(xval) EQ 0 THEN xval = 0.
IF NOT keyword_set(linestyle) THEN linestyle = 0
IF NOT keyword_set(color) THEN BEGIN
  IF !d.name EQ 'PS' THEN color = 0 ELSE color = !d.n_colors-1
ENDIF
;
IF !y.type THEN $
  oplot, [1.,1.]*xval, 10.^!y.crange, linestyle = linestyle, color = color $
ELSE $
  oplot, [1.,1.]*xval, !y.crange, linestyle = linestyle, color = color
;
END
