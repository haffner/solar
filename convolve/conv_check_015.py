#!/usr/bin/env python

from numpy import *
from matplotlib.pyplot import *
from scipy import signal
import scipy

data=loadtxt("/Users/dhaffner/tables/cseftor/SolarRefSpec_OPFv9_v04_TEST_ref2.dat")
x=data[:,0]
f0=data[:,1]

f01=f0[0::1]
f05=f0[0::5]
x01=x[0::1]
x05=x[0::5]
                        # fwhm, dlam
t4201=signal.triang(83) # 0.42, 0.01
t4205=signal.triang(17) # 0.42, 0.05
t1501=signal.triang(29) # 0.15, 0.01
t0501=signal.triang(9)  # 0.05, 0.01

c4201=scipy.convolve(f01,t4201,mode='same')/sum(t4201)
c1501=scipy.convolve(f01,t1501,mode='same')/sum(t1501)

c1505=c1501[0::5]
d4205=scipy.convolve(c1505,t4205,mode='same')/sum(t4205)
plot(x01,c4201,label='0.42nm, 0.01nm')
plot(x05,d4205,label='0.15nm, 0.01nm x 0.42nm, 0.05nm')
ylim([-100,1500])
xlim([316.35,318.35])
legend()
show()
