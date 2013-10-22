PRO plot3d, z, x, y, ax = ax, az = az, $
            xstyle = xstyle, ystyle = ystyle, zstyle = zstyle, $
            xrange = xrange, yrange = yrange, zrange = zrange, $
            xtitle = xtitle, ytitle = ytitle, ztitle = ztitle, $
            title = title, subtitle = subtitle, $
            psym = psym, symsize = symsize, charsize = charsize
;+
; PLOT3D, Z, X, Y
;
; makes a 3d point plot using a dummy
;    SURFACE, /SAVE 
; followed by a 
;    PLOTS, /T3D
;
; if [xyz]ranges are not set, uses SGK's AUTO_RANGE()
;
; The following keywords are supported:
;   AX, AZ, XSTYLE, YSTYLE, ZSTYLE, XRANGE, YRANGE, ZRANGE, 
;   XTITLE, YTITLE, ZTITLE, TITLE, SUBTITLE,
;   PSYM, SYMSIZE, CHARSIZE
;-
nz = n_elements(z)
IF n_elements(x) EQ 0 THEN x = findgen(nz)
IF n_elements(y) EQ 0 THEN y = findgen(nz)
;
IF n_elements(x) NE nz THEN message, '#-elem(x) <> #-elem(z)'
IF n_elements(y) NE nz THEN message, '#-elem(y) <> #-elem(z)'
;
IF NOT keyword_set(xrange) THEN xrange = auto_range(x)
IF NOT keyword_set(yrange) THEN yrange = auto_range(y)
IF NOT keyword_set(zrange) THEN zrange = auto_range(z)
;
IF NOT keyword_set(xstyle) THEN xstyle = 0
IF NOT keyword_set(ystyle) THEN ystyle = 0
IF NOT keyword_set(zstyle) THEN zstyle = 0
;
IF NOT keyword_set(ax) THEN ax = 30.
IF NOT keyword_set(az) THEN az = 30.
;
IF NOT keyword_set(symsize)  THEN symsize = 1.
IF NOT keyword_set(charsize) THEN charsize = 1.
;
IF NOT keyword_set(xtitle) THEN xtitle = ''
IF NOT keyword_set(ytitle) THEN ytitle = ''
IF NOT keyword_set(ztitle) THEN ztitle = ''
;
IF NOT keyword_set(title) THEN title = ''
IF NOT keyword_set(subtitle) THEN subtitle = ''
;
IF NOT keyword_set(psym) THEN psym = 0
;
zd = fltarr(2, 2)
xd = [0, 0]
yd = [0, 0]
SURFACE, zd, xd, yd, /SAVE, AX = AX, AZ = AZ, $
  XRANGE = XRANGE, XSTYLE = XSTYLE, $
  YRANGE = YRANGE, YSTYLE = YSTYLE, $
  ZRANGE = ZRANGE, ZSTYLE = ZSTYLE, $
  XTITLE = XTITLE, YTITLE = YTITLE, ZTITLE = ZTITLE, $
  TITLE = TITLE, SUBTITLE = SUBTITLE, CHARSIZE = CHARSIZE
PLOTS, x, y, z, /T3D, PSYM = PSYM, SYMSIZE = SYMSIZE
;
END
