data {
  int<lower = 0> N; // number of data elements
  vector[N] x;      // predictor vector
  vector[N] y;      // outcomes vector
}

parameters {
  real alpha; // intercept
  real beta; // slope, predictor coefficient
  real<lower = 0> sigma; // error scale
}

model {
  alpha ~ normal(5, 10); // priors
  beta ~ normal(5, 10);
  sigma ~ normal(5, 10);
  y ~ normal(alpha + beta * x, sigma); // likelihood
}
