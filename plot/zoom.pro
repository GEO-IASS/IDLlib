FUNCTION zoom, a, n1, n2,  sample=sample
;
;+
; zoom an array by factor(s) n1, [n2]
;
; za = zoom(a, n1 [, n2] [,/sample] )
;
; ie, tvscl,zoom(a,2)  equivalent to tvscl, zoom(a,2,2)
; or, tvscl,zoom(a,2,3)
;
; use /sample to prevent interpolation
; preserve symmetry in an odd sized array
;-
;
IF NOT keyword_set(sample) THEN sample = 0
sz = size(a)
IF sz(0) NE 2 THEN message, 'can only zoom 2D arrays'
;
IF n_params() EQ 1 THEN message,  'missing zoom factor'
;
IF n_params() EQ 2 THEN n2 = n1
;
IF n1 LT 0 THEN $
  nn1 = long(sz(1)/abs(n1)) $
ELSE $
  nn1 = long(sz(1)*n1)
;
IF n2 LT 0 THEN $
  nn2 = long(sz(2)/abs(n2)) $
ELSE $
  nn2 = long(sz(2)*n2)
;
k1 = sz(1) / n1 * n1 - 1
k2 = sz(2) / n2 * n2 - 1
za = rebin(a[0:k1, 0:k2], nn1, nn2, sample = sample)
;
IF NOT sample THEN BEGIN
  IF (sz(1) MOD 2) NE 0 THEN za = za(0:nn1-abs(n1), *)
  IF (sz(2) MOD 2) NE 0 THEN za = za(*, 0:nn2-abs(n2))
ENDIF
;
return, za
;
END
