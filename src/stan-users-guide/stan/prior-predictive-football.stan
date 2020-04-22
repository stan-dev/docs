data {
  int<lower = 0> J;
  real<lower = 0> epsilon[2];
}
generated quantities {
  real<lower = 0> lambda[J];
  int y[J, J];
  for (j in 1:J) lambda[j] = gamma_rng(epsilon[1], epsilon[2]);
  for (i in 1:J)
    for (j in 1:J)
      y[i, j] = poisson_rng(lambda[i]) - poisson_rng(lambda[j]);
}
