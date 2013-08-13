PRO put_id, upper=upper, right=right, size=size
;
;+
; Name:
;            Put_ID
;
; Purpose:
;   Put an ID (date) in the corner of a plot
;
; Calling sequence:
;   Put_Id, upper=upper, right=right, size=size
;
; Used by PS_Close
;
;-
;
  IF NOT keyword_set(size) THEN size = 0.5
  x = 0
  y = 0
  al = 0
  IF keyword_set(upper) THEN y = 1-.014*size
  IF keyword_set(right) THEN BEGIN
    x = 1
    al = 1
  ENDIF
  user = getenv('USER')
  IF user EQ '' THEN spawn, /noshell, ['whoami'], user
  host = getenv('HOST')
  IF host EQ '' THEN spawn, /noshell, ['hostname'], host
  id = systime()+' '+user+'@'+host
  xyouts, x, y, /normal, id, charsize = size, alignment = al
END
