library(ggplot2)

set.seed(1234)
x <- rnorm(100)
y <- 2 * x + rnorm(100)

model <- lm(y ~ x)
model_summary <- summary(model)

estimation_uncertainty <- model_summary$coefficients[, "Std. Error"]
prediction_uncertainty <- predict(model, interval = "prediction", level = 0.95)

est_err <- 2 * estimation_uncertainty
pred_err_up <- prediction_uncertainty[, "upr"]
pred_err_lwr <- prediction_uncertainty[, "lwr"]

data <- data.frame(x = x, y = y)
plt <- ggplot(data, aes(x = x, y = y)) +
  geom_point(color = "black", size = 3) +
  geom_abline(
    intercept = coef(model)[1],
    slope = coef(model)[2],
    color = "red", size = 1
  ) +
  geom_errorbar(
    aes(
      ymin = fitted(model) - est_err,
      ymax = fitted(model) + est_err
    ),
    color = "blue", width = 0.1
  ) +
  geom_errorbar(
    aes(
      ymin = pred_err_lwr,
      ymax = pred_err_up
    ),
    color = "green", width = 0.1
  ) +
  labs(
    title = "Estimation vs Prediction Uncertainty",
    x = "x",
    y = "y"
  ) +
  theme_classic() +
  theme(legend.position = "topright")

ggsave("plot.pdf", plt, device = "pdf")
print(plt)
