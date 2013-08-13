PRO rxyouts, rxpos, rypos, string, $
             alignment=alignment, charsize=charsize, color=color
;
;+
; rxyouts: "relative" version of: 
;  
;    xyouts, xpos, ypos, string, $
;       alignment = alignment, charsize = charsize, color = color
;
;-
;
if not keyword_set(alignment) then alignment = 0.0
if not keyword_set(charsize)  then charsize  = 1.0
IF NOT keyword_set(color) THEN BEGIN
  IF !d.name EQ 'PS' THEN color = 0 ELSE color = !d.n_colors-1
ENDIF
;
relscale, rxpos, rypos, xpos, ypos
xyouts, xpos, ypos, string, $
  alignment = alignment, charsize = charsize, color = color
;
end
