PRO sxyouts, xpos, ypos, string, $
             alignment=alignment, charsize=charsize, color=color
;
;+
; sxyouts: "scaled" version of: 
;  
;    xyouts, /dev, xpos, ypos, string, $
;       alignment = alignment, charsize = charsize, color = color
;
;  when used in conjuction with `swindow', sxyouts will properly position and
;  scale the image on PostScript output to match output on the screen.
;  Note that position are asumed to be in 'device' units
;
;  see also: swindow, stv, stvscl, sposition
;-
;
common screen_params, screen_size, screen_factor
;
;
if not keyword_set(alignment) then alignment = 0.0
if not keyword_set(charsize)  then charsize  = !p.charsize
IF NOT keyword_set(color) THEN BEGIN
  IF !d.name EQ 'PS' THEN color = 0 ELSE color = !d.n_colors-1
ENDIF
;
xd = xpos*screen_factor(0)
yd = ypos*screen_factor(1)
xyouts, xd, yd, /dev, string, $
  alignment = alignment, charsize = charsize, color = color

end
