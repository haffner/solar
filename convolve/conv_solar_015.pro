;
fname='~/solar/refspectrum/SolarRefSpec_OPFv9_v04_TEST_ref2.dat.unix'
;
; read  header
header=strarr(8)
openr, 3, fname
readf, 3, header
close, 3
;
; load data
a=loadtxt(fname,skiprows=8,dtype='double')
wave=a[0,*]
flux=a[1,*]
phot=a[2,*]
;
; interpolate data to regular 0.01 nm grid
x=findgen(wave.length)*0.01+min(wave)
flux_int=interpol(flux, wave, x)
phot_int=interpol(phot, wave, x)
;
; Convolve data with 0.15 nm FWHM triangular window
kern=triang(29)
flux_conv=convol(flux_int, kern, /center, /normalize)
phot_conv=convol(phot_int, kern, /center, /normalize)
;
; trim ends of arrays
; id=where(flux_conv NE 0.0,count)
; if count gt 0 then begin
;    x=x[id]
;    flux_conv=flux_conv[id]
;    phot_conv=phot_conv[id]
; endif
;
; define comments
comments=[header[0], 'Original file '+file_basename(fname)+' convolved with ', $
          'triangular 0.15 nm FHWM window at 0.1 nm steps.', header[1:-1] ]
;
; write hdf5 file
fn='SolarRefSpec_OPFv9_v04_TEST_ref2_FHWM015.h5'
h5_putdata,fn,'Wavelength',x
h5_putdata,fn,'SolarFlux',flux_conv
h5_putdata,fn,'SolarFlux_photons',phot_conv
h5_putdata,fn,'Comments', strjoin(comments,' ')
;
; write ASCII file
if lmgr(/demo) eq 1 then begin
	for i=0,comments.length-1 do print, comments[i]
	for i=0, x.length-1 do begin
   		print, x[i], flux_conv[i], phot_conv[i], format='(2x, f6.2, 2x, f12.5, 2x, E14.5)'
	endfor
endif else begin
	openw, 4, 'SolarRefSpec_OPFv9_v04_TEST_ref2_FHWM015.dat'
	for i=0,comments.length-1 do printf, 4, comments[i]
	for i=0, x.length-1 do begin
	   printf, 4, x[i], flux_conv[i], phot_conv[i], format='(2x, f6.2, 2x, f12.5, 2x, E14.5)'
	endfor
	close,4

	openw, 5, 'SolarRefSpec_OPFv9_v04_TEST_ref2_FHWM015.dat.nohdr'
	for i=0, x.length-1 do begin
	   printf, 5, x[i], flux_conv[i], phot_conv[i], format='(2x, f6.2, 2x, f12.5, 2x, E14.5)'
	endfor
	close,5
endelse
;
end
