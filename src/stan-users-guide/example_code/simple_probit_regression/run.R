library("cmdstanr")

n <- 1000
x <- rnorm(n)
alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_true <-  rnorm(1, mean = 0, sd = 1)
p <- pnorm(alpha_true + beta_true * x)
y <- rbinom(n, 1, p)

stan_data <- list(N = n, x = x, y = y)

#=============runs logistic regression==========

model <- cmdstan_model("probit_regression.stan")
fit <- model$sample(data = stan_data,
                    output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())

cat(sprintf(paste("simulation parameters are: \nalpha_true=%.1f",
              "\nbeta_true=%.1f \nn=%d"),
              alpha_true, beta_true, n))
