""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
from numpy.random import uniform
from scipy.stats import t

# Run from command line: Python regression_1.py

alpha_g = 2.0
beta_g = 3.0
sigma_g = 1.0
n = 10
eta_g = n - 2 # degrees of freedom
x = uniform(size=n)
y = t.rvs(eta_g, loc=alpha_g + beta_g * x, scale=sigma_g, size=n)
output = ("generating parameters are: eta_g={:.1f}, alpha_g={:.1f}," +
          "beta_g={:.1f},sigma_g={:.1f}, n={:d}")

print(output.format(eta_g, alpha_g, beta_g, sigma_g, n))

stan_data = {'N': n, 'x': x, 'y': y}

stan_program = CmdStanModel(stan_file='regression_student_t.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())



