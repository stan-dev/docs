library("cmdstanr")

# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

# Simulate data with parameters we are trying to recover with one predictor,
# two predictor case shown in model_7, model_8, model_9 below

# Drawing truth params from same priors in model
alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_true <- rnorm(1, mean = 0, sd = 1)
sigma_true <- abs(rnorm(1, mean = 0, sd = 1))
n <- 1000
x <- runif(n, 0, 10)
y <- rnorm(n, alpha_true + beta_true * x, sigma_true)
stan_data <- list(N = n, x = x, y = y)

cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
              "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
              alpha_true, beta_true, sigma_true, n))

# =============runs simplest version==========
model <- cmdstan_model("naive_linear_regression.stan")
fit <- model$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# =============runs vectorized version, note speed increase==========
model_2 <- cmdstan_model("vectorized_linear_regression.stan")
fit_2 <- model_2$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model_2$exe_file()))
print(fit_2$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# =============runs matrix version with separate intercept==========
x_matrix <- matrix(ncol = 1, nrow = n)
x_matrix[, 1] <- x
stan_data_matrix <- list(N = n, K = dim(x_matrix)[2], x = x_matrix, y = y)
model_3 <- cmdstan_model("matrix_linear_regression.stan")
fit_3 <- model_3$sample(data = stan_data_matrix, output_dir = "output")
print(paste("ran stan executable: ", model_3$exe_file()))
print(fit_3$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# =============runs matrix version with integrated intercept==========
x_matrix_2 <- matrix(ncol = 2, nrow = n)
intercept <- rep(1, n) # intercept is always 1
x_matrix_2[, 1] <- intercept
x_matrix_2[, 2] <- x # predictor values
model_4 <- cmdstan_model("matrix_w_intercept_linear_regression.stan")
stan_data_matrix_w_intercept <- list(N = n, K = dim(x_matrix_2)[2],
                                     x = x_matrix_2, y = y)
fit_4 <- model_4$sample(data = stan_data_matrix_w_intercept,
                        output_dir = "output")
print(paste("ran stan executable: ", model_4$exe_file()))
print(fit_4$summary())
cat("beta[1] in summary output estimates alpha_true
beta[2] estimates beta_true
")
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# =============runs QR version==========
model_5 <- cmdstan_model("QR_regression.stan")
fit_5 <- model_5$sample(data = stan_data_matrix,
                        output_dir = "output")
print(paste("ran stan executable: ", model_5$exe_file()))
print(fit_5$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# =============runs centered and scaled parameter version,
# see chapter Efficiency Tuning, section Standardizing Predictors and Outputs

model_6 <- cmdstan_model("centered_scaled_linear_regression.stan")
fit_6 <- model_6$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model_6$exe_file()))
print(fit_6$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d"),
            alpha_true, beta_true, sigma_true, n))

# ======multi predictor example for models that support it
# add another predictor and generate x_2, y_2
beta_2_true <- rnorm(1, mean = 0, sd = 1)
x_2 <- runif(n, 0, 10)
x_matrix_3 <- matrix(ncol = 2, nrow = n)
x_matrix_3[, 1] <- x
x_matrix_3[, 2] <- x_2
y_2 <- rnorm(n, alpha_true + beta_true * x + beta_2_true * x_2, sigma_true)
stan_data_3 <- list(N = n, K = dim(x_matrix_3)[2], x = x_matrix_2, y = y)

cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nbeta_2_true=%.1f \nsigma_true=%.1f",
                  "\nn=%d"),
              alpha_true, beta_true, beta_2_true, sigma_true, n))

# =====
model_7 <- cmdstan_model("matrix_linear_regression.stan") # same as model_3
fit_7 <- model_7$sample(data = stan_data_3, output_dir = "output")
print(paste("ran stan executable: ", model_7$exe_file()))
print(fit_7$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nbeta_2_true=%.1f \nsigma_true=%.1f",
                  "\nn=%d"),
            alpha_true, beta_true, beta_2_true, sigma_true, n))
# =====
x_matrix_4 <- matrix(ncol = 3, nrow = n)
intercept <- rep(1, n) # intercept is always 1
x_matrix_4[, 1] <- intercept
x_matrix_4[, 2] <- x # predictor values
x_matrix_4[, 3] <- x_2

stan_data_4 <- list(N = n, K = dim(x_matrix_4)[2], x = x_matrix_4, y = y)

model_8 <- cmdstan_model("matrix_w_intercept_linear_regression.stan") # model_4
fit_8 <- model_8$sample(data = stan_data_4, output_dir = "output")
print(paste("ran stan executable: ", model_8$exe_file()))
print(fit_8$summary())
cat("beta[1] in summary output estimates alpha_true
beta[2] estimates beta_true
beta[3] estimates beta_2_true\n")
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nbeta_2_true=%.1f \nsigma_true=%.1f",
                  "\nn=%d"),
            alpha_true, beta_true, beta_2_true, sigma_true, n))

# =====
model_9 <- cmdstan_model("QR_regression.stan") # same as model_5 above
fit_9 <- model_9$sample(data = stan_data_3, output_dir = "output")
print(paste("ran stan executable: ", model_9$exe_file()))
print(fit_9$summary())
cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
                 "\nbeta_true=%.1f \nbeta_2_true=%.1f \nsigma_true=%.1f",
                 "\nn=%d"),
           alpha_true, beta_true, beta_2_true, sigma_true, n))
