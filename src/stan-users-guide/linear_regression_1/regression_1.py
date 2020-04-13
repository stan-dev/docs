""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
import numpy


# Run from command line: Python regression_1.py

ALPHA = 2
BETA = 3
SIGMA = 5
N = 100
X = numpy.random.uniform(size=N)
Y = numpy.random.normal(size=N, loc=ALPHA + BETA * X, scale=SIGMA)

STAN_DATA = {'N': N, 'x': X, 'y': Y}

STAN_PROGRAM = CmdStanModel(stan_file='regression_1.stan')
STAN_PROGRAM.compile()
FIT = STAN_PROGRAM.sample(data=STAN_DATA, output_dir='.')
print(FIT.summary())
