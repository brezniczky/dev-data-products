# Calculations that take place on the server-side.
#
# The separation of this code is meant to allow for quick & easy client-side
# testing/debugging of a large portion of the server-side execution.

get.extended.trees = function(predictors, n) {
  ext.trees = trees

  cols = c("Volume")

  rm.cols = c()
  if (predictors$height) {
    cols = c(cols, "Height")
  }

  if (predictors$girth) {
    cols = c(cols, "Girth")
  }

  if (predictors$height.girth) {
    ext.trees$height.girth = ext.trees$Height * ext.trees$Girth
    cols = c(cols, "height.girth")
  }

  if (predictors$height.girth.sq) {
    ext.trees$height.girth.sq = ext.trees$Height * ext.trees$Girth ^ 2
    cols = c(cols, "height.girth.sq")
  }

  if (predictors$height.girth.sq.n) {
    ext.trees$height.girth.sq.n = (ext.trees$Height * ext.trees$Girth ^ 2) ^ n
    cols = c(cols, "height.girth.sq.n")
  }

  return(ext.trees[, cols])
}

process.input = function(seed, train.size, predictors, n) {
  set.seed(seed)

  train.index = sample(x = nrow(trees), size = train.size)
  test.filter = rep(TRUE, nrow(trees))
  test.filter[train.index] = FALSE

  ext.trees = get.extended.trees(predictors, n)

  train.data = ext.trees[train.index, ]
  test.data  = ext.trees[test.filter, ]

  model = lm(Volume ~ ., data = train.data)

  test.prediction = predict(model, newdata = test.data)

  MAPE = function(est, truth) {
    return(mean(abs((est - truth) / truth)))
  }
  test.MAPE = MAPE(test.data$Volume, test.prediction)

  return(test.MAPE)
}

process.input.bootstrap = function(seed, train.size, predictors, n) {
  n.boots = 50
  MAPEs = rep(NA, n.boots)
  for(i in 1:n.boots) {
    MAPEs[i] = process.input(seed + i, train.size, predictors, n)
  }
  return(MAPEs)
}

test = function() {
  process.input.bootstrap(
    11, 26,
    list("girth" = TRUE, "height" = TRUE,
         "height.girth" = FALSE, "height.girth.sq" = TRUE,
         "height.girth.sq.n" = TRUE),
    0.01)
}
