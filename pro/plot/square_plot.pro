function square_plot, pos_in
;
;+
; Name:
;
;  SQUARE_PLOT
;
; Purpose:
;
;   restrict the plotting area to a relative square position
;
; Calling sequence:
;
;   dev_position = square_plot(position)
;
; Inputs:
;
;  position: 4 element position vector: [x0,x1,y0,y1]
;
; Output:
;
;  4 elements vector suitable for position=...,/dev specification
;
; Example:
;
;   dev_pos = square_plot([.04, .04, .46, .46])
;   plot, x, y, position=dev_pos, /dev
;-
;
on_error,2
pos = pos_in
if n_elements(pos) ne 4 then $
  message, 'ERROR: position must be a 4 elements vector'
;
if !d.x_size gt !d.y_size then begin
  pos(0) = pos(0)*!d.x_size
  pos(1) = pos(1)*!d.y_size
  pos(3) = pos(3)*!d.y_size
  pos(2) = pos(0) + pos(3) - pos(1)
end else begin
  pos(0) = pos(0)*!d.x_size
  pos(2) = pos(2)*!d.x_size
  pos(1) = pos(1)*!d.y_size
  pos(3) = pos(1) + pos(2) - pos(0)
endelse
;
return, pos
;
end

