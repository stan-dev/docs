data {
  int K;
  int N;
  int D_i_i;
  int y[N];
  matrix[N, D_i_i] x_i_i;
}

transformed data {
  vector[D_i_i] zeros = rep_vector(0, D_i_i);
}

parameters {
  matrix[D_i_i, K - 1] beta_raw;
  //row_vector[K - 1] alpha_raw;
}

transformed parameters {
  matrix[D_i_i, K] beta = append_col(zeros,beta_raw);
  //row_vector[K] alpha = append_col(0.0,alpha_raw);
}

model {
  matrix[N, K] x_beta = x_i_i * beta;
 
  for (n in 1:N) {
    y[n] ~ categorical_logit(x_beta[n]');
  }
}

