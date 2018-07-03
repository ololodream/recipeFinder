library("rjson")
source("RecipeFinder.R")
server <- function(input, output, session) {
 
  observe({
    input$file_csv
    input$file_json
    isolate({
      
       
      if(is.null(input$file_csv))
      {
        return(NULL)
      }
      if(is.null(input$file_json))
      {
        return(NULL)
      }
      
      rf <- RecipeFinder$new()
      
      #check csv     
      ingredients <- rf$valid_csv(
          file_path = input$file_csv$datapath,
          headers   =  NULL, 
          types     =  c("factor","numeric","factor","date"))
      
      #check json
      recipes   <- rf$valid_json(input$file_json$datapath)
     
      #if any file is empty return 0
      if(length(ingredients)==0 || length(recipes)==0 || any(ingredients$amount < 0))
      {
        result        <-  Str_Err
        output$result <- renderText({ 
          result
        })
        return (0)
      }
      
      # remove ingredients out of date
      new_ingredient <- rf$remove_out_of_date(
        data    = ingredients,
        coloum  = 'use_by',
        sysDate = sysDate)
      
      #all ingredients in firidge out of date
      if(nrow(new_ingredient) == 0)
      {
        result        <- Str_Ord_Token
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
        by  = 'item',
        all = TRUE)
      names(sum_ingredients) <- c('item','amount','date')
      
      #find dishes can be made
      dishes <- rf$search_dishes(recipes, sum_ingredients)
      
      # 0 or only one dish is found
      if(length(dishes) <= 1)
      {
        result        <- ifelse(
          length(dishes)==0, 
          Str_Ord_Token, 
          names(dishes)[1])
        output$result <- renderText({ 
            result
        })
        return (0)
      }
      
      # more than 1 dishes can be made, then search closest dish
      dishes        <- rf$search_closest(dishes)
     
      #render result
      result        <- names(dishes)[1]
      output$result <- renderText({ 
        result
      })
      
    })
  })
}
