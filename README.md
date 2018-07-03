"# recipeFinder" 
# Introduction:

This is a web application. Given a list of items in the fridge (presented as a csv list), and a collection of recipes (a collection of JSON formatted recipes), produce a recommendation for what to cook tonight.
 
If more than one recipe is found, then preference should be given to the recipe with the closest use-by item If no recipe is found, the program should return “Order Takeout”. Using the sample input(recipe.json and fridge.csv) , the program should return "Salad Sandwich".

Note: In this program, if two recipes have the ingredients with the same closest use-by date, the program will compare the second closest use-by dates of these two recipes. See branch 12.

1. Click the link below(make sure you are using Windows)

https://recipefinder.shinyapps.io/recipefinder4/

2. Upload your recipe (.json) and fridge (.csv) files, you can customize them or simply choose them from folder "file2"

3. The result will show the best choice of what to cook

# file structure

server: server.R

layout: ui.R 

class： RecipeFinder.R

static data： global.R

# testing



 1. Coverage Testing
 
 script that automatically executes testing: test_script.R
 
branch coverage testing cases: files2

test result:  test_result.xlsx

In this project, I apply branch-coverage-based testing method and control-flow graphs to cover the program with test cases. Every possible alternative in a branch of the program is executed at least once by that test cases, and each test case represents one branch or path exists in the program. Furthermore, all the actual outputs is the same as expected outputs under this test.

  2. Penetration Testing
 
fuzz testing tool that generates test cases: RecipeFinderFuzzer.py
 
penetration testing cases:files

result:  ptest_result.xlsx

To test the security of the program, I designed a fuzz testing tool to detect program behaviors such as exceptions, segmentation faults and memory leaks. The fuzzing tool is generation-based that preserves the structure and grammar of .json and .csv files, and randomly modifies parts of value within that structures. For example, some of the fuzzer files only replace the value of the key "amount", making it less than zero. Through analysing the testing results, the program passes the penetration test and could be proved to be secure.
