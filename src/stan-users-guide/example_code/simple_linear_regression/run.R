library("cmdstanr")

# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

#simulate data with parameters we are trying to recover with one predictor, 
#two predictor case shown in model_7, model_8, model_9 below 
#drawing truth params from same priors in model


alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_true <- rnorm(1, mean = 0, sd = 1)
sigma_true <- rnorm(1, mean = 0, sd = 1)
n <- 1000
x <- runif(n, 0, 10)
y <- rnorm(n, alpha_true + beta_true * x, sigma_true)
stan_data <- list(N = n, x = x, y = y)

cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
              "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
              alpha_true, beta_true, sigma_true, n))

#=============runs simplest version==========

model <- cmdstan_model("naive_linear_regression.stan")
fit <- model$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())


#=============runs vectorized version, note speed increase==========

model_2 <- cmdstan_model("vectorized_linear_regression.stan")
fit_2 <- model_2$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model_2$exe_file()))
print(fit_2$summary())

#=============runs matrix version with separate intercept==========

k <- 1 # 1 column for coefficient on x
x_matrix <- matrix(ncol = 1, nrow = n)
x_matrix[, k] <- x
stan_data_matrix <- list(N = n, K = k, x = x_matrix, y = y)
model_3 <- cmdstan_model("matrix_linear_regression.stan")
fit_3 <- model_3$sample(data = stan_data_matrix, output_dir = "output")
print(paste("ran stan executable: ", model_3$exe_file()))
print(fit_3$summary())

#=============runs matrix version with integrated intercept==========

k_2 <- 2
x_matrix <- matrix(ncol = k_2, nrow = n)
x_matrix[, 1] <- rep(1, n) # intercept is always 1
x_matrix[, 2] <- x # predictor values
model_4 <- cmdstan_model("matrix_w_intercept_linear_regression.stan")
stan_data_matrix_w_intercept <- list(N = n, K = k_2, x = x_matrix, y = y)
fit_4 <- model_4$sample(data = stan_data_matrix_w_intercept,
                      num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model_4$exe_file()))
print(fit_4$summary())

#beta[1] in summary output estimates alpha_true
#beta[2] estimates beta_true
#sigma estimates sigma_true

#=============runs QR version==========

model_5 <- cmdstan_model("QR_regression.stan")
fit_5 <- model_5$sample(data = stan_data_matrix_w_intercept,
                      num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model_5$exe_file()))
print(fit_5$summary())

#=============runs centered and scaled parameter version,  
#=============see chapter Efficiency Tuning, section Standardizing Predictors and Outputs==========

model_6 <- cmdstan_model("centered_scaled_linear_regression.stan")
fit_6 <- model_6$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model_6$exe_file()))
print(fit_6$summary())

#======multi predictor example for all models

alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_1_true <- rnorm(1, mean = 0, sd = 1)
beta_2_true <- rnorm(1, mean = 0, sd = 1)
sigma_true <- rnorm(1, mean = 0, sd = 1)

n <- 1000
x_1 <- runif(n, 0, 10)
x_2 <- runif(n, 0, 10)
x_matrix_2 <- matrix(ncol = 2, nrow = n)
x_matrix_2[, 1] <- x_1 
x_matrix_2[, 2] <- x_2 
y <- rnorm(n, alpha_true + beta_1_true * x_1 + beta_2_true * x_2, sigma_true)
stan_data_2_pred <- list(N=n, K=2, x=x_matrix_2, y=y)

cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                    "\nbeta_1_true=%.1f \nbeta_2_true=%.1f \nsigma_true=%.1f \nn=%d"),
              alpha_true, beta_1_true, beta_2_true, sigma_true, n))

#=====
model_7 <- cmdstan_model("matrix_linear_regression.stan") # same as model_3 above
fit_7 <- model_7$sample(data = stan_data_2_pred, output_dir = "output")
print(paste("ran stan executable: ", model_7$exe_file()))
print(fit_7$summary())
#=====
model_8 <- cmdstan_model("matrix_w_intercept_linear_regression.stan") # same as model_4 above
fit_8 <- model_7$sample(data = stan_data_2_pred, output_dir = "output")
print(paste("ran stan executable: ", model_8$exe_file()))
print(fit_8$summary())
#=====
model_9 <- cmdstan_model("QR_regression.stan") # same as model_5 above
fit_9 <- model_9$sample(data = stan_data_2_pred, output_dir = "output")
print(paste("ran stan executable: ", model_9$exe_file()))
print(fit_9$summary())
#=====

