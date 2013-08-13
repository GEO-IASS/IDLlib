pro ave2spec, wave, spec1, spec2, rvshift, out, RATIO = ratio

;**************************************
;**  Program average 2 spectra together
;**************************************

n_o = n_elements(wave[0,*])
n_p = n_elements(wave[*,0])

out = fltarr(n_p, n_o)

IF NOT KEYWORD_SET(ratio) THEN ratio = 1

for i = 0, n_o-1 do begin

    give_a_shift = rvshift * wave(n_p/2, i) / 2.9979e5
    shfts_interp, wave[*,i], spec2[*,i], give_a_shift, shft

    mn_s1 = mean(spec1[*,i])
    mn_s2 = mean(shft) 
    mn_ave = (mn_s1 + mn_s2)/2.0

    out[*,i] = (spec1[*,i]/mn_s1 * ratio/(1+ratio) + $
                shft/mn_s2 * 1/(1+ratio) ) * mn_ave

;    plot, out[250:350,i]/mean(out[250:350,i]) + 2
;    oplot, spec1[250:350,i]/mean(spec1[250:350,i]) +1
;    oplot, shft[250:350]/mean(shft[250:350])
    ; stop

endfor

end

