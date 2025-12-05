extends Solution

func find_nth_occurrence(mainString: String, subString: String, n: int) -> int:
	assert(n > 0, "nth occurence must be positive")
	
	var searchInd: int = 0
	var timesFound: int = 0
	while timesFound < n and searchInd < mainString.length():
		if mainString.substr(searchInd, subString.length()) == subString:
			var intQualif: bool = subString.is_valid_int()
			var checkInd1: int = searchInd+subString.length()
			var checkInd2: int = searchInd-1
			var checkChar1: String = "."
			var checkChar2: String = "."
			if checkInd1 < mainString.length(): 
				checkChar1 = mainString[searchInd+subString.length()]
			if checkInd2 > 0:
				checkChar2 = mainString[searchInd-1]
			
			if not intQualif:
				timesFound += 1
			elif not (checkChar1.is_valid_int() or checkChar2.is_valid_int()):
				timesFound += 1
				
		searchInd += 1
	searchInd -= 1
	assert(timesFound == n, "N too high, instance not found")
	return searchInd

func get_emptyless_row(row: String) -> Array:
	var emptylessRow: Array = []
	var rowInd: int = 0
	while rowInd < row.length():
		var rowChar: String = row[rowInd]
		if rowChar == ".": 
			pass
		elif rowChar.is_valid_int():
			var assembleNumber: String = ""
			while rowInd < row.length() and row[rowInd].is_valid_int():
				assembleNumber += row[rowInd]
				rowInd += 1
			rowInd -= 1
			emptylessRow.append(assembleNumber)
		else:
			emptylessRow.append(rowChar)
		rowInd += 1
	
	return emptylessRow

func parse_input(input: String, positionsToNumbers: Dictionary[Vector2i, Array], symbolPositions: Array):
	var inputSplit: PackedStringArray = input.split("\n", false)
	for rowInd: int in inputSplit.size():
		
		var rowElementOccurences: Dictionary[String, int] = {}
		var row: String = inputSplit[rowInd]
		var emptylessRow: PackedStringArray = get_emptyless_row(row)
		#print(row)
		#print(emptylessRow)
		#print()

		for elementInd: int in emptylessRow.size():
			var element: String = emptylessRow[elementInd]
			
			if not rowElementOccurences.has(element):
				rowElementOccurences[element] = 0
			var elementOccurence: int = rowElementOccurences[element]
			rowElementOccurences[element] += 1
			
			var elementRawInd: int = find_nth_occurrence(row, element, elementOccurence+1)
			if element.is_valid_int():
				var elementPosition: Vector2i = Vector2i(elementRawInd, rowInd)
				for charInd: int in element.length():
					var numSpot: Vector2i = Vector2i(elementRawInd+charInd, rowInd)
					positionsToNumbers[numSpot] = [element.to_int(), elementPosition]
			else:
				symbolPositions.append([element, Vector2i(elementRawInd, rowInd)])

func score_symbol_surroundings(symbolSet: Array, positionsToNumbers: Dictionary[Vector2i, Array], scoredNumbers: Array) -> int:
	#print_log(symbolSet)
	var addResult: int = 0
	var symbolPosition: Vector2i = symbolSet[1]
	for rowOff: int in range(-1, 2):
		for colOff: int in range(-1, 2):
			if rowOff | colOff == 0: continue
			var focusPosition: Vector2i = Vector2i(symbolPosition.x+colOff, symbolPosition.y+rowOff)
			if positionsToNumbers.has(focusPosition) and not scoredNumbers.has(positionsToNumbers[focusPosition]):
				var scored: Array = positionsToNumbers[focusPosition]
				scoredNumbers.append(scored)
				addResult += scored[0]
				#print_log(scored)
	#print_log()
	return addResult

func score_symbol_surroundings_p2(symbolSet: Array, positionsToNumbers: Dictionary[Vector2i, Array]) -> int:
	if symbolSet[0] != "*": return 0
	var symbolPosition: Vector2i = symbolSet[1]
	
	var adjacentNumbers: Array = []
	for rowOff: int in range(-1, 2):
		for colOff: int in range(-1, 2):
			if rowOff | colOff == 0: continue
			var focusPosition: Vector2i = Vector2i(symbolPosition.x+colOff, symbolPosition.y+rowOff)
			if positionsToNumbers.has(focusPosition) and not adjacentNumbers.has(positionsToNumbers[focusPosition]):
				var scored: Array = positionsToNumbers[focusPosition]
				adjacentNumbers.append(scored)
				#print_log(scored)
	if adjacentNumbers.size() == 2:
		return adjacentNumbers[0][0] * adjacentNumbers[1][0]
	else:
		return 0

func print_space_colors(input: String, positionsToNumbers: Dictionary[Vector2i, Array], symbolPositions: Array, scoredNumbers: Array) -> void:
	var inputSplit: PackedStringArray = input.split("\n", false)
	var assembleText: String = ""
	for rowInd: int in inputSplit.size():
		var rowAssemble: String = ""
		for colInd: int in inputSplit[rowInd].length():
			var focusPosition: Vector2i = Vector2i(colInd, rowInd)
			var focusChar: String = inputSplit[rowInd][colInd]
			if positionsToNumbers.has(focusPosition) and scoredNumbers.has(positionsToNumbers[focusPosition]):
				rowAssemble += "[color=green]" + focusChar + "[/color]"
			elif focusChar.is_valid_int():
				rowAssemble += "[color=red]" + focusChar + "[/color]"
			elif symbolPositions.has([inputSplit[rowInd][colInd], focusPosition]):
				rowAssemble += "[color=orange]" + focusChar + "[/color]"
			else:
				rowAssemble += " "
		assembleText += rowAssemble + "\n"
	print_rich(assembleText)

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var positionsToNumbers: Dictionary[Vector2i, Array] = {}
	var symbolPositions: Array = []
	parse_input(input, positionsToNumbers, symbolPositions)
	
	var scoredNumbers: Array = []
	for symbolSet: Array in symbolPositions:
		solution += score_symbol_surroundings(symbolSet, positionsToNumbers, scoredNumbers)
	
	#print_space_colors(input, positionsToNumbers, symbolPositions, scoredNumbers)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var positionsToNumbers: Dictionary[Vector2i, Array] = {}
	var symbolPositions: Array = []
	parse_input(input, positionsToNumbers, symbolPositions)
	
	for symbolSet: Array in symbolPositions:
		solution += score_symbol_surroundings_p2(symbolSet, positionsToNumbers)
	
	#print_space_colors(input, positionsToNumbers, symbolPositions, scoredNumbers)
	
	return solution
