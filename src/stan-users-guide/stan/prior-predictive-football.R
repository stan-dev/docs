J <- 6
epsilon <- c(0.5, 0.0001)
model <- stan_model('prior-predictive-football.stan')
fit <- sampling(model, algorithm = 'Fixed_param',
                data = list(J = J, epsilon = epsilon),
                chains = 1, warmup = 0, iter = 100, refresh = 0)

df <- data.frame(score_diff = extract(fit)$y[, 1, 2])
plot <- ggplot(df, aes(x = score_diff)) +
  geom_histogram(color = 'white', bins = 20) +
  scale_y_continuous() +
  scale_x_continuous(lim = c(0, 100), breaks = c(0, 25, 50, 75, 100)) +
  xlab("absolute score difference")

print(extract(fit)$y[ , 1, 2][1:20])
