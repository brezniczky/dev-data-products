shinyUI(pageWithSidebar(
  headerPanel("Tree volume estimation"),

  sidebarPanel(
    checkboxGroupInput("predictors", "Predictors",
                       selected = c("height.girth.sq"),
                       c("Height" = "height",
                         "Girth" = "girth",
                         "Height * Girth" = "height.girth",
                         "Height * Girth ^ 2" = "height.girth.sq",
                         "(Height * Girth ^ 2) ^ n" = "height.girth.sq.n")),
    sliderInput("n", "n (exponent)", value = 1.05,
                min = 0.1, max = 2.0, step = 0.01),
    sliderInput('seed', 'Random seed', value = 1111,
                min = 1000, max = 2000,
                step = 1),
    sliderInput("train.size", "Training set size", value = 20,
                min = 10, max = nrow(trees) - 5,
                step = 1)
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Application",
        p("MAPE:"),
        verbatimTextOutput("MAPE"),
        p("bootstrap MAPE estimate (50 re-runs with iterated randseeds):"),
        verbatimTextOutput("MAPE.20"),
        plotOutput("MAPE.hist")
      ),
      tabPanel("Help",
               h4("Description"),
               p("This application demonstrates how accurate predictions can be
                  achieved using linear regression and certain variables when
                  estimating the volume of wood obtained from a tree knowing
                  certain parameters. A model is regressed ('trained') and
                  evaluated using the trees data."),
               h4("Predictors"),
               p("Select at least one predictor to model the volume values with."),
               h4("n"),
               p("Exponent of the outer power in the last predictor."),
               h4("Random seed"),
               p("Random seed making the results reproducible."),
               h4("Training set size"),
               p("This allows for setting the training set size. The resulting
                 predictions are evaluated against the remainder of the trees
                 data."),
               h4("MAPE"),
               p("Although the linear regression is naturally MSE (mean squared
                  error) based, MAPE (mean average percentage error) is a more
                  interesting practical measure of goodness, and this is
                  displayed. Supposedly later on the modelling procedure will
                  involve all the delicacies, like considering maximum
                  likelihood and/or optimisation for MAPE.")
      )
    )
  )
))
