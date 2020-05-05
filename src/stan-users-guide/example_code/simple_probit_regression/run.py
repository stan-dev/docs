""" Example program that generates data, compiles and runs probit_regression.stan"""
from cmdstanpy import CmdStanModel
from scipy.stats import binom, norm, uniform

# Run from command line: Python run.py
n = 1000
alpha_truth = norm.rvs(size=1, loc=0, scale=1)[0]
beta_truth = norm.rvs(size=1, loc=0, scale=1)[0]
x = uniform.rvs(size=n, loc=0, scale=10)
v = alpha_truth + beta_truth * x
p = norm.cdf(v)
y = binom.rvs(1, p, size=n)
output = "generating parameters are: alpha_truth={:.1f}, beta_truth={:.1f}, n={:d}"

print(output.format(alpha_truth, beta_truth, n))

stan_data = {'N': n, 'x': x, 'y': y}

stan_program = CmdStanModel(stan_file='probit_regression.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())
