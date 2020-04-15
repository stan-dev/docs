""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
import numpy


# Run from command line: Python regression_1.py

alpha = 2
beta = 3
sigma = 5
n = 100
x = numpy.random.uniform(size=n)
y = numpy.random.normal(size=n, loc=alpha + beta * x, scale=sigma)

stan_data = {'N': n, 'x': x, 'y': y}

stan_program = CmdStanModel(stan_file='regression_1.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='.')
print(fit.summary())
