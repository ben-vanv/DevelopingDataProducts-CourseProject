#
# Project: Developing Data Products - Shiny Application
# This project has two parts. First, a Shiny application that is deployed on Rstudio's servers. 
# Second, a Slidify presentation that includes a pitch for the above  your application. 
# 
# Write a shiny application with associated supporting documentation. The documentation should be thought of as whatever a user will need to get started using your application.
# Deploy the application on Rstudio's shiny server
# Share the application link by pasting it into the provided text box
# Share your server.R and ui.R code on github
# The application must include the following:
#   
#   Some form of input (widget: textbox, radio button, checkbox, ...)
# Some operation on the ui input in sever.R
# Some reactive output displayed as a result of server calculations
# You must also include enough documentation so that a novice user could use your application.
# The documentation should be at the Shiny website itself. Do not post to an external link.
# The Shiny application in question is entirely up to you. However, if you're having trouble coming up with ideas, you could start from the simple prediction algorithm done in class and build a new algorithm on one of the R datasets packages. Please make the package simple for the end user, so that they don't need a lot of your prerequisite knowledge to evaluate your application. You should emphasize a simple project given the short time frame.


library(shiny)
library(randomForest)
library(ggplot2)
library(caret)

# Define server logic required to draw a histogram
function(input, output) {
  data(mtcars)
  inTrainingSet <- createDataPartition(mtcars$mpg, p=0.6, list=FALSE)
  training <- mtcars[inTrainingSet,]
  testing <- mtcars[-inTrainingSet,]
  
  control <- trainControl(method="cv", 4)
  mtcars.rf <- train(mpg ~ ., data=mtcars, method="rf", trControl=control, ntree=250)
  
  #mtcars.rf <- randomForest(mpg ~ ., data=mtcars, ntree=1000, keep.forest=TRUE, importance=TRUE)
  
  
  output$distPlot <- renderPlot({
    
    newCar = data.frame(0, input$cylinders, input$displacement, input$horsepower, input$drat, input$weight, input$qsec, as.integer(input$vs),
                        as.integer(input$am), input$gear, input$carbs)
    names(newCar) <- names(mtcars)
    prediction <- predict(mtcars.rf, newCar)
    plotData <- c(input$dealerMpg, prediction)
    names(plotData) <- c("Dealer / Manufacturer Provided MPG", "Model Predicted MPG")
    barplot(plotData, col = 'lightblue', border = 'white')
    
   })
  
  
  output$blurb <- renderText({
    newCar = data.frame(0, input$cylinders, input$displacement, input$horsepower, input$drat, input$weight, input$qsec, as.integer(input$vs),
                        as.integer(input$am), input$gear, input$carbs)
    names(newCar) <- names(mtcars)
    prediction <- predict(mtcars.rf, newCar)
    if (prediction <= (0.9 * input$dealerMpg)){
      c("Warning: The predicted fuel consumption for a vehicle with the charateristics you have entered is ", round(prediction, 1), "MPG which is 
        significantly worse than what the dealer or manufacturer has told you about this car's MPG rating. Please consider some
        additional research before purchasing")
    } else if (prediction >= (1.1 * input$dealerMpg)) {
      c("Warning: The predicted fuel consumption for a vehicle with the charateristics you have entered is ", round(prediction, 1), "MPG which is 
        significantly better than what the dealer or manufacturer has told you about this car's MPG rating. Please consider some
        additional research before purchasing")
    } else {
      c("The predicted fuel consumption for a vehicle with the charateristics you have entered is ", round(prediction, 1), "MPG which is 
        relatively consistent what the dealer or manufacturer has told you about this car's MPG rating. However, please still consider some
        additional research before purchasing")
    }
    
  })
  
}

