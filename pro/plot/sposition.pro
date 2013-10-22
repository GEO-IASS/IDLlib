function sposition, position
;
;+
; Name:
;
;   SPosition
;
; Purpose:
;
;   Returns the appropriate position vector to be used in "position=[],/dev"
;   specification, but properly scaled to work whether the plotting device
;   is an X window or the PostScript device.
;  
; Calling sequence:
;
;   scaled_position = SPosition(position)
;
; Input:
; 
;   position: 4 element position vector in X-window device coords
; 
; Output:
;
;  4 elements vector suitable for position=...,/dev specification
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
; See also: SWindow, STV, STVScl, SXYOuts
;-
;
  COMMON Screen_params, screen_size, screen_factor
;
  IF n_elements(screen_factor) EQ 0 THEN $
    message, 'scaling factor not established, call SWindow first'
  
  return, position*[screen_factor(0), screen_factor(1), $
                    screen_factor(0), screen_factor(1)]
END
