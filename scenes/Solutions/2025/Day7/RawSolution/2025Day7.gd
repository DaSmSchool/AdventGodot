extends Solution

var splitsP1: int = 0
var splitsMet: Dictionary = {}
var visitedSpaces: Dictionary = {}

func make_tachyon_splits(startingPosition: Vector2i, inputSplit: PackedStringArray, tachyonStartingPositions: Dictionary[Vector2i, bool]) -> void:
	if startingPosition == Vector2i(7, 4):
		pass
	for rowInd: int in range(startingPosition.y, inputSplit.size()):
		var focusChar: String = inputSplit[rowInd][startingPosition.x]
		visitedSpaces[Vector2i(startingPosition.x, rowInd)] = true
		if focusChar == "^":
			splitsP1 += 1
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
	
	return solution
