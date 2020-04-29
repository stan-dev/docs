library("cmdstanr")

#set_cmdstan_path(paste(Sys.getenv("HOME"),"/.cmdstanr/cmdstan",sep=''))

# Run from command line: Rscript regression_1.R
# If running from RStudio remember to set the working directory 
# >Session>Set Working Directory>To Source File Location

#simulate data
alpha_s <- 2
beta_s <- 3
sigma_s <- 1
N <- 1000
x <- runif(N, 0, 10)
y <- rnorm(N, alpha_s + beta_s * x, sigma_s)

stan_data <- list(N = N, x = x, y = y)

print(sprintf("simulation parameters are: alpha_s=%.1f, beta_s=%.1f, sigma_s=%.1f, N=%d",
              alpha_s,beta_s,sigma_s,N))

#=============runs simplest version==========
model <- cmdstan_model('regression_naive.stan')
print(paste("running stan executable: ",model$exe_file()))
system.time(fit <- model$sample(data = stan_data, num_chains = 4, output_dir = "output"))
print(fit$summary())

# Note execution time:
# All 4 chains finished succesfully.
# Mean chain execution time: 2.0 seconds.
# Total execution time: 8.2 seconds.
# user  system elapsed 
# 8.019   0.435   8.613 

#=============runs vectorized version, note speed increase==========

model2 <- cmdstan_model('regression_vectorized.stan')
fit <- model2$sample(data = stan_data, num_chains = 4, output_dir = "output")

# note significant speedup
# All 4 chains finished succesfully.
# Mean chain execution time: 1.3 seconds.
# Total execution time: 5.1 seconds.

#=============runs matrix version with seperate intercept==========
K <- 1 # 1 column for coefficient on x
x_matrix <- matrix(ncol = 1, nrow = N)
x_matrix[,K] = x
model2 <- cmdstan_model('regression_matrix.stan')
stan_data_2 = list(N = N, K = K, x = x_matrix, y = y)

fit2 <- model2$sample(data = stan_data_2, num_chains = 4, output_dir = "output")
print(paste("running stan executable: ", model2$exe_file()))
print(fit2$summary())

#=============runs matrix version with integrated intercept==========
K2 <- 2 
x_matrix <- matrix(ncol = K2, nrow = N)
x_matrix[,1] = rep(1,N) # intercept is always 1
x_matrix[,2] = x # predictor values
model3 <- cmdstan_model('regression_matrix_intercept_incl.stan')
stan_data_3 = list(N = N, K = K2, x = x_matrix, y = y)
fit3 <- model2$sample(data = stan_data_3, num_chains = 4, output_dir = "output")
print(paste("running stan executable: ", model3$exe_file()))
print(fit3$summary())


model4 <- cmdstan_model('regression_QR.stan')
stan_data_4 = stan_data_3
fit4 <- model2$sample(data = stan_data_4, num_chains = 4, output_dir = "output")
print(paste("running stan executable: ", model3$exe_file()))
print(fit4$summary())
