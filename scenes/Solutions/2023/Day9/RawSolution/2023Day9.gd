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

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
