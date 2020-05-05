data {
  int<lower = 0> N;
  vector[N] x;
  int<lower = 0, upper = 1> y[N];
}

parameters {
  real alpha;
  real beta;
}

model {
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  y ~ bernoulli(Phi(alpha + beta * x));
  // y ~ bernoulli(Phi_approx(alpha + beta * x)); // more efficient Phi
}
