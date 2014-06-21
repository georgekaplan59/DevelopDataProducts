library(shiny)
library(ROCR)
library(caret)

print("Starting server...")

# Loading data
url = "../../../edX/X.The Analytics Edge/Week 3 - Logistic Regression/Assignment/loans_imputed.csv"
loans = read.csv(url)
print(paste("Data loaded from",url))

generateROCPlot <- function(input) {

    print("------------------------------")    
    print("Shinny server invoked")
    print("Input parameters are:")
    print(paste("   Seed=",input$seed))
    print(paste("   Proportion in training set=",input$train.proportion))
    print(paste("   Probability threshold for default=",input$threshold))
    
    # Splitting the dataset
    print("Splitting dataset")
    set.seed(input$seed)
    split = createDataPartition(loans$not.fully.paid, 
                                p=input$train.proportion, list=FALSE)

    # Training the logistic model
    print("Training logistic regression model")
    log.model = glm(not.fully.paid ~ ., data=loans[split,], family="binomial")

    # Predicting on the test set
    print("Predicting probabilities for testset")
    testset = loans[-split,]
    predictions = predict(log.model, newdata=testset, type="response")

    # Estimating accuracy indicators
    print("Calculating accuracy from confusion matrix")
    con.matrix = table(testset$not.fully.paid, predictions >= input$threshold)
    accuracy = (con.matrix[1,1] + con.matrix[2,2])/sum(con.matrix)
    print("Predicting for ROC")
    ROCpredictions = prediction(predictions, testset$not.fully.paid)  
    print("Estimating area under the curve")
    AUC = as.numeric(performance(ROCpredictions, "auc")@y.values)

    # Plotting the results
    print("Generating ROC plot")
    perf = performance(ROCpredictions, "tpr", "fpr")
    plot(perf,col="blue",main="ROC Plot")
    abline(a=0,b=1,lty=2)
    text(x=0.8,y=0.2,paste("Accuracy=",round(accuracy,4)),cex=0.9)
    text(x=0.8,y=0.1,paste("AUC=",round(AUC,4)),cex=0.9)
}

shinyServer(
    function(input, output) {
        output$rocPlot <- renderPlot({generateROCPlot(input)})
    }
)