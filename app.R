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


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Reported Car Fuel Consumption Checker"),
   p("Given events like the VW emissions and fuel consumption scandal, how do you know if a fuel consumption number that you have
           been quoted by a dealer or manufacturer is just too good to be true? This application assists you in determining if the fuel consumption of a vehicle
          that you have been quoted is consistent with a prediction of what it should be based on other vehicles with similar characteristics from our data."),
   
   # Sidebar with inputs for determining fuel consumption
   sidebarLayout(
      sidebarPanel(
        p(strong("Reported MPG  Information:")),
        p("Enter the Dealer or Manufacturer promised fuel consumption information below"),
        sliderInput("dealerMpg",
                    "What has the dealer or manufacturer reported the MPG to you as?",
                    min = 5.0,
                    max = 50.0,
                    value = 10.0,
                    step = 0.1
                    ),
        hr(),
        p(strong("Vehicle Characteristics:")),
        p("Enter the characteristics of the vehicle below"),
        sliderInput("displacement",
                     "Displacement of Engine (cu.in.):",
                     min = 50,
                     max = 500,
                     value = 200),
         sliderInput("weight",
                     "Weight of the Car (1000 lbs):",
                     min = 1.0,
                     max = 6.0,
                     value = 3.0,
                     step = 0.1),
         sliderInput("horsepower",
                     "Gross horsepower of Engine:",
                     min = 20,
                     max = 400,
                     value = 100),
         sliderInput("cylinders",
                     "Number of Engine Cylinders:",
                     min = 2,
                     max = 10,
                     value = 4),
         sliderInput("carbs",
                     "Number of Carburetors:",
                     min = 1,
                     max = 10,
                     value = 4),
         sliderInput("drat",
                     "Rear axle ratio:",
                     min = 2.5,
                     max = 5.0,
                     value = 3.5,
                     step = 0.1),
         sliderInput("gear",
                     "Number of Gears:",
                     min = 2,
                     max = 6,
                     value = 4),
         sliderInput("qsec",
                     "1/4 mile time (secs):",
                     min = 10.0,
                     max = 25.0,
                     value = 15.0,
                     step = 0.1),
         radioButtons("vs",
                     "V or Straight Engine:",
                     choices = list("V-Engine" = 0, "Straight Engine" = 1)),
         radioButtons("am",
                      "Transmission:",
                      choices = list("Automatic" = 0, "Manual" = 1))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         textOutput("blurb")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
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
  
})

# Run the application 
shinyApp(ui = ui, server = server)

