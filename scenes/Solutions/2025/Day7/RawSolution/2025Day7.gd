extends Solution

var splitsMet: Dictionary = {}
var splitsMetP2: Dictionary = {}
var visitedSpaces: Dictionary = {}
var visitedSpacesP2: Dictionary = {}

func make_tachyon_splits(startingPosition: Vector2i, inputSplit: PackedStringArray, tachyonStartingPositions: Dictionary[Vector2i, bool]) -> void:
	if startingPosition == Vector2i(7, 4):
		pass
	for rowInd: int in range(startingPosition.y, inputSplit.size()):
		var focusChar: String = inputSplit[rowInd][startingPosition.x]
		visitedSpaces[Vector2i(startingPosition.x, rowInd)] = true
		if focusChar == "^":
			splitsMet[Vector2i(startingPosition.x, rowInd)] = true
			var newPosLeft: Vector2i = Vector2i(startingPosition.x-1, rowInd)
			var newPosRight: Vector2i = Vector2i(startingPosition.x+1, rowInd)
			if not tachyonStartingPositions.has(newPosLeft):
				tachyonStartingPositions[newPosLeft] = true
				make_tachyon_splits(newPosLeft, inputSplit, tachyonStartingPositions)
			if not tachyonStartingPositions.has(newPosRight):
				tachyonStartingPositions[newPosRight] = true
				make_tachyon_splits(newPosRight, inputSplit, tachyonStartingPositions)
			break

func make_tachyon_splits_p2(startingPosition: Vector2i, inputSplit: PackedStringArray, tachyonStartingPositions: Dictionary[Vector2i, bool]) -> int:
	var outcomes: int = 1
	for rowInd: int in range(startingPosition.y, inputSplit.size()):
		var focusChar: String = inputSplit[rowInd][startingPosition.x]
		var position: Vector2i = Vector2i(startingPosition.x, rowInd)
		visitedSpacesP2[position] = true
		if focusChar == "^":
			if splitsMetP2.has(position):
				outcomes += splitsMetP2[position]-2
				break
			var newPosLeft: Vector2i = Vector2i(startingPosition.x-1, rowInd)
			var newPosRight: Vector2i = Vector2i(startingPosition.x+1, rowInd)
			var newOutcome: int = 0
			newOutcome += make_tachyon_splits_p2(newPosLeft, inputSplit, tachyonStartingPositions)
			newOutcome += make_tachyon_splits_p2(newPosRight, inputSplit, tachyonStartingPositions)
			outcomes = newOutcome
			splitsMetP2[position] = outcomes
	return outcomes

func print_with_tachyon_paths(grid: PackedStringArray) -> void:
	var gridAssemble: String = ""
	for rowInd: int in grid.size():
		var rowAssemble: String = ""
		for colInd: int in grid[rowInd].length():
			var focusChar: String = grid[rowInd][colInd]
			var position: Vector2i = Vector2i(colInd, rowInd)
			if splitsMet.has(position):
				rowAssemble += "[color=orange]" + focusChar + "[/color]"
			elif visitedSpaces.has(position):
				rowAssemble += "[color=green]|[/color]"
			else:
				rowAssemble += focusChar
		gridAssemble += rowAssemble + "\n"
	print_rich(gridAssemble)

func print_with_tachyon_paths_p2(grid: PackedStringArray) -> void:
	var gridAssemble: String = ""
	for rowInd: int in grid.size():
		var rowAssemble: String = ""
		for colInd: int in grid[rowInd].length():
			var focusChar: String = grid[rowInd][colInd]
			var position: Vector2i = Vector2i(colInd, rowInd)
			if splitsMetP2.has(position):
				rowAssemble += "[color=orange]" + str(splitsMetP2[position]) + "[/color]"
			elif visitedSpaces.has(position):
				rowAssemble += "[color=green]|[/color]"
			else:
				rowAssemble += focusChar
		gridAssemble += rowAssemble + "\n"
	print_rich(gridAssemble)

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var startingPosition: Vector2i = Vector2i(inputSplit[0].find("S"), 0)
	
	var tachyonStartingPositions: Dictionary[Vector2i, bool] = {startingPosition:true}
	
	make_tachyon_splits(startingPosition, inputSplit, tachyonStartingPositions)
	
	print_with_tachyon_paths(inputSplit)
	
	solution = splitsMet.size()
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var startingPosition: Vector2i = Vector2i(inputSplit[0].find("S"), 0)
	
	var tachyonStartingPositions: Dictionary[Vector2i, bool] = {startingPosition:true}
	
	solution = make_tachyon_splits_p2(startingPosition, inputSplit, tachyonStartingPositions)
	
	# this is the split directly below starting point
	#solution = splitsMetP2[Vector2i(startingPosition.x, 2)]
	
	print_with_tachyon_paths_p2(inputSplit)
	
	return solution
