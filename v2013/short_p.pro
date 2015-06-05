pro short_p
set_plot,'X'
;spawn,'ls *.lc > lc.lis'
readcol,'lc.lis',file,f='(A)',/silent
cubehelix,rot=-0.5
!p.font=0


set_plot,'ps'
for n=0L,n_elements(file)-1 do begin
   readcol,file[n],t,f,e,q,f='(X,X,D,X,X,D,D,X,X,I)',/silent

   x = where(f gt 1d3)
   t = t[x]
   f = f[x]
   e = e[x]
   q = q[x]
   
   f = f[sort(t)]
   e = e[sort(t)]
   q = q[sort(t)]
   t = t[sort(t)]

   med_f = median(f)

   for l = 0l,n_elements(uniq(q))-1 do begin
      qq = where(q eq (q[uniq(q)])[l])
      ffit = poly_fit(t[qq],f[qq],2)
      f[qq] = f[qq]-poly(t[qq],ffit)+med_f
   endfor

   ls = LNP_TEST(t,f,wk1=freq,wk2=pwr,jmax=j,/double,ofac=16)
;   remove,where(1./freq gt 100),freq,pwr

   per = 1./freq[j]
   if n eq 19 then per = per*2d0

;   plot,t mod per,(f-med_f)/med_f

   fp = (f-min(f))/med_f

   print,file[n]


;; set_plot,'X'
;; stop



;---- weird gamma dor-ish things:
;  n=7, 4175707
;  n=18, 8416220

   device,filename=file[n]+'.eps',/encap,/color,/inch,xsize=10,ysize=7
   contour_plus,/pix,(t mod per)/per, fp,yrange=[-3,3]*stddev(fp)+median(fp),1,/rev,/xsty,/ysty,xbin=.005,ybin=stddev(fp)/10.,position=posgen(3,5,1,1,xsp=.8,ysp=.8),charsize=.8,title='per = '+string(per)

   plot,1./freq,pwr,/ylog,xrange=[0,2],position=posgen(3,5,2,1,ysp=.8),charsize=.8,/noerase

   plot,t,(f-med_f)/med_f,yrange=[-3,3]*stddev(fp),/xsty,xrange=[min(t),min(t)+10],/noerase,position=posgen(3,5,3,1,xsp=-.8,ysp=.8),charsize=.8,title='first 10 days'


   dt = median(t[1:*] - t)

   pixel_plus,t,(t mod per)/per,fp,xbin=per*5.,ybin=.025,yrange=[0,1],xsty=5,ysty=9,ytitle='Phase',ytickname=' ',lvl=[(findgen(8)+.1)*stddev(fp)],hist=hh,position=posgen(1,5,2,ysp=2),/noerase

    pixel_plus,t,(t mod per)/per,fp,xbin=per*5.,ybin=.025,yrange=[0,1],/noerase,position=posgen(1,5,4,ysp=2),xsty=9,ysty=9,xtitle='Time',lvl=[(findgen(8)+.1)*stddev(fp)]

    device,/close









   ;; time = findgen((max(t)-min(t))/dt)*dt+min(t)
   ;; flux = interpol(fp,t,time)


;;    wc=wv_cwt(flux*1d3,'Morlet',6,scale=scale,/PAD,dscale=0.1)
;;    wpwr = abs(wc^2.)
;;    scale *= dt
;; contour,alog10(wpwr),time,scale,/fill,nlev=25,/xsty,/ylog,/ysty


;;    nacf = 10000
;;    lag = findgen(nacf)
;;    acorl = a_correlate(flux,lag)
;;    acorl = acorl - min(acorl)
;;    dadts = smooth(acorl[1:*]-acorl,5,/edge)
;;    a1 = (where(dadts gt 0))[0]
;;    if a1[0] le 0 then a1 = 3
;;    aht = max(acorl[a1:*],bbb)
;;    apeak = (lag[a1:*]*dt)[bbb]

;;    plot,lag*dt,acorl


endfor


set_plot,'X'
stop
end
