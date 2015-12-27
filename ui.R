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
                step = 1),
    h4("Description"),
    p(
      "This application demonstrates how accurate predictions can be
        achieved using linear regression and certain variables when estimating
        the volume of wood obtained from a tree knowing certain parameters.")
  ),

  mainPanel(
    p("MAPE:"),
    verbatimTextOutput("MAPE"),
    p("bootstrap MAPE estimate (50 re-runs):"),
    verbatimTextOutput("MAPE.20"),
    plotOutput("MAPE.hist")
  )
))