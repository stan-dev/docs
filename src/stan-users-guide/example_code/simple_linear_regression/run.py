""" Example program that generates data, compiles and runs regression.stan"""
from cmdstanpy import CmdStanModel
import numpy

# Run from command line: Python run.py

# simulate data with parameters we are trying to recover with one predictor,
# two predictor case shown in model_7, model_8, model_9 below

alpha_true = numpy.random.normal(size=1, loc=0, scale=1)[0]
beta_true = numpy.random.normal(size=1, loc=0, scale=1)[0]
simga_true = abs(numpy.random.normal(size=1, loc=0, scale=1)[0])
n = 1000
x = numpy.random.uniform(size=n)
y = numpy.random.normal(size=n, loc=alpha_true + beta_true * x,
                        scale=simga_true)

output = """generating parameters are:
alpha_true={:.1f}
beta_true={:.1f}
simga_true={:.1f}
n={:d}"""

stan_data = {'N': n, 'x': x, 'y': y}

# =============runs simplest version==========
model = CmdStanModel(stan_file='naive_linear_regression.stan')
model.compile()
fit = model.sample(data=stan_data, output_dir='output')
print("running stan executable: ", model.exe_file)
print(fit.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# =============runs vectorized version, note speed increase==========

model_2 = CmdStanModel(stan_file='vectorized_linear_regression.stan')
model_2.compile()
fit_2 = model_2.sample(data=stan_data, output_dir='output')
print("running stan executable: ", model_2.exe_file)
print(fit_2.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# =============runs matrix version with separate intercept==========
x_matrix = numpy.array([x]).T
stan_data_matrix = {'N': n, 'K': x_matrix.shape[1], 'x': x_matrix, 'y': y}

model_3 = CmdStanModel(stan_file='matrix_linear_regression.stan')
model_3.compile()
fit_3 = model_3.sample(data=stan_data_matrix, output_dir='output')
print("running stan executable: ", model_3.exe_file)
print(fit_3.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# =============runs matrix version with integrated intercept==========
intercept = [1] * n  # intercept is always 1
x_matrix_2 = numpy.array([intercept, x]).T
stan_data_matrix_w_intercept = {'N': n, 'K': x_matrix_2.shape[1],
                                'x': x_matrix_2, 'y': y}
model_4 = CmdStanModel(stan_file='matrix_w_intercept_linear_regression.stan')
model_4.compile()
fit_4 = model_4.sample(data=stan_data_matrix_w_intercept, output_dir="output")
print("running stan executable: ", model_4.exe_file)
print(fit_4.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# =============runs QR version==========
model_5 = CmdStanModel(stan_file='QR_regression.stan')
model_5.compile()
fit_5 = model_5.sample(data=stan_data_matrix_w_intercept, output_dir="output")
print("running stan executable: ", model_5.exe_file)
print(fit_5.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# =============runs centered and scaled parameter version===========
# =============see chapter Efficiency Tuning,
# =============section Standardizing Predictors and Outputs===
model_6 = CmdStanModel(stan_file='centered_scaled_linear_regression.stan')
model_6.compile()
fit_6 = model_6.sample(data=stan_data, output_dir="output")
print("running stan executable: ", model_6.exe_file)
print(fit_6.summary())
print(output.format(alpha_true, beta_true, simga_true, n))

# ======multi predictor example for models that support it
# add another predictor and generate x_2, y_2
beta_2_true = numpy.random.normal(size=1, loc=0, scale=1)[0]
x_2 = numpy.random.uniform(size=n)
y_2 = numpy.random.normal(size=n,
                          loc=alpha_true + beta_true * x + beta_2_true * x_2,
                          scale=simga_true)

output_2 = """generating parameters are:
alpha_true={:.1f}
beta_true={:.1f}
beta_2_true={:.1f}
simga_true={:.1f}
n={:d}"""

x_matrix_3 = numpy.array([x, x_2]).T
stan_data_matrix_3 = {'N': n, 'K': x_matrix_3.shape[1],
                      'x': x_matrix_3, 'y': y_2}

model_7 = CmdStanModel(stan_file='matrix_linear_regression.stan')  # model_3
model_7.compile()
fit_7 = model_7.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_7.exe_file)
print(fit_7.summary())
print(output_2.format(alpha_true, beta_true, beta_2_true, simga_true, n))

# ===== add intercept to beta
intercept = [1] * n  # create intercept list of n 1's
x_matrix_4 = numpy.array([intercept, x, x_2]).T
stan_data_matrix_4 = {'N': n, 'K': x_matrix_4.shape[1],
                      'x': x_matrix_3, 'y': y_2}
# same as model_4
model_8 = CmdStanModel(stan_file='matrix_w_intercept_linear_regression.stan')
model_8.compile()
fit_8 = model_8.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_8.exe_file)
print(fit_8.summary())
print(output_2.format(alpha_true, beta_true, beta_2_true, simga_true, n))

# =====
model_9 = CmdStanModel(stan_file='QR_regression.stan')  # same as model_5 above
model_9.compile()
fit_9 = model_9.sample(data=stan_data_matrix_3, output_dir="output")
print("running stan executable: ", model_9.exe_file)
print(fit_9.summary())
print(output_2.format(alpha_true, beta_true, beta_2_true, simga_true, n))
