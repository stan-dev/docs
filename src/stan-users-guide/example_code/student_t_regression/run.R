library("cmdstanr")

# set_cmdstan_path(paste(Sys.getenv("HOME"),"/.cmdstanr/cmdstan",sep=''))
# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

#simulate data with Student's t distribution

alpha_s <- 2
beta_s <- 3
sigma_s <- 1
n <- 10
eta_s <- n - 2
x <- runif(n, 0, 10)
y <- rt(n, eta_s, alpha_s + beta_s * x) # sigma_s implictly = 1

print(sprintf(paste("simulation parameters are: eta_s=%.1f, alpha_s=%.1f",
              "beta_s=%.1f, sigma_s=%.1f, n=%d"),
              eta_s, alpha_s, beta_s, sigma_s, n))

stan_data = list(N = n, x = x, y = y)

#=============runs robust noise regression, Student's t==========

model <- cmdstan_model("regression_student_t.stan")
fit <- model$sample(data = stan_data,
                        num_chains = 4, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())
