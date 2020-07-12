data {
  int K;
  int N;
  int D;
  int y[N];
  matrix[N, D] x;
}


transformed data {
  vector[D] zeros = rep_vector(0, D);
}

parameters {
  matrix[D, K - 1] beta_raw;
  row_vector[K - 1] alpha_raw;
}

transformed parameters {
  matrix[D, K] beta = append_col(zeros,beta_raw);
  row_vector[K] alpha = append_col(0.0,alpha_raw);
}

model {
  matrix[N, K] x_beta = x * beta;
  //to_vector(beta) ~ normal(0, 5);
  //to_vector(alpha) ~ normal(0, 5);
  for (n in 1:N) {
    vector[K] values;
    for (k in 1:K) {
      values[k] = x_beta[n][k] + alpha[k];
    }
    y[n] ~ categorical_logit(values);
  }
}

