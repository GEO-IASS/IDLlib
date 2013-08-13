PRO xplot_io, xin, yin, ymin = ymin, ymax = ymax, yxmar = yxmar, $
              xstyle = xstyle, xrange = xrange, $
              psym = psym, linestyle = linestyle, $
              xtitle = xtitle, ytitle = ytitle, title = title 
;+
; XPLOT_IO, X, Y
;
;   logarithmic plot x vs y, works when y is not always positive
;
; Keywords:
;
;   ymin = set plot minimun
;   ymax = set plot maximun
;   yxmar = Y extra margin, default 0.1
;
; accept also:
;
;   xstyle, xrange, psym, linestyle,xtitle, ytitle, title
;-
;
; ---------------------------------------------------------------------------
;
IF NOT keyword_set(psym)      THEN psym = 0
IF NOT keyword_set(yxmar)     THEN yxmar = 0.1
IF NOT keyword_set(xstyle)    THEN xstyle = !x.style
IF NOT keyword_set(xrange)    THEN xrange = !x.range
IF NOT keyword_set(linestyle) THEN linestyle = 0
IF NOT keyword_set(xtitle)    THEN xtitle = ''
IF NOT keyword_set(ytitle)    THEN ytitle = ''
IF NOT keyword_set(title)     THEN title = ''
;
; ---------------------------------------------------------------------------
;
COMMON c_xplot_io, c_ymin
;
on_error, 2
;
nin = n_elements(xin)
IF n_elements(yin) EQ 0 THEN BEGIN
  IF nin EQ 0 THEN message, 'Incorrect number of arguments (need at least 1).'
  x = findgen(nin)
  y = xin
ENDIF ELSE BEGIN
  x = xin
  y = yin
ENDELSE
IF n_elements(x) LE 1 THEN message, 'Error: #(X) <= 1'
IF n_elements(y) LE 1 THEN message, 'Error: #(Y) <= 1'
IF n_elements(x) GT n_elements(y) THEN message, 'Warning: #(X) > #(Y)', /info
;
IF xrange(0) NE xrange(1) THEN BEGIN
  idx =  where(x GE xrange(0) AND x LE xrange(1),  cnt)
  IF cnt EQ 0 THEN message, 'No point inside xrange.'
;
  IF cnt LT nin THEN BEGIN
    x = x(idx)
    y = y(idx)
  ENDIF
ENDIF
;
absy = abs(y)
;
IF NOT keyword_set(ymin) THEN ymin = min(absy)
IF NOT keyword_set(ymax) THEN ymax = max(absy)
;
IF ymin LE 0 THEN message, 'Ymin <= 0'
IF ymin EQ ymax THEN message, 'Ymax = Ymin'
;
dy = alog10(ymax)-alog10(ymin)
ymin = 10.^(alog10(ymin) - yxmar*dy)
;
idx = where(y LT -ymin, cnt)
;
c_ymin = ymin
;
dy = alog10(ymax)-alog10(ymin)
ycmax = 10.^(alog10(ymax) + yxmar*dy)
yy = abs(y >  ymin)
;
IF cnt LE 0 THEN BEGIN
  ycmin = 10.^(alog10(ymin) - yxmar*dy)
  ycr = [ycmin, ycmax]
  plot_io, x, yy, yr = ycr, xstyle = xstyle, ystyle = 5, $ 
    psym = psym, linestyle = linestyle, $
    ytick_get = yticks, $
    xtitle = xtitle, xrange = xrange, title = title
  nticks = n_elements(yticks)
  ynames = string(round(alog10(yticks)), format = ("('10!u',i3)"))
  axis, yaxis = 0, /ystyle, !x.crange(0), yr = ycr, $
    ytickname = ynames, ytitle = ytitle
  axis, yaxis = 1, /ystyle, !x.crange(1), ytickname = replicate(' ', nticks)
  return
ENDIF
;
ycmin = 10.^(alog10(ymin) - (1+yxmar)*dy)
yy(idx) = -(ymin^2/y(idx))
ycr = [ycmin, ycmax]
;
plot_io, x, yy, xstyle = xstyle, yr = ycr, ystyle = 5, $ 
  psym = psym, linestyle = linestyle, $
  xtitle = xtitle, xrange = xrange, title = title
;
xsaved = !x
ysaved = !y
psaved = !p
;
xcr = !x.crange
oplot, xcr, [ymin, ymin]
;
yw = !y.window
!y.window(0) = (yw(0)+yw(1))/2.
!p.position = [!x.window(0),!y.window(0), !x.window(1), !y.window(1)]
;
yr = [ymin,ycmax]
plot_io, [1], [1], xstyle=4, ystyle=5, yr=yr, /noerase, $
  ytick_get = yticks
;
nticks = n_elements(yticks)
ynames = string(round(alog10(yticks)), format = ("('+10!u',i3)"))
axis, yaxis = 0, /ystyle, !x.crange(0), ytickname = ynames, ytitle = ytitle
axis, yaxis = 1, /ystyle, !x.crange(1), ytickname = replicate(' ', nticks)
;
!y.window(0) = yw(0)
!y.window(1) = (yw(0)+yw(1))/2.
!p.position = [!x.window(0),!y.window(0), !x.window(1), !y.window(1)]
;
yr = [ycmax, ymin]
idx = nticks-indgen(nticks)-1
ynames = string(round(alog10(yticks(idx))), format = ("('-10!u',i3)"))
plot_io, [1], [1], xstyle=4, ystyle=1, yr=yr, /noerase, $
  ytickname = ynames
;
!x = xsaved
!y = ysaved
!p = psaved
;
END
