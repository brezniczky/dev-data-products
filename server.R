# setwd("/media/janca/Code/Coursera/Developing Data Products/assignment/shiny")
#
library(shiny)

source("server.ops.R")

convert.ui.predictors = function(predictors) {
  return(list(
    girth = "girth" %in% predictors,
    height = "height" %in% predictors,
    height.girth = "height.girth" %in% predictors,
    height.girth.sq = "height.girth.sq" %in% predictors,
    height.girth.sq.n = "height.girth.sq.n" %in% predictors
  ))
}

shinyServer(
  function(input, output) {
    output$MAPE =
      renderText(
        paste0(
          round(
            process.input(
              input$seed,
              input$train.size,
              convert.ui.predictors(input$predictors),
              input$n
            ) * 100,
            digits = 2),
          " %")
      )

    bootstrap.res =
      reactive( {
        process.input.bootstrap(
          input$seed,
          input$train.size,
          convert.ui.predictors(input$predictors),
          input$n
        )
      })

    output$MAPE.20 =
      renderText(
        paste0(
          round(mean(bootstrap.res()) * 100,
            digits = 2
          ),
          " %")
      )
    output$MAPE.hist =
      renderPlot(hist(bootstrap.res(), main = "Bootstrap MAPE distribution",
                      xlab = "MAPE value"),
                 col = "blue")
  }
)
