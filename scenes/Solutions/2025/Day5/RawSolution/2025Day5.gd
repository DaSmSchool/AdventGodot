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
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var rawValidRanges: String = inputSplit[0]
	
	var rangeArray: Array = parse_ranges(rawValidRanges)
	
	var summedRangeArray: Array = [rangeArray[0]]
	
	for rangeArrInd: int in range(1, rangeArray.size()):
		var rangeArr: Array = rangeArray[rangeArrInd]
		
		
		for focusRange: Array in summedRangeArray.duplicate():
			if focusRange[0] <= rangeArr[0] and rangeArr[0] <= focusRange[1]:
				rangeArr[0] = focusRange[0]
				rangeArr[1] = max(rangeArr[1], focusRange[1])
				summedRangeArray.erase(focusRange)
			if focusRange[0] <= rangeArr[1] and rangeArr[1] <= focusRange[1]:
				rangeArr[1] = focusRange[1]
				rangeArr[0] = min(rangeArr[0], focusRange[0])
				summedRangeArray.erase(focusRange)
			if rangeArr[0] <= focusRange[0] and focusRange[1] <= rangeArr[1]:
				summedRangeArray.erase(focusRange)

		summedRangeArray.append(rangeArr)
	
	for rangeArr: Array in summedRangeArray:
		solution += (rangeArr[1]-rangeArr[0])+1
	
	return solution
