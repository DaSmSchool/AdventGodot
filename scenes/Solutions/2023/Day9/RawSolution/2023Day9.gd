extends Solution


const intakeToOutput: Dictionary = {
	[Vector2i.RIGHT, "7"]: Vector2i.DOWN,
	[Vector2i.UP, "7"]: Vector2i.LEFT,
	[Vector2i.RIGHT, "J"]: Vector2i.UP,
	[Vector2i.DOWN, "J"]: Vector2i.LEFT,
	[Vector2i.LEFT, "L"]: Vector2i.UP,
	[Vector2i.DOWN, "L"]: Vector2i.RIGHT,
	[Vector2i.LEFT, "F"]: Vector2i.DOWN,
	[Vector2i.UP, "F"]: Vector2i.RIGHT,
	[Vector2i.LEFT, "-"]: Vector2i.LEFT,
	[Vector2i.RIGHT, "-"]: Vector2i.RIGHT,
	[Vector2i.UP, "|"]: Vector2i.UP,
	[Vector2i.DOWN, "|"]: Vector2i.DOWN,
}

const adjacents: Dictionary = {
	[Vector2i.RIGHT, "7"]: [[Vector2i.UP, Vector2i.RIGHT], []],
	[Vector2i.UP, "7"]: [[], [Vector2i.UP, Vector2i.RIGHT]],
	[Vector2i.RIGHT, "J"]: [[], [Vector2i.DOWN, Vector2i.RIGHT]],
	[Vector2i.DOWN, "J"]: [[Vector2i.DOWN, Vector2i.RIGHT], []],
	[Vector2i.LEFT, "L"]: [[Vector2i.DOWN, Vector2i.LEFT], []],
	[Vector2i.DOWN, "L"]: [[], [Vector2i.LEFT, Vector2i.DOWN]],
	[Vector2i.LEFT, "F"]: [[], [Vector2i.LEFT, Vector2i.UP]],
	[Vector2i.UP, "F"]: [[Vector2i.LEFT, Vector2i.UP], []],
	[Vector2i.LEFT, "-"]: [[Vector2i.DOWN], [Vector2i.UP]],
	[Vector2i.RIGHT, "-"]: [[Vector2i.UP], [Vector2i.DOWN]],
	[Vector2i.UP, "|"]: [[Vector2i.LEFT], [Vector2i.RIGHT]],
	[Vector2i.DOWN, "|"]: [[Vector2i.RIGHT], [Vector2i.LEFT]],
}

func get_start_position(grid: PackedStringArray) -> Vector2i:
	for rowInd: int in grid.size():
		var findS: int = grid[rowInd].find("S")
		if findS != -1:
			return Vector2i(findS, rowInd)
	return Vector2i()

func get_start_direction(grid: PackedStringArray, startPosition: Vector2i) -> Vector2i:
	for rowOff: int in range(-1, 2):
		for colOff: int in range(-1, 2):
			if (rowOff+colOff) % 2 == 0: continue
			var offDir: Vector2i = Vector2i(colOff, rowOff)
			var checkPosition: Vector2i = startPosition + offDir
			if Helper.valid_pos_at_packed_string_array(checkPosition.y, checkPosition.x, grid):
				var charAtCheckPosition: String = grid[checkPosition.y][checkPosition.x]
				if intakeToOutput.has([offDir, charAtCheckPosition]):
					return offDir
	return Vector2i()

func assemble_pipe_links(grid: PackedStringArray, pipeLinks: Dictionary[Vector2i, Dictionary], startPosition: Vector2i) -> void:
	var followDirection: Vector2i = get_start_direction(grid, startPosition)
	var currentPosition: Vector2i = startPosition
	var abosluteCheckPosition: Vector2i = currentPosition + followDirection
	
	while true:
		var currentTile: String = grid[currentPosition.y][currentPosition.x]
		var nextTile: String = grid[abosluteCheckPosition.y][abosluteCheckPosition.x]
		var pipeDict: Dictionary = {
			"pipeChar" : currentTile,
			"pipeLocation" : currentPosition,
			"linkedPipes" : []
		}
		if not pipeLinks.is_empty():
			pipeDict.linkedPipes.append(pipeLinks.keys().back())
			pipeLinks[pipeLinks.keys().back()].linkedPipes.append(currentPosition)
		pipeLinks[currentPosition] = pipeDict
		
		if nextTile != "S":
			currentPosition = abosluteCheckPosition
			followDirection = intakeToOutput[[followDirection, nextTile]]
			abosluteCheckPosition = currentPosition + followDirection
		else:
			break
	pipeLinks[currentPosition].linkedPipes.append(abosluteCheckPosition)
	pipeLinks[abosluteCheckPosition].linkedPipes.insert(0, currentPosition)
	
	
	

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var startPosition: Vector2i = Vector2i()
	
	var grid: PackedStringArray = input.split("\n", false)
	startPosition = get_start_position(grid)
	
	var pipeLinks: Dictionary[Vector2i, Dictionary] = {}
	
	assemble_pipe_links(grid, pipeLinks, startPosition)
	
	#for pipeTile: Vector2i in pipeLinks.keys():
		#var pipeDict: Dictionary = pipeLinks[pipeTile]
		#print_log(pipeTile)
		#print_log(pipeDict.linkedPipes)
		#print_log()
	
	solution = pipeLinks.size()/2
	
	return solution

