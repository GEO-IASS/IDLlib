PRO make_legend, symbols, text, lines = lines, $
                 location = location, charsize = charsize
;
;+
; make_legend, symbols, text
;   lines:    list of line style
;   location: 1, 2, 3 or 4
;   charsize: character size
; 
; example:
;  make_legend, [4, 2], ["Ted's values", "Sylvain's values"]
;-
;
IF NOT keyword_set(location) THEN location = 1
IF NOT keyword_set(charsize) THEN charsize = 1
;
xcr = !x.crange
ycr = !y.crange
;
dx = xcr(1) - xcr(0)
dy = ycr(1) - ycr(0)
CASE location OF
  2: BEGIN
    xp = xcr(0)+0.55*dx
    yp = ycr(0)+0.05*dy
  END
  3: BEGIN
    xp = xcr(0)+0.55*dx
    yp = ycr(0)+0.95*dy
    dy = -dy
  END
  4: BEGIN
    xp = xcr(0)+0.05*dx
    yp = ycr(0)+0.95*dy
    dy = -dy
  END
  ELSE: BEGIN
    xp = xcr(0)+0.05*dx
    yp = ycr(0)+0.05*dy
  END
ENDCASE
;
IF keyword_set(lines) THEN BEGIN
  FOR i = 0, n_elements(symbols)-1 DO BEGIN
    xp0 = xp
    xp1 = xp+0.05*dx
    yp0 = yp
    IF !x.type THEN xp0 = 10^xp0
    IF !x.type THEN xp1 = 10^xp1
    IF !y.type THEN yp0 = 10^yp0
    oplot, [xp0, xp1], [1, 1]*yp0, $
      psym = -abs(symbols(i)), line = lines(i)
    xyouts, xp1, yp0, '  '+text(i), size = charsize
    yp = yp+dy*.025*charsize
  ENDFOR
ENDIF ELSE BEGIN
  FOR i = 0, n_elements(symbols)-1 DO BEGIN
    xp0 = xp
    yp0 = yp
    yp1 = yp-abs(dy)*.005*charsize
    IF !x.type THEN xp0 = 10^xp0
    IF !y.type THEN yp0 = 10^yp0
    IF !y.type THEN yp1 = 10^yp1
    oplot, [xp0], [yp0], psym = abs(symbols(i))
    xyouts, xp0, yp1, '  '+text(i), size = charsize
    yp = yp+dy*.025*charsize
  ENDFOR
ENDELSE
;
END

