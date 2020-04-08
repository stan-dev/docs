data {
  int<lower = 0> N;
  vector[N] x;
  vector[N] y;
  int<lower = 0, upper = 1> resample;
}
transformed data {
  simplex[N] uniform = rep_vector(1.0 / N, N);
  int<lower = 1, upper = N> boot_idxs[N];
  for (n in 1:N)
    boot_idxs[n] = resample ? categorical_rng(uniform) : n;
}
parameters {
  real alpha;
  real beta;
  real<lower = 0> sigma;
}
model {
  y[boot_idxs] ~ normal(alpha + beta * x[boot_idxs], sigma);
}
