PRO xoplot, x, y, psym = psym, linestyle = linestyle
;+
; XOPLOT_IO, X, Y
;
;   logarithmic overplot x vs y
;
; accept also:
;
;  psym, linestyle
;-
;
; ---------------------------------------------------------------------------
;
IF NOT keyword_set(psym)      THEN psym = 0
IF NOT keyword_set(linestyle) THEN linestyle = 0
;
; ---------------------------------------------------------------------------
;
COMMON c_xplot_io, ymin
;
idx = where(y LT 0, cnt)
absy = abs(y)
;
IF NOT keyword_set(ymin) THEN ymin = min(absy)
IF NOT keyword_set(ymax) THEN ymax = max(absy)
;
yy = abs(y >  ymin)
IF cnt GT 0 THEN $
  yy(idx) = -(ymin^2/y(idx))
;
oplot, x, yy, psym = psym, linestyle = linestyle
;
END
