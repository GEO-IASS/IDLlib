FUNCTION auto_range, x,  factor=fct
;+
; xrange = auto_range(x, factor=0.05)
;
; returns [x1,x2], where : 
;
;   x1 = min(x) - 0.05*(max(x)-min(x)) OR min(x) - 0.05*(min(x)) if min = max
;   x2 = max(x) + 0.05*(max(x)-min(x))
;
; May  5 1994 SGK
;-
;
IF NOT keyword_set(fct) THEN fct = 0.05
;
xmin = min(x, max = xmax)
dx = fct*(xmax-xmin)
IF dx EQ 0.0 THEN dx = fct*xmin
;
x1 = xmin - dx
x2 = xmax + dx
;
return, [x1, x2]
;
END
