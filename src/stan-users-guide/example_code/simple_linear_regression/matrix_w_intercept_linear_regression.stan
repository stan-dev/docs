data {
  int<lower = 0> N;   // number of data items
  int<lower = 0> K;   // number of predictors
  matrix[N, K] x;   // predictor matrix
  vector[N] y;      // outcome vector
}

parameters {
  vector[K] beta; // beta[1] = intercept, beta[2] = slope
  real<lower = 0> sigma;  // error scale
}
model {
  beta ~ normal(0, 1); // priors
  sigma ~ normal(0, 1);
  y ~ normal(x * beta, sigma);  // likelihood
}
