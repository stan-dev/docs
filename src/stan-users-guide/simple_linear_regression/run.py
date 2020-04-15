""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
import numpy


# Run from command line: Python regression_1.py

alpha = 2.0
beta = 3.0
sigma = 5.0
n = 100
x = numpy.random.uniform(size=n)
y = numpy.random.normal(size=n, loc=alpha + beta * x, scale=sigma)

output = "generating parameters are: alpha={:.1f}, beta={:.1f}, sigma={:.1f}, n={:d}" 

print(output.format(alpha,beta,sigma,n))

stan_data = {'N': n, 'x': x, 'y': y}

stan_program = CmdStanModel(stan_file='regression_naive.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ",stan_program.exe_file)
print(fit.summary())

#=============runs efficient version========

stan_program2 = CmdStanModel(stan_file='regression_efficient.stan')
stan_program2.compile()
fit2 = stan_program2.sample(data=stan_data, output_dir='output')
print("running stan executable: ",stan_program2.exe_file)
print(fit2.summary())


