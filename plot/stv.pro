PRO Stv, img, xp, yp, true = true
;
;+
; Name:
;
;   STV
;
; Purpose:
;
;   Performs a "scaled" TV, namely a TV that will be properly scaled to work
;   whether the plotting device is an X window or the PostScript device.
;  
; Calling sequence:
;
;   STV, image, xposition, yposition
;
; Restriction:
;
;   The SWindow routine must be called first to establish the scaling factor
;   before using SPosition.
;
; Example:
;
;   IDL> image = randomu(seed,200,300)
;   IDL> swindow, 0, xsize=300, ysize=400
;   IDL> stv, image, 50, 50  
;   IDL> plot, findgen(10), /noerase $
;          position = sposition([50, 50, 250, 350]), /dev
;   IDL> sxyouts, 100, 200, 'this is at (100,200)'
;
; See also: SWindow, STVScl, SPosition, SXYOuts
;
;-
;
  COMMON Screen_params, screen_size, screen_factor
;
  IF n_elements(xp) EQ 0 THEN xp = 0
  IF n_elements(yp) EQ 0 THEN yp = 0
;
  IF (!D.flags AND 1) EQ 0 THEN $
    tv, img, xp, yp, true = true $
  ELSE BEGIN
    xps = float(xp)/screen_size(0)*!D.x_size
    yps = float(yp)/screen_size(1)*!D.y_size
    sz = size(img)
    xsz = float(sz(1))/screen_size(0)*!D.x_size
    ysz = float(sz(2))/screen_size(1)*!D.y_size
    tv, img, xps, yps, xsize = xsz, ysize = ysz, true = true, /device
  ENDELSE
;
END
