PRO relscale, rx, ry, x, y
;
;+
; PRO relscale, rx, ry, x, y
;
; Relative scaling:
;   return data scaling (x,y) defined in terms of relative coords (rx,ry)
;
;-
IF !x.type EQ 1 THEN BEGIN
  dx = 10.^!x.crange(1)-10.^!x.crange(0)
  x  = 10.^!x.crange(0)+ rx*dx
ENDIF ELSE BEGIN 
  dx = !x.crange(1)-!x.crange(0)
  x  = !x.crange(0)+ rx*dx
ENDELSE
;
IF !y.type EQ 1 THEN BEGIN
  dy = 10.^!y.crange(1)-10.^!y.crange(0)
  y  = 10.^!y.crange(0)+ ry*dy
ENDIF ELSE BEGIN 
  dy = !y.crange(1)-!y.crange(0)
  y  = !y.crange(0)+ ry*dy
ENDELSE
;
END
