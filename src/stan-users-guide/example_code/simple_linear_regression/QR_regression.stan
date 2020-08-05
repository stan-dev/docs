data {
  int<lower = 0> N; // number of data items
  int<lower = 0> K; // number of predictors
  matrix[N, K] x; // predictor matrix
  vector[N] y; // outcome vector
}

transformed data {
  matrix[N, K] Q_ast;
  matrix[K, K] R_ast;
  matrix[K, K] R_ast_inverse;
// thin and scale the QR decomposition
  Q_ast = qr_thin_Q(x) * sqrt(N - 1);
  R_ast = qr_thin_R(x) / sqrt(N - 1);
  R_ast_inverse = inverse(R_ast);
}

parameters {
  real alpha; // intercept
  vector[K] theta; // coefficients on Q_ast
  real<lower = 0> sigma; // error scale
}

model {
  alpha ~ normal(0, 1);
  theta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  y ~ normal(Q_ast * theta + alpha, sigma); // likelihood
}

generated quantities {
  vector[K] beta;
  beta = R_ast_inverse * theta; // coefficients on x
}
