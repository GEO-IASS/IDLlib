PRO Swindow, wno, xsize = xsize, ysize = ysize, xpos = xpos, ypos = ypos, $
             pixmap = pixmap
;
;+
; Name:
;
;   SWindow
;
; Purpose:
;
;   Performs a "scaled" WINDOW, namely a WINDOW that allows plots to be
;   properly scaled to work whether the plotting device is an X-window or the
;   PostScript device. 
;  
; Calling sequence:
;
;   SWindow, window_index, $
;            xsize = xsize, ysize = ysize, xpos = xpos, ypos = ypos
;
; Keywords (Optional):
;
;   XSIZE, YSIZE: specify the window size
;   XPOS, YPOS:   specify the window position (for X-windows only)
;
; Restriction:
;
;   Only one scaling factor is kept for scaling (ie the one corresponding to
;   the last call to swindow)
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
; See also: STV, STVScl, SPosition, SXYOuts
;
; History:
;   Apr 28 1994 SGK: added xpos and ypos keywords
;-
;
common screen_params, screen_size, screen_factor
;
if n_elements(wno) NE 1 then wno = 0
if not keyword_set(xsize) then xsize=640
if not keyword_set(ysize) then ysize=512
;
IF !d.name EQ 'X' THEN BEGIN
  pixmap = keyword_set(pixmap)
  IF keyword_set(xpos) AND keyword_set(ypos) THEN $
    window, wno, xsize = xsize, ysize = ysize, $
    xpos = xpos, ypos = ypos, pixmap = pixmap $
  ELSE IF keyword_set(xpos) THEN $
    window, wno, xsize = xsize, ysize = ysize, xpos = xpos, pixmap = pixmap $
  ELSE IF keyword_set(ypos) THEN $
    window, wno, xsize = xsize, ysize = ysize, ypos = ypos, pixmap = pixmap $
  ELSE  $
    window, wno, xsize = xsize, ysize = ysize, pixmap = pixmap
ENDIF
;
screen_size   = [xsize, ysize]
screen_factor = [!d.x_size/float(screen_size(0)), $
                 !d.y_size/float(screen_size(1))]
end
