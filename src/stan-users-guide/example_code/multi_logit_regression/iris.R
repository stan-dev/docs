library("cmdstanr")
#========== from https://www.r-bloggers.com/prototyping-multinomial-logit-with-r/
data(iris)
### method 1: nnet package ###
library(nnet)
mdl1 <- multinom(Species ~ Sepal.Length, data = iris, model = TRUE)
summary(mdl1)

#predict
#             (Intercept) Sepal.Length
# versicolor=1   -26.08339     4.816072
# virginica =2 -38.76786     6.847957
# 
# Std. Errors:
#   (Intercept) Sepal.Length
# versicolor    4.889635    0.9069211
# virginica     5.691596    1.0223867

new_data <- data.frame(Sepal.Length=c(4.5,6,8,4))
predictions <- predict(mdl1,type="probs",newdata=new_data)

val <- 6
versicolor_v <- -26.08339 + 4.816072*val
virginica_v <- -38.76786 + 6.847957*val
setosa_v <- 0
numerator <- exp(versicolor_v) + exp(virginica_v) + exp(setosa_v)
setosa_p <- exp(setosa_v)/numerator
versicolor_p <- exp(versicolor_v)/numerator
virginica_p <- exp(virginica_v)/numerator

#========Stan version
N <- nrow(iris)
D <- 1 # number of predictors
K <- 3 # number of categories

x_matrix <- matrix(ncol=D,nrow=N)
x_matrix[,1] <- iris$Sepal.Length
#map setosa=1, versicolor=2, virgnica=3
y = ifelse(iris$Species=="setosa",1,ifelse(iris$Species=="versicolor",2,3))
#---------
x <- x_matrix[,1]
data_0 <- list(D=D, N=N, K=K, x=x_matrix[,1], y=y)
dump(c('D','N','K','x','y'),"data_0.rdump")
#works with correct answer from cmdstan




cmdstanr::set_cmdstan_path("~/.cmdstanr/cmdstan-2.23.0/")
model_0 <- cmdstan_model("one_pred_multi_logit_regression_dummy.stan")

#model_0 <- cmdstan_model("bug.stan")
fit_0 <- model_0$sample(data=data_0, output_dir=".", validate_csv = FALSE)
stanfit_0 <- rstan::read_stan_csv(fit_0$output_files())

library(rstan)
fit_0 <- model_0$sample(data = data_0,
                        output_dir = "output")
stanfit <- rstan::read_stan_csv(fit_0$output_files())
print(stanfit)
# lp__     -105.   -105.   1.36  1.22  -108.   -104.    1.00    1155.
# 2 beta_ra…    5.05    5.04 0.650 0.646    3.97    6.13  1.00     602.
# 3 beta_ra…    7.03    7.03 0.710 0.681    5.81    8.20  1.00     618.
# 4 alpha_r…  -27.4   -27.3  3.51  3.47   -33.3   -21.6   1.00     622.
# 5 alpha_r…  -39.7   -39.8  3.98  3.81   -46.3   -32.8   1.00     635.
# 6 beta[1]     0       0    0     0        0       0    NA         NA 
# 7 beta[2]     5.05    5.04 0.650 0.646    3.97    6.13  1.00     602.
# 8 beta[3]     7.03    7.03 0.710 0.681    5.81    8.20  1.00     618.
# 9 alpha[1]    0       0    0     0        0       0    NA         NA 
# 10 alpha[2]  -27.4   -27.3  3.51  3.47   -33.3   -21.6   1.00     622.
# 11 alpha[3]  -39.7   -39.8  3.98  3.81   -46.3   -32.8   1.00     635.
#---------- 

data_1 <- list(D=D, N=N, K=K, x=x_matrix, y=y)

model_1 <- cmdstan_model("multi_logit_regression_dummy_explicit_intercept.stan")
fit_1 <- model_1$sample(data = data_1,
                        output_dir = "output",validate_csv = FALSE)
print(fit_1$summary())
print(rstan::read_stan_csv(fit_1$output_files()))

# mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
# beta_raw[1,1]   5.09    0.04 0.94   3.46   4.43   5.03   5.67   7.14   478    1
# beta_raw[1,2]   7.21    0.05 1.07   5.31   6.48   7.13   7.86   9.53   477    1
# alpha_raw[1]  -27.59    0.23 5.08 -38.76 -30.74 -27.21 -24.05 -18.74   480    1
# alpha_raw[2]  -40.79    0.27 5.97 -53.49 -44.37 -40.41 -36.70 -30.15   487    1
# beta[1,1]       0.00     NaN 0.00   0.00   0.00   0.00   0.00   0.00   NaN  NaN
# beta[1,2]       5.09    0.04 0.94   3.46   4.43   5.03   5.67   7.14   478    1
# beta[1,3]       7.21    0.05 1.07   5.31   6.48   7.13   7.86   9.53   477    1
# alpha[1]        0.00     NaN 0.00   0.00   0.00   0.00   0.00   0.00   NaN  NaN
# alpha[2]      -27.59    0.23 5.08 -38.76 -30.74 -27.21 -24.05 -18.74   480    1
# alpha[3]      -40.79    0.27 5.97 -53.49 -44.37 -40.41 -36.70 -30.15   487    1
# lp__          -93.09    0.05 1.42 -96.71 -93.81 -92.77 -92.04 -91.29   858    1


