""" Example program that generates data, compiles and runs student_t_regression.stan"""
from cmdstanpy import CmdStanModel
import numpy
import scipy.stats

# Run from command line: Python run.py

ALPHA_TRUE = numpy.random.normal(size=1, loc=0, scale=1)[0]
BETA_TRUE = numpy.random.normal(size=1, loc=0, scale=1)[0]
SIGMA_TRUE = abs(numpy.random.normal(size=1, loc=0, scale=1)[0])
N = 10

NU = N - 2 # degrees of freedom

X = numpy.random.uniform(size=N)
Y = scipy.stats.t.rvs(NU, loc=ALPHA_TRUE + BETA_TRUE * X, scale=SIGMA_TRUE, size=N)
stan_data = {'N': N, 'x': X, 'y': Y, 'nu': NU}

stan_program = CmdStanModel(stan_file='student_t_regression.stan')
stan_program.compile()
fit = stan_program.sample(data=stan_data, output_dir='output')
print("running stan executable: ", stan_program.exe_file)
print(fit.summary())

output = ("generating parameters are: \nNU={:.1f} \nALPHA_TRUE={:.1f}" +
          "\nBETA_TRUE={:.1f} \nSIGMA_TRUE={:.1f} \nN={:d}\n")
print(output.format(NU, ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))
