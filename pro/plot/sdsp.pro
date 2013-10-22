PRO sdsp, img, wno = wno, xrange = xr, yrange = yr, $
          xsize = xsize, ysize = ysize, $
          nlevels = nlevels, zoom = zoomIn, sample = sample, $
          xtitle = xtitle, ytitle = ytitle, title = title
;+
;
; sdsp, img, wno = wno, xrange = xr, yrange = yr, $
;          nlevels = nlevels, zoom = zoomIn, sample = sample, $
;          xtitle = xtitle, ytitle = ytitle, title = title
;
; scaled display of a 2D array (ie image)
;
;   zoomIn can be either a scalar or a 2-elements array
;   if nlevels > 0, coutours are superposed
;
;-
sz = size(img)
IF sz(0) NE 2 THEN message,  'wrong image size'
;
IF n_elements(zoomIn) EQ 0 THEN zoomVals = 1 ELSE zoomVals = zoomIn
IF n_elements(zoomVals)   NE 2 THEN zoomVals = replicate(zoomVals(0), 2)
;
IF NOT keyword_set(wno)     THEN wno = 0
IF NOT keyword_set(nlevels) THEN nlevels = 0
IF NOT keyword_set(xr)      THEN xr = [0, sz(1)-1]
IF NOT keyword_set(yr)      THEN yr = [0, sz(2)-1]
IF NOT keyword_set(xtitle)  THEN xtitle = ''
IF NOT keyword_set(ytitle)  THEN ytitle = ''
IF NOT keyword_set(title)   THEN title = ''
;
sample = keyword_set(sample)
;
dx = float(xr(1)-xr(0))/(sz(1)/2)/2
dy = float(yr(1)-yr(0))/(sz(2)/2)/2
;
zsz = sz(1:2)*zoomVals
IF NOT sample THEN BEGIN
  IF (sz(1) MOD 2) NE 0 THEN zsz(0) = zsz(0)-zoomVals(0)+1
  IF (sz(2) MOD 2) NE 0 THEN zsz(1) = zsz(1)-zoomVals(1)+1
ENDIF
;
IF n_elements(xsize) EQ 0 THEN xsize = sz(1)*zoomVals(0)+100
IF n_elements(ysize) EQ 0 THEN ysize = sz(2)*zoomVals(1)+100
;
swindow, wno, xs = xsize, ys = ysize
plot, [0], [0], /nodata, $
  xr = xr+[-dx, dx]/2, yr = yr+[-dy, dy]/2, /xstyle, /ystyle, $
  xtitle = xtitle, ytitle = ytitle, title = title, $
  position = sposition([69, 49, 71+zsz(0), 51+zsz(1)]), $
  /device, $
  xticklen = -10./sz(2)/zoomVals(1), $
  yticklen = -10./sz(1)/zoomVals(0)
stvscl, zoom(img, zoomVals(0), zoomVals(1), sample = sample), 70, 50
;
IF nlevels GT 0 THEN BEGIN
  xvals = findgen(sz(1))/(sz(1)-1)*(xr(1)-xr(0))+xr(0)
  yvals = findgen(sz(2))/(sz(2)-1)*(yr(1)-yr(0))+yr(0)
  zr = [min(img), max(img)]
  levels = findgen(nlevels)/(nlevels-1)*(zr(1)-zr(0))+zr(0)
  idx = where(levels GE 0, cnt)
  IF cnt GT 0 THEN $
    contour, img, xvals, yvals, /overplot, levels = levels(idx), c_lines=1
  idx = where(levels LT 0, cnt)
  IF cnt GT 0 THEN $
    contour, img, xvals, yvals, /overplot, levels = levels(idx), c_lines=1
ENDIF
;
END


