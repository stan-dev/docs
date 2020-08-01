""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
from numpy.random import uniform, normal
from numpy import exp
from scipy.stats import binom

# Run from command line: python run.py
N = 1000
ALPHA_TRUE = normal(size=1, loc=0, scale=1)[0]
BETA_TRUE = normal(size=1, loc=0, scale=1)[0]
X = uniform(size=N, low=0, high=10)
V = ALPHA_TRUE + BETA_TRUE * X
P = 1 / (1 + exp(-V))
Y = binom.rvs(1, P, size=N)


stan_data = {'N': N, 'x': X, 'y': Y}

stan_program = CmdStanModel(stan_file='logistic_regression.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())

output = """generating parameters are:
ALPHA_TRUE={:.1f}
BETA_TRUE={:.1f}
N={:d}"""
print(output.format(ALPHA_TRUE, BETA_TRUE, N))
