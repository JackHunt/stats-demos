library(ggplot2)

data(mtcars)
x <- mtcars$wt
y <- mtcars$mpg

data <- data.frame(x = x, y = y)

pi <- predict(model,
  newdata = data, interval = "prediction",
  level = 0.95
)

ci <- predict(model,
  newdata = data, interval = "confidence",
  level = 0.95
)

plt <- ggplot(data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = lm, se = TRUE) +
  geom_line(aes(y = pi[, 2]), color = "red", linetype = "dashed") +
  geom_line(aes(y = pi[, 3]), color = "red", linetype = "dashed") +
  geom_line(aes(y = ci[, 2]), color = "#4400ff", linetype = "dashed") +
  geom_line(aes(y = ci[, 3]), color = "#4400ff", linetype = "dashed") +
  labs(
    title = "MPG vs Weight",
    x = "Weight",
    y = "MPG"
  ) +
  scale_color_manual(
    values = c("red", "#4400ff"),
    labels = c("95% PI", "95% CI")
  ) +
  guides(color = guide_legend(title = "Intervals"))

ggsave("plot_gg.pdf", plot = plt)
