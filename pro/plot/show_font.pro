PRO show_font, nfont, symbol = symbol, charsize = charsize
;+
; show_font, n
;
;  show the characters in the font N
;
; Keyword:
;
; symbol: if set, put a !m (for PS symbols)
;
;  May  3 1994 / Apr 28 1997 SGK
;-
;
on_error, 1
symbol = keyword_set(symbol)
IF not keyword_set(charsize) THEN charsize = 2.5
IF nfont LT 3 THEN message, 'no such font: '+string(nfont)
;
sf = string(nfont, format = '(i3)')
IF nfont LT 100 THEN sf = string(nfont, format = '(i2)')
IF nfont LT  10 THEN sf = string(nfont, format = '(i1)')
;
erase
bchr = 32B
dy =0.9/6/3
FOR j = 0, 5 DO BEGIN
  y = j*0.9/6 + 2*dy
  FOR i = 0, 31 DO BEGIN
    char = string(bchr)
    IF char EQ '!' THEN char = '!!'
    x = i*0.9/32 + 0.05
    IF symbol THEN schr = '!M'+char ELSE schr = char
    xyouts, x, y+dy, /norm, '!'+sf+schr, charsize = charsize
    xyouts, x, y, /norm, '!3'+char
    IF i MOD 8 EQ 0 THEN xyouts, x, y-dy/2, /norm, bchr, $
      charsize = 1.2, alignment = 0.5
    bchr =  bchr+1B
  ENDFOR
  IF bchr EQ 128 THEN bchr = 160B
ENDFOR
;
IF symbol THEN sf = sf+'!!m'
;
xyouts, .05, .015, '!3font: !!'+sf, /norm, charsize = charsize
;
END
