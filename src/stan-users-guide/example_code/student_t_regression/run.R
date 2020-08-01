library("cmdstanr")

# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

#simulate data with Student's t distribution

#drawing truth params from same priors in model
alpha_true <- rnorm(1, mean = 0, sd = 1)
beta_true <- rnorm(1, mean = 0, sd = 1)
sigma_true <- 1
n <- 10
nu <- n - 2 # there are two parameters in the model
x <- runif(n, 0, 10)
y <- rt(n, nu, alpha_true + beta_true * x) # sigma_true implictly = 1

#=============runs robust noise regression, Student's t==========

stan_data <- list(N = n, x = x, y = y, nu = nu)
model <- cmdstan_model("student_t_regression.stan")
fit <- model$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())

cat(sprintf(paste("simulation parameters are: \nnu=%.1f \nalpha_true=%.1f",
                  "\nbeta_true=%.1f \nsigma_true=%.1f \nn=%d\n"),
            nu, alpha_true, beta_true, sigma_true, n))
