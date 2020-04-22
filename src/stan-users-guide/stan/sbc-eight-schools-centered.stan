/**
 * Simulation-based calibration of a hierarchical eight-schools model.
 * This model will fail SBC.
 *
 * Rubin's original data
 * y = { 15, 10, 16, 11, 9, 11, 10, 18 };
 * sigma = { 28, 8, -3, 7, -1, 1, 18, 12 };
 *
 * Rubin, Donald B. 1981. Estimation in Parallel Randomized Experiments.
 * Journal of Educational Statistics 6: 377–401.
 *
 * The rank-based approach to SBC for this example replicates:
 *
 * Talts, Sean, Michael Betancourt, Daniel Simpson, Aki Vehtari,
 * and Andrew Gelman. 2018. Validating Bayesian Inference Algorithms
 * with Simulation-Based Calibration. arXiv, no. 1804.06788.
 */
transformed data {
  real mu_sim = normal_rng(0, 5);
  real tau_sim = fabs(normal_rng(0, 5));
  int<lower = 0> J = 8;
  real theta_sim[J] = normal_rng(rep_vector(mu_sim, J), tau_sim);
  real<lower=0> sigma[J] = fabs(normal_rng(rep_vector(0, J), 5));
  real y[J] = normal_rng(theta_sim, sigma);
}
parameters {
  real mu;
  real<lower=0> tau;
  real theta[J];
}
model {
  tau ~ normal(0, 5);
  mu ~ normal(0, 5);
  theta ~ normal(mu, tau);
  y ~ normal(theta, sigma);
}
generated quantities {
  int<lower = 0, upper = 1> mu_lt_sim = mu < mu_sim;
  int<lower = 0, upper = 1> tau_lt_sim = tau < tau_sim;
                                               int<lower = 0, upper = 1> theta1_lt_sim = theta[1] < theta_sim[1];
}
