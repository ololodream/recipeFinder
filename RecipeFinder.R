library(R6)

RecipeFinder <- R6Class(
  "RecipeFinder",
  public = list(
    
    # function:     valid_json
    # input   :     file_path: String 
    # return  :     file: List
    # if file type is wrong, or keys don't match keys required,
    # return NULL
    # otherwise, return file content
    valid_json = function(file_path )
    {
      file <- tryCatch(
        fromJSON(file = file_path),
        error    = function(e) NULL
      )
      
      file_length = length(file)
      if(file_length == 0)
      {
        print("file is empty")
        return (NULL)
      }
      file <- tryCatch(
        {
          if(!all(sapply(file, function(x) !(is.null(x$name)&&is.null(x$ingredients)))))
          { 
            print("wrong json format")
            return (NULL)
          }else{
            
            amounts <- sapply(file, function(x) { sapply(x$ingredients, function(i) { (i$amount)} )})
            if(any(sapply(amounts, function(x) any(x<0))))
            {
              return(NULL)
            }else{
              return(file)
            }
            return(file)
          }
        },
        error = function(e) {
          print("some error")
          return (NULL)}
      )
      
     return (file)
    },
    
    # function:     valid_csv
    # input   :     file_path: String 
    # return  :     List
    # if file type is wrong, return NULL
    # if headers don't match headers required, return NULL 
    # if data type doesn't match header, return NULL
    # return NULL
    # otherwise, return file content
    valid_csv = function(file_path, headers = NULL, types)
    {
      #is csv
      file<-tryCatch(
        read.csv(file_path, header = !is.null(headers)),
        error        = function(e) NULL
      )
      
      file_length = length(file)
      
      # empty file
      if(file_length == 0)
      {
        return (NULL)
      }
      #match headers 
      if(!is.null(headers))
      {
        if(!all(colnames(file)==headers))
        {
          return (NULL)
        }
      }
      
      # print('match type')
      #match types
      for(i in (1:file_length))
      {
        type <- FALSE
        switch(types[i],
        
          "factor"  = type <- is.factor(file[[i]]),
          "integer" = type <- is.integer(file[[i]]),
          "numeric" = type <- is.numeric(file[[i]]),
          "date"    = type <- all(grepl(reg_date,file[[i]]))
        )
        # print(type)
        if(!type)
        {
          print("type not match")
          return (NULL)
        }
      }
      
      colnames(file) <- HEADER
      file$item      <- as.factor(file$item)
      file$amount    <- as.numeric(file$amount)
      file$unit      <- as.factor(file$unit)
      file$use_by    <- as.Date(file$use_by, DATE_FORMAT)
      
      
      print("fridge file loaded")
      return (file)
      
      
    },
    
    # function:     remove_zero
    # input   :     data: list; coloum: String 
    # return  :     List
    # description:  remove rows with 0 value.
    remove_zero = function(data, coloum ='amount')
    {
      return(subset(data, data[[coloum]]> 0))
    },
    
    
    # function:     remove_out_of_date
    # input   :     data: list; coloum: String 
    # return  :     List
    # description:  remove rows out of date
    remove_out_of_date = function(data,coloum, sysDate = Sys.Date())
    {
      data <- self$remove_zero(data)
      data <- subset(data, data[[coloum]]> sysDate)
      return (data)
    },
    
    # function:     search_dishes
    # input   :     recipes: list; ingredients: list 
    # return  :     dishes:List
    # description:  find dishes can be made
    search_dishes = function(recipes, ingredients)
    {
      # print("##############")
      dishes <- list()
      for( i in 1: length(recipes))
      {
        # print (i)
        recipe           <- recipes[[i]]
        ingredient_dates <- c()
        found            <- TRUE
        for( j in 1: length(recipe$ingredients))
        {
          ingredient_name   <- recipe$ingredients[[j]]$item
          ingredient_amount <- as.numeric(recipe$ingredients[[j]]$amount)
          
          
          ingre_fridge      <- subset(ingredients, item == ingredient_name)
          
          if((!ingredient_name %in% ingredients$item) ||
             (ingredient_amount > subset(ingredients, item == ingredient_name)$amount))
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
      return (dishes)
    },
    
    # function:     search_closest
    # input   :     dishes: dictionary of list of Date
    # return  :     dishes
    # description:  search_closest dishes from dishes can be made
    #   if two recipes have the ingredients with the same closest use-by date, 
    #   the program will compare the second closest use-by dates of these two recipes,
    #   and so forth
    #   until find the most closet use-by dish
    search_closest = function(dishes)
    {
      same     <- all(sapply(dishes, function(x) all(x == dishes[[1]])))
      min_date <- min(as.Date(sapply(dishes,min),ORIGIN))
      filter   <- as.vector(sapply(dishes, function(x) min_date %in% x))
      dishes   <- dishes[filter]
      
      while( length(dishes)>1 &&  !same)
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
      
      return (dishes)
    }
  )
)