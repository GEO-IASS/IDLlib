function wdump, bw=bw
;
;+
; Name:
;
;   WDUMP
;
; Purpose:
;
;   dump the content of the currently selected window
;
; Calling sequence:
;
;   WDUMP
;
; Keywords:
;
;   bw: if set, invert black/white to white/black
;
; Example:
;
;   img = wdump(/bw)
;   ps_open
;   tvscl,img
;   ps_close
;-
;
img = tvrd()
if keyword_set(bw) then begin
  iw = where(img eq !d.n_colors-1)
  img(iw) = byte(1)
  img=(byte(1) - img)*byte(!d.n_colors-1)
endif
return, img
end
