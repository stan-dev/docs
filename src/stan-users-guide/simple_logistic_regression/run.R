library("cmdstanr")

set.seed(123)
n <- 1000
x <- rnorm(n)
alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_true <- rnorm(1, mean = 0, sd = 1)
p <- plogis(alpha_true + beta_true * x)
y <- rbinom(n, 1, p)

print(sprintf(paste("simulation parameters are: alpha_true=%.1f",
              "beta_true=%.1f, n=%d"),
              alpha_true, beta_true, n))

stan_data <- list(N = n, x = x, y = y)

#=============runs logistic regression==========

model <- cmdstan_model("logistic_regression.stan")
fit <- model$sample(data = stan_data,
                    output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())
