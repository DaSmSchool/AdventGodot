extends Solution

func get_ingredients_list(rawFood: String) -> PackedStringArray:
	var rawIngredientsList: String = rawFood.split(" (contains ")[0]
	return rawIngredientsList.split(" ")

func get_allergens_list(rawFood: String) -> PackedStringArray:
	var rawAllergensList: String = rawFood.split(" (contains ")[1]
	rawAllergensList = rawAllergensList.substr(0, rawAllergensList.length()-1)
	return rawAllergensList.split(", ")

func organize_foods_to_allergens(rawFoodList: PackedStringArray, allergensToKnownFoods: Dictionary, rawIngredientList: Array[PackedStringArray]) -> void:
	for rawFood: String in rawFoodList:
		var ingredientsList: PackedStringArray = get_ingredients_list(rawFood)
		rawIngredientList.append(ingredientsList)
		var allergensList: PackedStringArray = get_allergens_list(rawFood)
		
		for allergen: String in allergensList:
			if not allergensToKnownFoods.has(allergen):
				allergensToKnownFoods[allergen] = []
			allergensToKnownFoods[allergen].append(ingredientsList)
				

func print_ingredient_dict(dict: Dictionary) -> void:
	for key in dict:
		print(key + " : " + str(dict[key]))

func narrow_ingredients_per_food(allergenPossibleIngredientDict: Dictionary) -> void:
	for allergen: String in allergenPossibleIngredientDict:
		var possibleArray: Array = allergenPossibleIngredientDict[allergen][0]
		for ingredientArray: Array in allergenPossibleIngredientDict[allergen]:
			var commonArray: Array = []
			for ingredient: String in ingredientArray:
				if possibleArray.has(ingredient):
					commonArray.append(ingredient)
			possibleArray = commonArray
		allergenPossibleIngredientDict[allergen] = possibleArray

func narrow_ingredients_across_foods(allergenPossibleIngredientDict: Dictionary) -> Dictionary[String, String]:
	var manipAllergenDict: Dictionary = allergenPossibleIngredientDict.duplicate(true)
	var objectiveAllergenDict: Dictionary[String, String] = {}
	
	while manipAllergenDict.size() != 0:
		var focusSingleIngAllergen: String = ""
		for key: String in manipAllergenDict:
			if manipAllergenDict[key].size() == 1:
				focusSingleIngAllergen = key
				break
		assert(focusSingleIngAllergen != "", "single string not found")
		for key: String in manipAllergenDict:
			if key != focusSingleIngAllergen:
				manipAllergenDict[key].erase(manipAllergenDict[focusSingleIngAllergen][0])
		
		objectiveAllergenDict[focusSingleIngAllergen] = manipAllergenDict[focusSingleIngAllergen][0]
		manipAllergenDict.erase(focusSingleIngAllergen)
	
	return objectiveAllergenDict

func solve1(input: String) -> int:
	var solution: int = 0
	
	var rawFoodList: PackedStringArray = input.split("\n", false)
	var allergensToKnownFoods: Dictionary[String, Array] = {}
	var rawIngredientList: Array[PackedStringArray] = []
	
	organize_foods_to_allergens(rawFoodList, allergensToKnownFoods, rawIngredientList)
	
	narrow_ingredients_per_food(allergensToKnownFoods)
	
	
	var narrowedAllergenLookup: Dictionary[String, String] = narrow_ingredients_across_foods(allergensToKnownFoods)
	
	var allergenedIngredients: PackedStringArray = []
	for allergen: String in narrowedAllergenLookup:
		allergenedIngredients.append(narrowedAllergenLookup[allergen])
	
	for ingredientList: PackedStringArray in rawIngredientList:
		for ingredient: String in ingredientList:
			if not allergenedIngredients.has(ingredient):
				solution += 1
	
	return solution


func solve2(input: String) -> String:
	var rawFoodList: PackedStringArray = input.split("\n", false)
	var allergensToKnownFoods: Dictionary[String, Array] = {}
	var rawIngredientList: Array[PackedStringArray] = []
	
	organize_foods_to_allergens(rawFoodList, allergensToKnownFoods, rawIngredientList)
	var unnarrowedAllergenLookup: Dictionary[String, Array] = allergensToKnownFoods.duplicate(true)
	
	narrow_ingredients_per_food(allergensToKnownFoods)
	
	var narrowedAllergenLookup: Dictionary[String, String] = narrow_ingredients_across_foods(allergensToKnownFoods)
	
	var allergenedIngredients: String = ""
	
	var allergenList: Array = narrowedAllergenLookup.keys()
	allergenList.sort()
	
	for allergen: String in allergenList:
		allergenedIngredients += narrowedAllergenLookup[allergen]
		allergenedIngredients += ","
	allergenedIngredients = allergenedIngredients.substr(0, allergenedIngredients.length()-1)
	
	return allergenedIngredients