func print_map(grid: PackedStringArray, pipeLinks: Dictionary[Vector2i, Dictionary]) -> void:
	var printAssemble: String = ""
	for rowInd: int in grid.size():
		var printRow: String = ""
		for colInd: int in grid[rowInd].length():
			var gridChar: String = grid[rowInd][colInd]
			var absoluteGridLocation: Vector2i = Vector2i(colInd, rowInd)
			if gridChar == "S":
				printRow += "[color=green]" + gridChar + "[/color]"
			elif pipeLinks.has(absoluteGridLocation):
				printRow += "[color=orange]" + gridChar + "[/color]"
			else:
				printRow += gridChar
			
		printAssemble += printRow + "\n"
	
	print_rich(printAssemble)

func print_map_p2(grid: PackedStringArray, pipeLinks: Dictionary[Vector2i, Dictionary], borderedTiles: Array[Dictionary]) -> void:
	var printAssemble: String = ""
	for rowInd: int in grid.size():
		var printRow: String = ""
		for colInd: int in grid[rowInd].length():
			var gridChar: String = grid[rowInd][colInd]
			var absoluteGridLocation: Vector2i = Vector2i(colInd, rowInd)
			if gridChar == "S":
				printRow += "[color=green]" + gridChar + "[/color]"
			elif pipeLinks.has(absoluteGridLocation) and borderedTiles[1].has(absoluteGridLocation):
				printRow += "[color=#800000]" + gridChar + "[/color]"
			elif pipeLinks.has(absoluteGridLocation):
				printRow += "[color=orange]" + gridChar + "[/color]"
			elif borderedTiles[0].has(absoluteGridLocation) and borderedTiles[1].has(absoluteGridLocation):
				printRow += "[color=purple]" + gridChar + "[/color]"
			elif borderedTiles[0].has(absoluteGridLocation):
				printRow += "[color=red]" + gridChar + "[/color]"
			elif borderedTiles[1].has(absoluteGridLocation):
				printRow += "[color=blue]" + gridChar + "[/color]"
			else:
				printRow += gridChar
			
		printAssemble += printRow + "\n"
	
	print_rich(printAssemble)

func add_surrounding_border(pipeLinks: Dictionary[Vector2i, Dictionary], borderedTiles: Array[Dictionary]) -> void:
	for pipePos: Vector2i in pipeLinks:
		var pipeInfo: Dictionary = pipeLinks[pipePos]
		if pipeInfo.pipeChar == "S": continue
		var pipeDirection: Vector2i = pipePos - pipeInfo.linkedPipes[0]
		var borderPositions: Array = adjacents[[pipeDirection, pipeInfo.pipeChar]]
		for groupInd: int in borderedTiles.size():
			for adjacent: Vector2i in borderPositions[groupInd]:
				var placePosition: Vector2i = adjacent+pipePos
				if not pipeLinks.has(placePosition):
					borderedTiles[groupInd][placePosition] = true

func expand_and_is_inner(borderedTiles: Dictionary, pipeLinks: Dictionary[Vector2i, Dictionary], grid: PackedStringArray) -> bool:
	var passed: bool = true
	var borderingTilesBuffer: Array = borderedTiles.keys()
	var newTiles: Array = []
	while borderingTilesBuffer.size() != 0:
		for tilePos: Vector2i in borderingTilesBuffer:
			for rowOff: int in range(-1, 2):
				for colOff: int in range(-1, 2):
					if (rowOff+colOff) % 2 == 0: continue
					var checkPos: Vector2i = Vector2i(tilePos.x+colOff, tilePos.y+rowOff)
					if not Helper.valid_pos_at_packed_string_array(checkPos.y, checkPos.x, grid): 
						passed = false
					if not pipeLinks.has(checkPos) and not borderedTiles.has(checkPos):
						newTiles.append(checkPos)
						borderedTiles[checkPos] = true
					borderingTilesBuffer.erase(checkPos)
		borderingTilesBuffer = newTiles
		newTiles = []
	return passed

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var startPosition: Vector2i = Vector2i()
	
	var grid: PackedStringArray = input.split("\n", false)
	startPosition = get_start_position(grid)
	
	var pipeLinks: Dictionary[Vector2i, Dictionary] = {}
	
	assemble_pipe_links(grid, pipeLinks, startPosition)
	
	var borderedTiles: Array[Dictionary] = [{}, {}]
	
	add_surrounding_border(pipeLinks, borderedTiles)
	
	print_map_p2(grid, pipeLinks, borderedTiles)
	var isInner: bool = expand_and_is_inner(borderedTiles[1], pipeLinks, grid)
	if not isInner:
		isInner = expand_and_is_inner(borderedTiles[0], pipeLinks, grid)
		solution = borderedTiles[0].size()
	else:
		solution = borderedTiles[1].size()
	print(borderedTiles[0].size(), borderedTiles[1].size())
	print_map_p2(grid, pipeLinks, borderedTiles)
	
	# ???
	return solution+1
