library("cmdstanr")

# set_cmdstan_path(paste(Sys.getenv("HOME"),"/.cmdstanr/cmdstan",sep=''))
# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

#simulate data
alpha_s <- 2
beta_s <- 3
sigma_s <- 1
n <- 1000
x <- runif(n, 0, 10)
y <- rnorm(n, alpha_s + beta_s * x, sigma_s)
stan_data <- list(N = n, x = x, y = y)

print(sprintf(paste("simulation parameters are: alpha_s=%.1f",
              "beta_s=%.1f, sigma_s=%.1f, n=%d"),
              alpha_s, beta_s, sigma_s, n))

#=============runs simplest version==========

model <- cmdstan_model("regression_naive.stan")
fit <- model$sample(data = stan_data, num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())

#=============runs vectorized version, note speed increase==========

model_2 <- cmdstan_model("regression_vectorized.stan")
fit_2 <- model_2$sample(data = stan_data, num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model_2$exe_file()))
print(fit_2$summary())

#=============runs matrix version with separate intercept==========

k <- 1 # 1 column for coefficient on x
x_matrix <- matrix(ncol = 1, nrow = n)
x_matrix[, k] <- x
stan_data_matrix <- list(N = n, K = k, x = x_matrix, y = y)
model_3 <- cmdstan_model("regression_matrix.stan")
fit_3 <- model_3$sample(data = stan_data_matrix, num_chains = 4,
                      output_dir = "output")
print(paste("ran stan executable: ", model_3$exe_file()))
print(fit_3$summary())

#=============runs matrix version with integrated intercept==========

k_2 <- 2
x_matrix <- matrix(ncol = k_2, nrow = n)
x_matrix[, 1] <- rep(1, n) # intercept is always 1
x_matrix[, 2] <- x # predictor values
model_4 <- cmdstan_model("regression_matrix_w_intercept.stan")
stan_data_matrix_w_intercept <- list(N = n, K = k_2, x = x_matrix, y = y)
fit_4 <- model_4$sample(data = stan_data_matrix_w_intercept,
                      num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model_4$exe_file()))
print(fit_4$summary())

#=============runs QR version==========

model_5 <- cmdstan_model("regression_QR.stan")
fit_5 <- model_5$sample(data = stan_data_matrix_w_intercept,
                      num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model_5$exe_file()))
print(fit_5$summary())

#=============runs centered and scaled parameter version,  
#=============see chapter Efficiency Tuning, section Standardizing Predictors and Outputs==========

model_6 <- cmdstan_model("regression_centered_scaled.stan")
fit_6 <- model_6$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model_6$exe_file()))
print(fit_6$summary())
