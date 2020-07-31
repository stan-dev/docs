""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
import numpy

# Run from command line: Python run.py

#simulate data with parameters we are trying to recover with one predictor,
#two predictor case shown in model_7, model_8, model_9 below

ALPHA_TRUE = numpy.random.normal(size=1, loc=0, scale=1)[0]
BETA_TRUE = numpy.random.normal(size=1, loc=0, scale=1)[0]
SIGMA_TRUE = abs(numpy.random.normal(size=1, loc=0, scale=1)[0])
N = 1000
X = numpy.random.uniform(size=N)
Y = numpy.random.normal(size=N, loc=ALPHA_TRUE + BETA_TRUE * X, scale=SIGMA_TRUE)

output = """generating parameters are:
ALPHA_TRUE={:.1f}
BETA_TRUE={:.1f}
SIGMA_TRUE={:.1f}
N={:d}"""

stan_data = {'N': N, 'x': X, 'y': Y}

#=============runs simplest version==========
model = CmdStanModel(stan_file='naive_linear_regression.stan')
model.compile()
fit = model.sample(data=stan_data, output_dir='output')
print("running stan executable: ", model.exe_file)
print(fit.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#=============runs vectorized version, note speed increase==========

model_2 = CmdStanModel(stan_file='vectorized_linear_regression.stan')
model_2.compile()
fit_2 = model_2.sample(data=stan_data, output_dir='output')
print("running stan executable: ", model_2.exe_file)
print(fit_2.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#=============runs matrix version with separate intercept==========
x_matrix = numpy.array([X]).T
stan_data_matrix = {'N': N, 'K': x_matrix.shape[1], 'x': x_matrix, 'y': Y}

model_3 = CmdStanModel(stan_file='matrix_linear_regression.stan')
model_3.compile()
fit_3 = model_3.sample(data=stan_data_matrix, output_dir='output')
print("running stan executable: ", model_3.exe_file)
print(fit_3.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#=============runs matrix version with integrated intercept==========
intercept = [1] * N # intercept is always 1
x_matrix_2 = numpy.array([intercept, X]).T
stan_data_matrix_w_intercept = {'N': N, 'K': x_matrix_2.shape[1], 'x': x_matrix_2, 'y': Y}
model_4 = CmdStanModel(stan_file='matrix_w_intercept_linear_regression.stan')
model_4.compile()
fit_4 = model_4.sample(data=stan_data_matrix_w_intercept, output_dir="output")
print("running stan executable: ", model_4.exe_file)
print(fit_4.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#=============runs QR version==========
model_5 = CmdStanModel(stan_file='QR_regression.stan')
model_5.compile()
fit_5 = model_5.sample(data=stan_data_matrix_w_intercept, output_dir="output")
print("running stan executable: ", model_5.exe_file)
print(fit_5.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#=============runs centered and scaled parameter version===========
#=============see chapter Efficiency Tuning, section Standardizing Predictors and Outputs===
model_6 = CmdStanModel(stan_file='centered_scaled_linear_regression.stan')
model_6.compile()
fit_6 = model_6.sample(data=stan_data, output_dir="output")
print("running stan executable: ", model_6.exe_file)
print(fit_6.summary())
print(output.format(ALPHA_TRUE, BETA_TRUE, SIGMA_TRUE, N))

#======multi predictor example for models that support it
#add another predictor and generate X_2, Y_2
BETA_2_TRUE = numpy.random.normal(size=1, loc=0, scale=1)[0]
X_2 = numpy.random.uniform(size=N)
Y_2 = numpy.random.normal(size=N, loc=ALPHA_TRUE + BETA_TRUE * X + BETA_2_TRUE * X_2,
                          scale=SIGMA_TRUE)

output_2 = """generating parameters are:
ALPHA_TRUE={:.1f}
BETA={:.1f}
BETA_2_TRUE={:.1f}
SIGMA_TRUE={:.1f}
n={:d}"""

x_matrix_3 = numpy.array([X, X_2]).T
stan_data_matrix_3 = {'N': N, 'K': x_matrix_3.shape[1], 'x': x_matrix_3, 'y': Y_2}

model_7 = CmdStanModel(stan_file='matrix_linear_regression.stan') #same as model_3 above
model_7.compile()
fit_7 = model_7.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_7.exe_file)
print(fit_7.summary())
print(output_2.format(ALPHA_TRUE, BETA_TRUE, BETA_2_TRUE, SIGMA_TRUE, N))

#===== add intercept to beta
intercept = [1] * N #create intercept list of n 1's
x_matrix_4 = numpy.array([intercept, X, X_2]).T
stan_data_matrix_4 = {'N': N, 'K': x_matrix_4.shape[1], 'x': x_matrix_3, 'y': Y_2}

model_8 = CmdStanModel(stan_file='matrix_w_intercept_linear_regression.stan') #same as model_4 above
model_8.compile()
fit_8 = model_8.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_8.exe_file)
print(fit_8.summary())
print(output_2.format(ALPHA_TRUE, BETA_TRUE, BETA_2_TRUE, SIGMA_TRUE, N))

#=====
model_9 = CmdStanModel(stan_file='QR_regression.stan') # same as model_5 above
model_9.compile()
fit_9 = model_9.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_9.exe_file)
print(fit_9.summary())
print(output_2.format(ALPHA_TRUE, BETA_TRUE, BETA_2_TRUE, SIGMA_TRUE, N))
