data {
  int<lower = 0> N;   // number of data items
  int<lower = 0> K;   // number of predictors
  matrix[N, K] x;   // predictor matrix
  vector[N] y;      // outcome vector
}

transformed data {
  print("N = ", N, "K = ", K, "x = ", x, "y = ", y);
}

parameters {
  real alpha;             // intercept
  vector[K] beta;         // coefficients for predictors
  real<lower = 0> sigma;  // error scale
}
model {
  alpha ~ normal(5, 10); // priors
  beta ~ normal(5, 10);
  sigma ~ normal(5, 10);
  y ~ normal(x * beta + alpha, sigma);  // likelihood
}
