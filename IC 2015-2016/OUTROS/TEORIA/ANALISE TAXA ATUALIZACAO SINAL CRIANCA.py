# -*- coding: utf-8 -*-
"""Escolha da taxa de atualização do sinal de presença da criança"""
# K --> Quantidade de pontos a serem amostrados considerando velocidade maxima 

import numpy as np

V_max = np.array([2., 20, 37.58, 100])*(1000./(60.*60.))
K = np.arange(2.,11.)
d_max = 10.0

f_s = np.array([])

d_c = np.array([6,7,8])

K = np.array(3.*d_max/(d_max - (d_c-1)) + 1.0, dtype=int)
K = np.array([7,9,11])
for pos in K:
    f_s = np.array(V_max*(pos/(d_max)))
    print f_s, pos

print V_max/(d_max)