#library("rstan")
library("cmdstanr")
set_cmdstan_path("~/cmdstan-2.22.1/") # set to your local install of cmdstan

#Run from command line: Rscript regression_1.R
#If running from RStudio remember to set the working directory 
# >Session>Set Working Directory>To Source File Location

#generate data
alpha <- 2
beta <- 3
sigma <- 5
N <- 100
x <- runif(N, 0, 10)
y <- rnorm(N, alpha + beta*x, sigma)
stan_data <- list(N=N, x=x, y=y)

#dump(c('N','x','y'),file="stan_data.Rdump")

model = cmdstan_model('regression_1.stan')

fit <- model$sample(data = stan_data,num_chains=4)

print(fit$summary())


