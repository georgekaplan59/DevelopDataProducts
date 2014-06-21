library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Credit risk. Probability of default by logistic regression"),
    sidebarPanel(
        sliderInput("seed", "Random seed for sample splitting",
                    value = 100, min = 25, max = 200, step = 5,),
        sliderInput("train.proportion", "Sample proportion in the training set",
                    value = 0.7, min = 0.5, max = 0.9, step = 0.05,),
        sliderInput("threshold", "Likelihood threshold to classify as default",
                    value = 0.5, min = 0.25, max = 0.75, step = 0.05,)
    ),
    mainPanel(
        h4('ROC plot for a logistic regression model for loan default'),
        plotOutput('rocPlot')
    )
))