data {
  int<lower = 0> N;
  vector [N ] x;
  vector[N] y;
}


parameters {
  real alpha;
  real beta;
  real<lower = 0> sigma;
}

//Just vectorized right now. 
model {
  alpha ~ normal(5, 10);
  beta ~ normal(5, 10);
  sigma ~ normal(5, 10);
  y ~ normal(alpha + beta * x, sigma);
}

