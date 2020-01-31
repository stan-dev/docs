library(rstan)
model <- stan_model('sbc-eight-schools-centered.stan')

thin <- 5
warmup <- 1000
draws <- 999

rank_mu <- c()
rank_tau <- c()
rank_theta1 <- c()
N <- 200
for (n in 1:N) {
  if (n == 1 || n %% 5 == 0) cat("n = ", n, "\n")
  fit <- sampling(model, chains = 1,
                  warmup = warmup, iter = warmup + thin *  draws,
		  thin = thin, refresh = 0)
  rank_mu[n] = sum(extract(fit)$mu_lt_sim)
  rank_tau[n] = sum(extract(fit)$tau_lt_sim)
  rank_theta1[n] = sum(extract(fit)$theta1_lt_sim[1])
}

library(ggplot2)
plot_mu <- ggplot(data.frame(rank = rank_mu), aes(x = rank)) +
  geom_histogram(binwidth = 50, fill = "gray", color = "black",
                 boundary = 0) +
  scale_x_continuous(lim = c(0, 1000)) +
  xlab("rank of mu_sim")

plot_tau <- ggplot(data.frame(rank = rank_tau), aes(x = rank)) +
  geom_histogram(binwidth = 50, fill = "gray", color = "black",
                 boundary = 0) +
  scale_x_continuous(lim = c(0, 1000)) +
  xlab("rank of tau_sim")

plot_theta1 <- ggplot(data.frame(rank = rank_theta1), aes(x = rank)) +
  geom_histogram(binwidth = 50, fill = "gray", color = "black",
                 boundary = 0) +
  scale_x_continuous(lim = c(0, 1000)) +
  xlab("rank of theta_sim[1]")

ggsave("../img/sbc-ctr-8-schools-mu.png", plot = plot_mu, width = 4, height = 3)
ggsave("../img/sbc-ctr-8-schools-tau.png", plot = plot_tau, width = 4, height = 3)
ggsave("../img/sbc-ctr-8-schools-theta1.png", plot = plot_theta1, width = 4, height = 3)
