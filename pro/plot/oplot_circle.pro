pro oplot_circle, xc, yc, radius, nsegs=nsegs, $
    linestyle=linestyle, $
    label=label, angle=label_angle
;+
; Name:
;
;  OPLOT_CIRCLE
;
; Purpose:
;
;   overplot a circle on the current plot
;
; Calling sequence:
;
;   oplot_circle, xc, yc, radius
;
; Inputs:
;
;  xc, yc, radius: center and radius, in data units
;
; Keywords:
;
;  linestyle: plot's linestyle
;  nsegs: no of segments to use to approximate a circle 
;         default: fix(radius*!pi)
;  label: labeling string 
;  angle: angle (degree) at which to put the label, default=+45
;
;-
;
if not keyword_set(nsegs) then nsegs=fix(radius*!pi)
if not keyword_set(linestyle) then linestyle=0
angles = findgen(nsegs)/(nsegs-1)*2*!pi
oplot,xc+radius*cos(angles),yc+radius*sin(angles),linestyle=linestyle
;
if keyword_set(label) then begin
  if not keyword_set(label_angle) then angle=!pi/2 $
  else angle=label_angle*!pi/180.
  xyouts,xc+radius*cos(angle),yc+radius*sin(angle),/data,label
endif
end
