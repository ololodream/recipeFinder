import json
import random
import string
import time
import csv
import os

# amount valid number > 0
# item, unit valid: string
# name valid: string

recipe_keys = ['name', 'ingredients']
ingredients_keys = ['item', 'amount', 'unit']
unit_catagories = ['slices', 'grams']
start_date = (1990, 1, 1, 0, 0, 0, 0, 0, 0)
end_date = (2100, 12, 31, 23, 59, 59, 0, 0, 0)

def mkdir(path):
    folder = os.path.exists(path)
    if not folder:
        os.makedirs(path)

def createIngredient(item, amount, unit):
    ingredient = {}
    ingredient["item"] = item
    ingredient["amount"] = amount
    ingredient["unit"] = unit
    return ingredient

def createIngredients(amount_legal=True):
    ingredients = []
    size = random.randint(1,5)
    for i in range(size):
        ingredients.append(createIngredient(string_random_generator(),digit_random_generator(amount_legal),string_random_generator()))
        #print(ingredients)
    return ingredients

def createRecipe(name, ingredients):
    recipe = {}
    recipe["name"] = name
    recipe["ingredients"] = ingredients
    return recipe

def createRecipes(amount_legal):
    recipes = []
    for i in range(random.randint(1,5)):
        recipes.append(createRecipe(string_random_generator(), createIngredients(amount_legal)))
    return recipes

def string_random_generator(chars=string.ascii_letters+string.digits):
    size = random.randint(1,15)
    return "".join(random.choice(chars) for _ in range(size))

def digit_random_generator(min=0, max=2**16-1,legal=True):
    if(legal):
        return random.randint(min, max)
    else:
        return random.randint(-2**16,0)

def date_random_generator(legal=True):
    if(legal):
        start = time.mktime(start_date)
        end = time.mktime(end_date)
        t = random.randint(start, end)
        date_touple = time.localtime(t)
        date = time.strftime("%d/%m/%Y", date_touple)
        return date
    else:
        return string_random_generator()

def json_generator(size,amount_legal):
    mkdir(os.path.abspath('.')+"/files")
    for i in range(size):
        recipe = createRecipes(amount_legal)
        if(amount_legal):
            filepath = os.path.abspath('.')+"/files/valid_recipe"+str(i)+".json"
            with open(filepath,"w") as jsonf:
                json.dump(recipe,jsonf)
                print("valid json files created!")
        else:
            filepath = os.path.abspath('.')+"/files/invalid_recipe" + str(i) + ".json"
            with open(filepath,"w") as jsonf:
                json.dump(recipe,jsonf)
                print("invalid json files created!")


def csv_generator(file_numbers,amount_legal,date_legal):
    mkdir(os.path.abspath('.') + "/files")
    for i in range(file_numbers):
        if(amount_legal == True and date_legal == True):
            filepath = os.path.abspath('.')+"/files/valid fridge" + str(i) + ".csv"
            csv_dumper(filepath)
            print("valid csv files created!")
        else:
            filepath = os.path.abspath('.')+"/files/invalid fridge"+ str(i) + ".csv"
            csv_dumper(filepath)
            print("invalid csv files created!")

'''
for i in range(1,10):
    recipe = createRecipe(string_random_generator(),createIngredients())
    print(recipe)
    #print(string_random_generator())
    #print(digit_random_generator(legal=False))
    #print(date_random_generator())
'''

def csv_dumper(filename):
    with open(filename, "w") as csvfile:
        writer = csv.writer(csvfile)
        for i in range(random.randint(1,5)):
            writer.writerow([string_random_generator(),digit_random_generator(),string_random_generator(),date_random_generator()])

json_generator(5,True)
json_generator(5,False)
csv_generator(5,True, True)
csv_generator(5,True, False)
csv_generator(5,False, True)
csv_generator(5,False, False)
