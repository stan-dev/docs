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
  alpha ~ normal(0, 1); // priors
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  for (n in 1:N) {
    y[n] ~ normal(alpha + beta * x[n], sigma); // likelihood
  }
}
