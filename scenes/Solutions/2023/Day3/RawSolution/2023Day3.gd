extends Solution

func find_nth_occurrence(mainString: String, subString: String, n: int) -> int:
	assert(n > 0, "nth occurence must me positive")
	var currentIndex: int = -1
	for i: int in range(n):
		currentIndex = mainString.find(subString, currentIndex + 1)
		if currentIndex == -1:
			return -1  # Substring not found or nth occurrence not reached
	return currentIndex

func parse_input(input: String, positionsToNumbers: Dictionary[Vector2i, Array], symbolPositions: Array):
	var inputSplit: PackedStringArray = input.split("\n", false)
	for rowInd: int in inputSplit.size():
		var rowElementOccurences: Dictionary[String, int] = {}
		var row: String = inputSplit[rowInd]
		var emptylessRow: PackedStringArray = row.split(".", false)
		for elementInd: int in emptylessRow.size():
			var element: String = emptylessRow[elementInd]
			if not rowElementOccurences.has(element):
				rowElementOccurences[element] = 0
			var elementOccurence: int = rowElementOccurences[element]
			rowElementOccurences[element] += 1
			var elementRawInd: int = find_nth_occurrence(row, element, elementOccurence)
			if element.is_valid_int():
				var elementPosition: Vector2i = Vector2i(elementRawInd, rowInd)
				for charInd: int in element.length():
					positionsToNumbers[Vector2i(elementRawInd+charInd, rowInd)] = [element.to_int(), elementPosition]
			else:
				symbolPositions.append([element, elementRawInd])

func score_symbol_surroundings(symbolSet: Array, positionsToNumbers: Dictionary[Vector2i, Array], scoredNumbers: Array) -> int:
	var symbolPosition: Vector2i = symbolSet[1]
	for rowOff: int in range(-1, 2):
		for colOff: int in range(-1, 2):
			if rowOff | colOff == 0: continue
			
			var focusPosition: Vector2i = Vector2i(symbolPosition.x+colOff, symbolPosition.y+rowOff)

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var positionsToNumbers: Dictionary[Vector2i, Array] = {}
	var symbolPositions: Array = []
	parse_input(input, positionsToNumbers, symbolPositions)
	
	var scoredNumbers: Array = []
	for symbolSet: Array in symbolPositions:
		solution += score_symbol_surroundings(symbolSet, positionsToNumbers, scoredNumbers)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