#===============intercept implicit 'i_i'
D_i_i <- D+1
x_i_i <- matrix(ncol=D_i_i,nrow=N)
x_i_i[,2] <- x
x_i_i[,1] <- rep(1,N)

data_i_i <- list(D_i_i=D_i_i, N=N, K=K, x_i_i=x_i_i, y=y)

model_2_1 <- cmdstan_model("multi_logit_regression_dummy_i_i.stan")
fit_2_1 <- model_2_1$sample(data = data_i_i,
                        output_dir = "output",validate_csv = FALSE)
//print(fit_1$summary())
print(rstan::read_stan_csv(fit_2_1$output_files()))

# mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
# beta_raw[1,1] -27.03    0.26 5.12 -37.78 -30.51 -26.63 -23.40 -18.07   379 1.01
# beta_raw[1,2] -40.16    0.30 5.84 -52.70 -44.15 -39.74 -35.96 -29.78   386 1.02
# beta_raw[2,1]   4.99    0.05 0.95   3.33   4.32   4.92   5.63   6.98   377 1.01
# beta_raw[2,2]   7.09    0.05 1.05   5.22   6.34   7.02   7.82   9.33   379 1.02
# beta[1,1]       0.00     NaN 0.00   0.00   0.00   0.00   0.00   0.00   NaN  NaN
# beta[1,2]     -27.03    0.26 5.12 -37.78 -30.51 -26.63 -23.40 -18.07   379 1.01
# beta[1,3]     -40.16    0.30 5.84 -52.70 -44.15 -39.74 -35.96 -29.78   386 1.02
# beta[2,1]       0.00     NaN 0.00   0.00   0.00   0.00   0.00   0.00   NaN  NaN
# beta[2,2]       4.99    0.05 0.95   3.33   4.32   4.92   5.63   6.98   377 1.01
# beta[2,3]       7.09    0.05 1.05   5.22   6.34   7.02   7.82   9.33   379 1.02
# lp__          -93.04    0.04 1.41 -96.49 -93.72 -92.71 -92.00 -91.27  1064 1.00


x_one_hot <- matrix(ncol=K, nrow=N)
#x_one_hot[, 1] <- ifelse(iris$Species=="setosa",1,0) # predictor values
x_one_hot[, 1] <- ifelse(iris$Species=="versicolor",1,0) # predictor values
x_one_hot[, 2] <- ifelse(iris$Species=="virginica",1,0) # predictor values
x_one_hot[, 3] <- iris$Sepal.Length
data_one_hot <- list(D=K, N=N, K=K, x_one_hot=x_one_hot, y=y)

model_3 <- cmdstan_model("multi_logit_regression_dummy_explicit_intercept_one_hot.stan")
fit_3 <- model_3$sample(data = data_one_hot,
                        output_dir = "output",
                        validate_csv=FALSE)
print(rstan::read_stan_csv(fit_3$output_files()))
#print(fit_3$summary())

model_2 <- cmdstan_model("multi_logit_regression_dummy.stan")
#model_2 <- cmdstan_model("tmp.stan")

fit_2 <- model_2$sample(data = data_one_hot,
                        output_dir = "output")
print(fit_2$summary())
draws_array <- fit_2$draws()
draws_df <- as_draws_df(draws_array)

dot <- function(list1,list2) {
  sum <- 0
  for (i in 1:length(list1)) {
    sum = sum + list1[i]*list2[i]
  }
  sum
}

beta <- matrix(ncol=3,nrow=4,byrow=TRUE,c(0,-1.18873,-0.00348918,
                                          0,-0.913794,0.795856,
                                          0,-0.290665,1.57215,
                                          0,-0.826089,-0.597067))

for(i in 1:length(x_one_hot[1,])) {#row
  result <- rep(NA,ncol(beta))
  for (j in 1:ncol(beta)) { #col
    result[j] <- dot(x_one_hot[1,],beta[,j])
  }
}


