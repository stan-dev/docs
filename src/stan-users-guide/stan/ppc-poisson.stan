data {
  int<lower = 0> N;
  int<lower = 0> y[N];
}
transformed data {
  real<lower = 0> mean_y = mean(to_vector(y));
  real<lower = 0> sd_y = sd(to_vector(y));
}
parameters {
  real<lower = 0> lambda;
}
model {
  y ~ poisson(lambda);
  lambda ~ exponential(0.1);
}
generated quantities {
  int<lower = 0> y_rep[N] = poisson_rng(rep_array(lambda, N));
  real<lower = 0> mean_y_rep = mean(to_vector(y_rep));
  real<lower = 0> sd_y_rep = sd(to_vector(y_rep));
  int<lower = 0, upper = 1> mean_gt = (mean_y_rep > mean_y);
  int<lower = 0, upper = 1> sd_gt = (sd_y_rep > sd_y);
}
