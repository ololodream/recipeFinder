library("rjson")

server <- function(input, output, session) {

  observe({
    input$file_csv
    input$file_json
    isolate({
      inFile <- input$file_csv
      if(is.null(inFile))
      {
        return(NULL)
      }
      
      #load csv file
      ingredients <- NULL
      tryCatch(
        ingredients <- read.csv(input$file_csv$datapath, header = F),
        error        = function(e) NULL
        )
      
      #load json file
      inFile2 <- input$file_json
      if(is.null(inFile2))
      {
        return(NULL)
      }
      recipes <- NULL
      tryCatch(
        recipes <- fromJSON(file = input$file_json$datapath),
        error    = function(e) NULL
        )
      
      #if any file is empty return 0
      if(length(ingredients)==0||length(recipes)==0)
      {
        result <-  Str_Ord_Token
        output$result <- renderText({ 
          result
        })
        return (0)
      }
      
      # format ingredients
      colnames(ingredients) <- HEADER
      ingredients$item      <- as.factor(ingredients$item)
      ingredients$amount    <- as.numeric(ingredients$amount)
      ingredients$unit      <- as.factor(ingredients$unit)
      ingredients$use_by    <- as.Date(ingredients$use_by, DATE_FORMAT)
      
      # remove ingredients out of date
      new_ingredient <- subset(ingredients, ingredients$use_by> sysDate)
      
      if(nrow(new_ingredient) == 0)
      {
        result <- Str_Ord_Token
        output$result <- renderText({ 
          result
        })
        return (0)
      }
      
      #sum up amount by item name
      sum_igd_amount  <- aggregate(
        x     = new_ingredient$amount,
        by    = list(item = new_ingredient$item),
        FUN   = sum, 
        na.rm = TRUE)
      sum_igd_date    <- aggregate(
        x     = new_ingredient$use_by,
        by    = list(item = new_ingredient$item),
        FUN   = min, 
        na.rm = TRUE)
      sum_ingredients =  merge(
        sum_igd_amount, 
        sum_igd_date, 
        by = 'item',
        all = TRUE)
      names(sum_ingredients) <- c('item','amount','date')
      
      #search dishes can be made
      dishes <- list()
      for( i in 1: length(recipes))
      {
        recipe           <- recipes[[i]]
        ingredient_dates <- c()
        found            <- TRUE
        for( j in 1: length(recipe$ingredients))
        {
          ingredient_name   <- recipe$ingredients[[j]]$item
          ingredient_amount <- as.numeric(recipe$ingredients[[j]]$amount)
          ingre_fridge      <- subset(sum_ingredients, item == ingredient_name)
          
          if((!ingredient_name %in% sum_ingredients$item) ||
             (ingredient_amount > subset(sum_ingredients, item == ingredient_name)$amount))
          { #unable to find ingredient
            found <- FALSE
           
          }else{
            # successfully found ingredient
            ingredient_dates <- append(ingredient_dates, ingre_fridge$date)
          }
        }
        
        if(found)
        {
          dishes[[recipes[[i]]$name]] <- sort(ingredient_dates,decreasing = FALSE)
        }
      }
      
      # 0 or only one dish is found
      if(length(dishes)<=1)
      {
        result        <- ifelse(length(dishes)==0, "Order Taken", names(dishes)[1])
        output$result <- renderText({ 
            result
        })
        return (0)
      }
      
      # more than one recipe found
      # search closest dish
      same     <- all(sapply(dishes, function(x) all(x == dishes[[1]])))
      min_date <- min(as.Date(sapply(dishes,min),ORIGIN))
      
      filter   <- as.vector(sapply(dishes, function(x) min_date %in% x))
      dishes   <- dishes[filter]
      
      while(length(dishes)>1 &&  !same)
      {
        dishes <- lapply(dishes, function(x) x[-1]) # remove the first ele, the oldest ele
        dishes <- sapply(dishes, function(x) if(length(x)==0){x<- NULL}else{x<-x}) #0 -> NULL
        filter <- which(sapply(dishes, is.null))
        if(length(filter)!=0)
        {
          dishes <- dishes[-which(sapply(dishes, is.null))]# remove NULL
        }
        same     <- all(sapply(dishes, function(x) all(x == dishes[[1]])))
        min_date <- min(as.Date(sapply(dishes,min),ORIGIN))
        filter   <- as.vector(sapply(dishes, function(x) min_date %in% x))
        dishes   <- dishes[filter]
      }
     
      #render result
      result        <- names(dishes)[1]
      output$result <- renderText({ 
        result
      })
      
    })
  })
}
