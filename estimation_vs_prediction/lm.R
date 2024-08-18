set.seed(1234)

data(mtcars)
x <- mtcars$wt
y <- mtcars$mpg

model <- lm(y ~ x)
model_summary <- summary(model)
print(model_summary)

data <- data.frame(x = x, y = y)

ci <- predict(model,
  newdata = data, interval = "confidence",
  level = 0.95
)

pi <- predict(model,
  newdata = data, interval = "prediction",
  level = 0.95
)

pdf("plot.pdf")

plot(x, y, xlab = "Weight", ylab = "MPG", main = "MPG vs Weight")
abline(model, col = "#ec0808")

lines(x, ci[, 2], col = "blue", lty = 2)
lines(x, ci[, 3], col = "blue", lty = 2)

lines(x, pi[, 2], col = "orange", lty = 2)
lines(x, pi[, 3], col = "orange", lty = 2)

dev.off()
