""" Example program that generates data, compiles and
runs student_t_regression.stan"""
from cmdstanpy import CmdStanModel
import numpy
import scipy.stats

# Run from command line: Python run.py

alpha_true = numpy.random.normal(size=1, loc=0, scale=1)[0]
beta_true = numpy.random.normal(size=1, loc=0, scale=1)[0]
simga_true = abs(numpy.random.normal(size=1, loc=0, scale=1)[0])
n = 10

nu = n - 2  # degrees of freedom

x = numpy.random.uniform(size=n)
y = scipy.stats.t.rvs(nu, loc=alpha_true + beta_true * x,
                      scale=simga_true, size=n)
stan_data = {'N': n, 'x': x, 'y': y, 'nu': nu}

stan_program = CmdStanModel(stan_file='student_t_regression.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())

output = ("generating parameters are: \nnu={:.1f} \nalpha_true={:.1f}" +
          "\nbeta_true={:.1f} \nsimga_true={:.1f} \nn={:d}\n")
print(output.format(nu, alpha_true, beta_true, simga_true, n))