# Not a good fit
# A tibble: 4 x 10
# variable     mean   median    sd   mad      q5     q95  rhat ess_bulk
# <chr>       <dbl>    <dbl> <dbl> <dbl>   <dbl>   <dbl> <dbl>    <dbl>
#   1 
# lp__     -165.    -165.     1.32  1.00 -168.   -164.    1.01     593.
# 2 
# beta[1,…   -0.162   -0.186  3.13  2.94   -5.59    5.00  1.01     289.
#        3 
# beta[1,…   -0.133   -0.156  3.13  2.94   -5.56    5.04  1.01     289.
#               4 
# beta[1,…   -0.116   -0.138  3.13  2.93   -5.54    5.06  1.01     289.
#                      # … with 1 more variable: ess_tail <dbl>



   
beta=[[0,-0.753589,1.7705],[0,-0.138326,0.292239],[0,-1.88199,1.94388],[0,0.17507,1.97379]]

x=[[1,0,0,5.1]

x_beta=[[0,3.41025,6.31258],



#========
print(fit_1$summary())

model_01 <- cmdstan_model("three_way_binary_regression_dummy.stan")
fit_01 <- model_01$sample(data = data_0,
                          output_dir = "output")
print(fit_01$summary())  
model_binary <- cmdstan_model("../simple_logistic_regression/logistic_regression.stan")
data_setosa_v_versicolor <- list(x=x_matrix[,1][1:100], y=y[1:100],N=100)
fit_setosa_v_versicolor <- model_binary$sample(data=data_setosa_v_versicolor)
print(fit_setosa_v_versicolor$summary())
one_hot <- matrix(ncol=k, nrow=n)
one_hot[, 2] <- ifelse(iris$Species=="versicolor",1,0) # predictor values
one_hot[, 3] <- ifelse(iris$Species=="virginica",1,0) # predictor values
one_hot[, 1] <- ifelse(iris$Species=="setosa",1,0) # predictor values

dummies_intercept_encoded <- one_hot
dummies_intercept_encoded[,1] <- rep(1,nrow(dummies)) # convert to setosa to intercept, always 1

========

setosa_v_versicolor <- subset(iris,(iris$Species != 'virginica'))
setosa_v_versicolor[,'y'] <- ifelse(setosa_v_versicolor$Species=='setosa',0,1)

setosa_v_virginica <- subset(iris,(iris$Species != 'versicolor'))
setosa_v_virginica[,'y'] <- ifelse(setosa_v_virginica$Species=='setosa',0,1)

N <- nrow(setosa_v_virginica)
y <- ifelse(setosa_v_virginica$Species
model_2 <- cmdstan_model("logistic_regression.stan")
fit_2 <- model$sample(data = list(N=,
                      output_dir = "output")
print(fit_2$summary())



library(brms)
library(rstan)
rstan_options (auto_write=TRUE)
options (mc.cores=parallel::detectCores ()) # Run on multiple cores

set.seed (3875)

ir <- data.frame (scale (iris[, -5]), Species=iris[, 5])
b2 <- brm (Species ~ Petal.Length + Petal.Width + Sepal.Length + Sepal.Width, data=ir,
             family="categorical", n.chains=3, n.iter=3000, n.warmup=600,
             prior=c(set_prior ("normal (0, 8)")))


===============run independent binary logistic regression========
  
data(iris)

setosa_v_versicolor <- subset(iris,(iris$Species != 'versicolor'))
setosa_v_versicolor[,'y'] <- ifelse(setosa_v_versicolor$Species=='setosa',0,1)

setosa_v_virginica <- subset(iris,(iris$Species != 'virginica'))
setosa_v_virginica[,'y'] <- ifelse(setosa_v_virginica$Species=='setosa',0,1)

data_setosa_v_versicolor <- list(N=length(setosa_v_versicolor$Species),
                                 y=setosa_v_versicolor$y,
                                 x=setosa_v_versicolor$Sepal.Length)

model_setosa_v_versicolor <- cmdstan_model("logistic_regression.stan")
fit_setosa_v_versicolor <- model_setosa_v_versicolor$sample(data = data_setosa_v_versicolor, 
                                                            output_dir = "output")
print(paste("ran stan executable: ", model_setosa_v_versicolor$exe_file()))
print(fit_setosa_v_versicolor$summary())

library(nnet)
mdl1 <- multinom(y ~ x, model = TRUE)
summary(mdl1)



library(rstanarm)
stan_glm(y ~ Sepal.Length, family=binomial(link="logit"), 
         data=setosa_v_versicolor)
(Intercept)  -32.5    6.5 
Sepal.Length   5.7    1.2 

library(nnet)
mdl1 <- multinom(Species ~ Sepal.Length, data=iris, model = TRUE)
summary(mdl1)


mdl2 <- multinom(y ~ Sepal.Length, data=setosa_v_versicolor, model = TRUE)
summary(mdl2)


mdl3 <- multinom(y ~ Sepal.Length, data=setosa_v_virginica, model = TRUE)
summary(mdl3)


