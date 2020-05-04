""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
from numpy.random import uniform, normal
from numpy import exp
from scipy.stats import binom

# Run from command line: Python regression_1.py
n = 1000
alpha_truth = normal(size=1, loc=0, scale=1)[0]
beta_truth = normal(size=1, loc=0, scale=1)[0]
x = uniform(size=n, low=0, high=10)
v = alpha_truth + beta_truth * x
p = 1 / (1 + exp(-v))
y = binom.rvs(1, p, size=n)
output = "generating parameters are: alpha_truth={:.1f}, beta_truth={:.1f}, n={:d}"

print(output.format(alpha_truth, beta_truth, n))

stan_data = {'N': n, 'x': x, 'y': y}

stan_program = CmdStanModel(stan_file='logistic_regression.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())
