extends Solution

func parse_ranges(rawValidRanges: String) -> Array:
	var rangeArray: Array = []
	var rawSplit: PackedStringArray = rawValidRanges.split("\n")
	for rawRange: String in rawSplit:
		var rangeSplit: PackedStringArray = rawRange.split("-", false)
		rangeArray.append([rangeSplit[0].to_int(), rangeSplit[1].to_int()])
	return rangeArray

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var rawValidRanges: String = inputSplit[0]
	var rawTestIngredients: String = inputSplit[1]
	
	var rangeArray: Array = parse_ranges(rawValidRanges)
	var ingredientArray: Array = Array(rawTestIngredients.split("\n", false)).map(func(s): return int(s))
	
	for ingredientId: int in ingredientArray:
		for rangeArr: Array in rangeArray:
			if rangeArr[0] <= ingredientId and ingredientId <= rangeArr[1]:
				solution += 1
				break
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	
	
	return solution
