PRO Setxfont, fontname,  reset = reset,  defcmd =  defcmd, verbose = verbose
;
;+  
; Name:
;
;   SetXFont
;
; Purpose:
;
;  set an X font, but checks first if !D.name is 'X'
;  
; Calling sequence:
;
;   SetXFont, fontName
;
; Input:
;
;   fontName= <string> - name of valid X font (as per xlsfonts, or xfontsel)
;
; Keywords:
;
;   RESET   - flag, if set reset from to vector font (size equiv to 8x13)
;   VERBOSE - flag, if set chat about what it's doing
;   DEFCMD  = <string> - command to execute if no fontName is provided
;                       default value is '/usr/bin/X11/xfontsel'
;-
  on_error, 1
  IF !D.name NE 'X' THEN message, 'device is *NOT* X'
  
  verbose = keyword_set(verbose)
  IF keyword_set(reset) THEN BEGIN
    !P.font = -1
    device,font='8x13'
    IF verbose THEN message, /info, 'font reset to vector font'
    return
  ENDIF
  
  IF n_elements(fontname) EQ 0 THEN fontname =  ''
  IF fontname EQ '' THEN BEGIN
    print, 'choose a font first...'
    IF NOT keyword_set(defcmd) THEN defcmd = '/usr/bin/X11/xfontsel'
    spawn, /noshell, defcmd
    read,  'Enter font name?  ', fontname
    IF fontname EQ '' THEN BEGIN
      message,  'no font change'
    ENDIF    
  ENDIF
  
  !P.font = 1
  device, font = fontname
  IF verbose THEN message, /info, 'font set to '+fontname
  return
END

