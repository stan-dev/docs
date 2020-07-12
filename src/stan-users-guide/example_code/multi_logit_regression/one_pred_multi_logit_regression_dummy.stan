data {
  int K;
  int N;
  int D;
  int y[N];
  real x[N];
}

parameters {
  vector[K - 1] beta_raw;
  vector[K - 1] alpha_raw;
}

transformed parameters {
  vector[K] beta;
  vector[K] alpha;
  beta = append_row(0.0,beta_raw);
  alpha = append_row(0.0,alpha_raw);
  //print("beta=",beta);
  //matrix[D, K] beta;
}

model {
 // matrix[N, K] x_beta = to_vector(x) * beta;
  to_vector(beta) ~ normal(5, 2);
  to_vector(alpha) ~ normal(-40,10);
  //print("x_beta=", x_beta);
  
  for (n in 1:N) {
    //print("x_beta[n]'=", x_beta[n]');
    vector[K] values;
    for (k in 1:K) {
      values[k] = alpha[k] + x[n] * beta[k];
    }
    
    //print("values=",values);
    y[n] ~ categorical_logit(values);
  }
}

