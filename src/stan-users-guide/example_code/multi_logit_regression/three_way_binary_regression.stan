data {
  int N; //num data points
  int y[N];
  real x[N];
}

parameters {
  real alpha[2];
  real beta[2];
}

model {
  alpha ~ normal(-40, 10);
  beta ~ normal(0, 10); 
  for (n in 1:N) {
    if (y[n] == 0) {
      0 ~ bernoulli_logit(alpha[1] + beta[1] * x[n]);
      0 ~ bernoulli_logit(alpha[2] + beta[2] * x[n]);
    }
    if (y[n] == 1) {
      1 ~ bernoulli_logit(alpha[1] + beta[1] * x[n]);
    }
    if (y[n] == 2) {
      1 ~ bernoulli_logit(alpha[2] + beta[2] * x[n]);
    }
  }
}
