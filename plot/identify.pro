FUNCTION identify, xx, yy, markit=markit, psym=psym, loop=loop
;
;+
; yx = identify(xx, yy, [/markit], [psym=], /loop)
;
; identify points on a plot
;-
;
IF NOT keyword_set(psym) THEN psym = 4
;
xy = convert_coord(xx, yy, /data, /to_normal)
;
IF keyword_set(loop) THEN BEGIN
  print, 'Click outside boudaries to terminate'
  iwhs = -1
  xm = !x.crange
  ym = !y.crange
  IF !x.type EQ 1 THEN xm = 10^xm
  IF !y.type EQ 1 THEN ym = 10^ym
ENDIF
;
loop:
cursor, x0, y0, /down, /normal
dist2 = (double(xy(0, *))-x0)^2+(double(xy(1, *))-y0)^2
junk = min(dist2, iwhere)
;
xxyy0 = convert_coord(x0, y0, /normal, /to_data)
xx0 = xxyy0(0, 0)
yy0 = xxyy0(1, 0)
;
IF keyword_set(loop) THEN BEGIN
  IF xx0 LT xm(0) THEN return, iwhs(1:*)
  IF xx0 GT xm(1) THEN return, iwhs(1:*)
  IF yy0 LT ym(0) THEN return, iwhs(1:*)
  IF yy0 GT ym(1) THEN return, iwhs(1:*)
  iwhs = [iwhs, iwhere]
ENDIF
;
IF keyword_set(markit) THEN oplot, [xx(iwhere)],[yy(iwhere)], psym = psym
;
IF keyword_set(loop) THEN GOTO, loop
;
return, iwhere
;
END
