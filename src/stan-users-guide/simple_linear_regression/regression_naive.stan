data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}

parameters {
  real alpha_hat;
  real beta_hat;
  real<lower=0> sigma_hat;
}

model {
  alpha_hat ~ normal(5,10);
  beta_hat ~ normal(5,10);
  sigma_hat ~ normal(5,10);
  for (i in 1:N) {
    y[i] ~ normal(alpha_hat + beta_hat * x[i], sigma_hat);
  }
}
