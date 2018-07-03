library("rjson")
source("RecipeFinder.R") 
library(xlsx)
results<- c()
for( file_index in c(1:12))
{
  file_json_path = paste0(getwd(),"/files2/branch_",file_index,".json")
  file_csv_path = paste0(getwd(),"/files2/branch_",file_index,".csv")
  
  if(is.null(file_csv_path))
  {
    next
  }
  if(is.null(file_json_path))
  {
    next
  }
  rf <- RecipeFinder$new()
  
  #check csv     
  ingredients <- rf$valid_csv(
    file_path = file_csv_path,
    headers   =  NULL, 
    types     =  c("factor","numeric","factor","date"))
  
  #check json
  recipes   <- rf$valid_json(file_json_path)
  
  #if any file is empty return 0
  if(length(ingredients)==0 || length(recipes)==0 || any(ingredients$amount < 0))
  {
    result        <-  Str_Err
    print(result)
    results <- c(results,result)
    next
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
    print(result)
    results <- c(results,result)
    next
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
    print(result)
    results <- c(results,result)
    next
  }
  
  # more than 1 dishes can be made, then search closest dish
  dishes        <- rf$search_closest(dishes)
  
  #render result
  result        <- names(dishes)[1]
  results <- c(results,result)

}
df <- data.frame(branch = c(1:12), results= results)

write.xlsx(df, paste0(getwd(),"/test_result.xlsx"),row.names = FALSE)