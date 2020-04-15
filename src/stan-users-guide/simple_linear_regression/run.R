library("cmdstanr")

#set_cmdstan_path(paste(Sys.getenv("HOME"),"/.cmdstanr/cmdstan",sep=''))

# Run from command line: Rscript regression_1.R
# If running from RStudio remember to set the working directory 
# >Session>Set Working Directory>To Source File Location

#generate data
alpha <- 2
beta <- 3
sigma <- 1
N <- 100
x <- runif(N, 0, 10)
y <- rnorm(N, alpha + beta * x, sigma)

stan_data <- list(N = N, x = x, y = y)

print(sprintf("generating parameters are: alpha=%.1f, beta=%.1f, sigma=%.1f, N=%d",
              alpha,beta,sigma,N))

model <- cmdstan_model('regression_naive.stan')
fit <- model$sample(data = stan_data, num_chains = 4, output_dir = "output")
print(paste("running stan executable: ",model$exe_file()))
print(fit$summary())

#=============runs efficient version of regression_naive.stan========

model2 <- cmdstan_model('regression_efficient.stan')
fit2 <- model2$sample(data = stan_data, num_chains = 4, output_dir = "output")
print(paste("running stan executable: ",model2$exe_file()))
print(fit2$summary())
