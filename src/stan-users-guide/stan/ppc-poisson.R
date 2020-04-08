library(rstan)
library(ggplot2)

set.seed(1234)

model <- stan_model('ppc-poisson.stan')
runs <- c("y", paste("y_rep",1:8))

ppc <- function(y, title) {
  N <- length(y)
  fit <- sampling(model, data = list(N = N, y = y),
              iter = 1000, seed = 1234)
  ss <- extract(fit)
  pvalue_mean <- mean(ss$mean_gt)
  pvalue_sd <- mean(ss$sd_gt)
  df <- data.frame(y = y, run = rep(runs[1], N))
  for (i in 1:8) {
    y_rep_i <- ss$y_rep[i, ]
    df_row <- data.frame(y = y_rep_i, run = rep(runs[i + 1], N))
    df <- rbind(df, df_row)
  }
  plot <- ggplot(df, aes(x = y)) +
    stat_bin(color = 'white', center = 5, binwidth = 1, size=0.25) +
    facet_wrap(. ~ run, ncol = 3) +
    scale_y_continuous(breaks = c()) +
    ylab("") +
    xlab("y or y_rep") +
    ggtitle(title)
  list(pvalue_mean = pvalue_mean,
       pvalue_sd = pvalue_sd,
       plot = plot,
       fit = fit)
}

N <- 200
lambda <- 5
y <- rpois(N, lambda)
result <- ppc(y, "Poisson data, Poisson model")
plot <- result$plot
p_mean <- result$pvalue_mean
p_sd <- result$pvalue_sd
ggsave("ppc-pois-pois.jpg", plot, width=6, height=4)

mu <- 5
size <- 1
y_nb <- rnbinom(N, mu = mu, size = size)
result_nb <- ppc(y_nb, "Negative binomial data, Poisson model")
plot_nb <- result_nb$plot
p_mean_nb <- result_nb$pvalue_mean
p_sd_nb <- result_nb$pvalue_sd
ggsave("ppc-nb-pois.jpg", plot_nb, width=6, height=4)

fit_nb <- result_nb$fit
df_mean <- data.frame(mean_y_rep = extract(fit_nb)$mean_y_rep)
mean_y <- mean(y_nb)
plot_mean <- ggplot(df_mean, aes(x = mean_y_rep)) +
  geom_histogram(color = 'white', size = 0.25) +
  geom_vline(xintercept = mean_y, color = 'red', size = 1) +
  scale_y_continuous(breaks = c()) +
  ylab("") +
  xlab("mean(y_rep)") +
  ggtitle("Poisson model, negative binomial data",
          subtitle = "posterior p-value for mean(y)")
ggsave('ppc-pvalue-nb-pois-mean.jpg', plot_mean, width = 6, height = 4)

df_sd <- data.frame(sd_y_rep = extract(fit_nb)$sd_y_rep)
sd_y <- sd(y_nb)
plot_sd <- ggplot(df_sd, aes(x = sd_y_rep)) +
  geom_histogram(color = 'white', size = 0.25) +
  geom_vline(xintercept = mean_y, color = 'red', size = 1) +
  scale_y_continuous(breaks = c()) +
  ylab("") +
  xlab("sd(y_rep)") +
  ggtitle("Poisson model, negative binomial data",
          subtitle = "posterior p-value for sd(y)")
ggsave('ppc-pvalue-nb-pois-sd.jpg', plot_sd, width = 6, height = 4)
