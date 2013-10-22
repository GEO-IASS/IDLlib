pro eb_plot, x, y, s, serif = serif, length = srlen, xaxis = xaxis, $
             color = color, linestyle = linestyle, $
             positive = positive, negative = negative
;
;+
; Name:
;
;   EB_PLOT
;
; Purpose:
;
;   error-bar plotting (Y-direction only)
;
; Calling sequence:
;
;   EB_PLOT, X, Y, S
;
; Inputs:
;
;   X: vector of absices
;   Y: vector of ordinates
;   S: error-bar size (y-s to y+s, or x-s to x+s if XAXIS is set)
;
; Keyword:
;
;   XAXIS: if set, specify abcisses style error bars (x-axis)
;   SERIF: add serifs
;   COLOR: color to use
;   LINESTYLE: linestyle to use
;   LENGTH: relative length of the serifs, default : 0.005
;   POSITIVE: draw only postive (y+s, or x+s) error bars
;   NEGATIVE: draw only negative (y-s, or x-s) error bars
;
; Example:
;
;   plot,x,y,psym=4
;   eb_plot,x,y,s
;-
;
IF NOT keyword_set(srlen) THEN srlen = 0.005
IF NOT keyword_set(color) THEN BEGIN
  IF !d.name EQ 'PS' THEN color = 0 ELSE color = !d.n_colors-1
ENDIF
IF NOT keyword_set(linestyle) THEN linestyle = 0
;
serif = keyword_set(serif)
xaxis = keyword_set(xaxis)
positive = keyword_set(positive)
negative = keyword_set(negative)
;
kind = 0
IF positive THEN kind = kind+1
if negative THEN kind = kind-1
;
FOR i = 0, n_elements(x)-1 DO BEGIN
  IF xaxis THEN BEGIN
    CASE kind OF
     -1: rr = [x(i)-s(i),x(i)]
      0: rr = [x(i)-s(i),x(i)+s(i)]
      1: rr = [x(i)     ,x(i)+s(i)]
    ENDCASE
    oplot, rr, [y(i),y(i)], $
      color = color, linestyle = linestyle
    IF serif THEN BEGIN
      slen = srlen*(!y.crange(1)-!y.crange(0))
      IF kind NE 1 THEN BEGIN
        FOR is = 0, n_elements(x)-1 DO $
          oplot, [x(is)-s(is),x(is)-s(is)], [y(is)-slen,y(is)+slen], $
          color = color, linestyle = linestyle
      ENDIF
      IF kind NE -1 THEN BEGIN
        FOR is = 0, n_elements(x)-1 DO $
          oplot, [x(is)+s(is),x(is)+s(is)], [y(is)-slen,y(is)+slen], $
          color = color, linestyle = linestyle
      ENDIF
    ENDIF
  ENDIF ELSE BEGIN 
    CASE kind OF
     -1: rr = [y(i)-s(i),y(i)]
      0: rr = [y(i)-s(i),y(i)+s(i)]
      1: rr = [y(i)     ,y(i)+s(i)]
    ENDCASE
    oplot, [x(i),x(i)], rr, $
      color = color, linestyle = linestyle
    IF serif THEN BEGIN
      IF kind NE 1 THEN BEGIN
        slen = srlen*(!x.crange(1)-!x.crange(0))
        FOR is = 0, n_elements(x)-1 DO $
          oplot, [x(is)-slen,x(is)+slen], [y(is)-s(is),y(is)-s(is)], $
          color = color, linestyle = linestyle
      ENDIF
      IF kind NE -1 THEN BEGIN
        FOR is = 0, n_elements(x)-1 DO $
          oplot, [x(is)-slen,x(is)+slen], [y(is)+s(is),y(is)+s(is)], $
          color = color, linestyle = linestyle
      ENDIF
    ENDIF
  ENDELSE
ENDFOR
;
return
;
END
