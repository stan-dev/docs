model <- stan_model('bootstrap.stan')

# keep data same with same seed
set.seed(1234)
N <- 50
alpha <- 1.2
beta <- -0.5
sigma <- 1.5
x <- rnorm(N)
y <- rnorm(N, alpha + beta * x, sigma)

# allow Stan transformed param seed to vary
set.seed(NULL)
stan_seed <- sample(1:1000, size = M)

fit <-
  optimizing(model,
             data = list(N = N, x = x, y = y, resample = 0))

M <- 100
theta_hat <- matrix(NA, M, 3)
for (m in 1:M) {
  fit_repl <-
    optimizing(model,
               data = list(N = N, x = x, y = y, resample = 1),
               seed = stan_seed[m])
  theta_hat[m, ] <- fit_repl$par
}
se_hat <- as.array(apply(theta_hat, 2, sd))
param_names <- labels(fit$par)
names(se_hat) <- param_names
cat(sprintf("%10s %10s %10s\n", "parameter", "estimate", "std err"))
cat(sprintf("%10s %10s %10s\n", "---------", "--------", "-------"))
for (n in 1:length(se_hat))
  cat(sprintf("%10s %10.3f %10.3f\n",
              param_names[n], fit$par[n], se_hat[n]))
