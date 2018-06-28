"# recipeFinder" 

https://recipefinder.shinyapps.io/recipefinder/


# requirements
Given a list of items in the fridge (presented as a csv list), and a collection of recipes (a collection of JSON formatted recipes), produce a recommendation for what to cook tonight.

Program should be written to take two inputs; fridge csv list, and the json recipe data. You can write it as a web page which takes input through a form. The only rule is that it must run and return a valid result using the provided input data. 

Input: fridge csv Format: item, amount, unit, use-by ;

Item (string) = the name of the ingredient – e.g. egg)

Amount (int) = the amount 

Unit (enum) = the unit of measure, values; of (for individual items; eggs, bananas etc) grams ml (milliliters) slices

Use-By (date) = the use by date of the ingredient (dd/mm/yy)

e.g.
bread,10,slices,25/12/2014 cheese,10,slices,25/12/2014 butter,250,grams,25/12/2014 peanut butter,250,grams,2/12/2014 mixed salad,150,grams,26/12/2013
recipes json Array of recipes with format specified as below
name : String ingredients[] item : String amount : int unit : enum

e.g. [
{
"name": "grilled cheese on toast", "ingredients": [ { "item":"bread", "amount":"2", "unit":"slices"}, { "item":"cheese", "amount":"2", "unit":"slices"}
]
} , {
"name": "salad sandwich", "ingredients": [
{ "item":"bread", "amount":"2", "unit":"slices"}, { "item":"mixed salad", "amount":"100", "unit":"grams"}
] }
]
# Notes
An ingredient that is past its use-by date cannot be used for cooking. If more than one recipe is found, then preference should be given to the recipe with the closest use-by item If no recipe is found, the program should return “Order Takeout” Program should be all-inclusive and a run script (if required) included Please include evidence of unit testing
Using the sample input above, the program should return "Salad Sandwich".
