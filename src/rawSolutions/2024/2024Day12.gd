extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_group(yPos: int, xPos: int, grid: Array) -> Array:
	var returnGrid: Array = []
	var selfSpot: Vector2i  = Vector2i(xPos, yPos)
	var grabbedGrid: Array[Vector2i] = [selfSpot]
	returnGrid.append(selfSpot)
	
	while grabbedGrid.size() != 0:
		var focusPoints: Array[Vector2i] = grabbedGrid.duplicate(true)
		grabbedGrid = []
		for point: Vector2i in focusPoints:
			for yInd: int in range(-1, 2, 1):
				for xInd: int in range(-1, 2, 1):
					if abs(yInd) != abs(xInd) and Helper.valid_pos_at_grid(point.y+yInd, point.x+xInd, grid):
						var focusPoint: Vector2i = Vector2i(point.x+xInd, point.y+yInd)
						if grid[point.y][point.x] == grid[point.y+yInd][point.x+xInd] and !returnGrid.has(focusPoint) and !grabbedGrid.has(focusPoint):
							grabbedGrid.append(Vector2i(point.x+xInd, point.y+yInd))

		returnGrid.append_array(grabbedGrid)
	
	return returnGrid

func solve1(input: String) -> int:
	var solution: int = 0
	
	var splitInput: PackedStringArray = input.split("\n")
	var grid: Array = []
	
	for line: String in splitInput:
		if line == "": continue
		grid.append(line.split(""))
	
	var groupsMade: Dictionary = {}
	
	var assignGroup: String = grid[0][0]
	groupsMade.get_or_add(assignGroup, [])
	groupsMade[assignGroup].append(get_group(0, 0, grid))
	
	# garden contstruction
	for lineInd: int in grid.size():
		for charInd: int in grid[0].size():
			var charAtGrid: String = grid[lineInd][charInd]
			if Helper.valid_pos_at_grid(lineInd, charInd-1, grid) and charAtGrid == grid[lineInd][charInd-1]:
				continue
			if charInd == 0 or (Helper.valid_pos_at_grid(lineInd, charInd, grid) and charAtGrid != grid[lineInd][charInd-1]):
				if !groupsMade.has(charAtGrid):
					groupsMade.get_or_add(charAtGrid, [])
					groupsMade[charAtGrid].append(get_group(lineInd, charInd, grid))
				else:
					var hasPosition: bool = false
					for arrayKey: String in groupsMade.keys():
						for array: Array in groupsMade[arrayKey]:
							if array.has(Vector2i(charInd, lineInd)):
								hasPosition = true
								break
						if hasPosition: break
					if hasPosition:
						pass
					else:
						groupsMade[charAtGrid].append(get_group(lineInd, charInd, grid))
	
	for key: String in groupsMade.keys():
		for garden: Array in groupsMade[key]:
			var gardenArea: int = 0
			var gardenPerimeter: int = 0
			for indGarden: Vector2i in garden:
				gardenArea += 1
				for yOff: int in range(-1, 2, 1):
					for xOff: int in range(-1, 2, 1):
						if abs(yOff) != abs(xOff):
							if !Helper.valid_pos_at_grid(indGarden.y+yOff, indGarden.x+xOff, grid):
								gardenPerimeter += 1
							else:
								if grid[indGarden.y][indGarden.x] != grid[indGarden.y+yOff][indGarden.x+xOff]:
									gardenPerimeter += 1
			solution += gardenArea * gardenPerimeter
			
	return solution

func make_isolated_grid(garden: Array, char: String) -> Array:
	var isolatedGrid: Array = []
	
	var rangeX: int = 0
	var rangeY: int = 0
	var minX: int = garden[0].x
	var maxX: int = garden[0].x
	var minY: int = garden[0].y
	var maxY: int = garden[0].y
	for point: Vector2i in garden:
		if point.x < minX: minX = point.x
		if point.x > maxX: maxX = point.x
		if point.y < minY: minY = point.y
		if point.y > maxY: maxY = point.y
	rangeX = maxX - minX
	rangeY = maxY - minY
	for yInd: int in rangeY+1:
		var isolatedRow: Array[String] = []
		for xInd: int in rangeX+1:
			if garden.has(Vector2i(minX+xInd, minY+yInd)):
				isolatedRow.append(char)
			else:
				isolatedRow.append(".")
		isolatedGrid.append(isolatedRow)
	
	return isolatedGrid

func solve2(input: String) -> int:
	var solution: int = 0
	
	var splitInput: PackedStringArray = input.split("\n")
	var grid: Array = []
	
	for line: String in splitInput:
		if line == "": continue
		grid.append(line.split(""))
	
	var groupsMade: Dictionary = {}
	
	var assignGroup: String = grid[0][0]
	groupsMade.get_or_add(assignGroup, [])
	groupsMade[assignGroup].append(get_group(0, 0, grid))
	
	# garden contstruction
	for lineInd: int in grid.size():
		for charInd: int in grid[0].size():
			var charAtGrid: String = grid[lineInd][charInd]
			if Helper.valid_pos_at_grid(lineInd, charInd-1, grid) and charAtGrid == grid[lineInd][charInd-1]:
				continue
			if charInd == 0 or (Helper.valid_pos_at_grid(lineInd, charInd, grid) and charAtGrid != grid[lineInd][charInd-1]):
				if !groupsMade.has(charAtGrid):
					groupsMade.get_or_add(charAtGrid, [])
					groupsMade[charAtGrid].append(get_group(lineInd, charInd, grid))
				else:
					var hasPosition: bool = false
					for arrayKey: String in groupsMade.keys():
						for array: Array in groupsMade[arrayKey]:
							if array.has(Vector2i(charInd, lineInd)):
								hasPosition = true
								break
						if hasPosition: break
					if hasPosition:
						pass
					else:
						groupsMade[charAtGrid].append(get_group(lineInd, charInd, grid))
	
	for key: String in groupsMade.keys():
		for garden: Array in groupsMade[key]:
			var gardenArea: int = 0
			var gardenSides: int = 0
			var isolatedGrid: Array = make_isolated_grid(garden, key)
			
			for row: Array in isolatedGrid:
				for col: String in row:
					if col == key: gardenArea += 1
			
			var sideCountingTop: bool = false
			var sideCountingBottom: bool = false
			
			# top/bottom checks
			for lineInd: int in isolatedGrid.size():
				sideCountingBottom = false
				sideCountingTop = false
				for colInd: int in isolatedGrid[lineInd].size():
					if isolatedGrid[lineInd][colInd] == key:
						# check above focus tile
						if !Helper.valid_pos_at_grid(lineInd-1, colInd, isolatedGrid) or isolatedGrid[lineInd-1][colInd] != key:
							if sideCountingTop == false:
								gardenSides += 1
							sideCountingTop = true
						else:
							sideCountingTop = false
						
						# check below focus tile
						if !Helper.valid_pos_at_grid(lineInd+1, colInd, isolatedGrid) or isolatedGrid[lineInd+1][colInd] != key:
							if sideCountingBottom == false:
								gardenSides += 1
							sideCountingBottom = true
						else:
							sideCountingBottom = false
					else:
						sideCountingTop = false
						sideCountingBottom = false
			
			var sideCountingLeft: bool = false
			var sideCountingRight: bool = false
			
			# top/bottom checks
			for colInd: int in isolatedGrid[0].size():
				sideCountingLeft = false
				sideCountingRight = false
				for lineInd: int in isolatedGrid.size():
					if isolatedGrid[lineInd][colInd] == key:
						# check above focus tile
						if !Helper.valid_pos_at_grid(lineInd, colInd-1, isolatedGrid) or isolatedGrid[lineInd][colInd-1] != key:
							if sideCountingLeft == false:
								gardenSides += 1
							sideCountingLeft = true
						else:
							sideCountingLeft = false
						
						# check below focus tile
						if !Helper.valid_pos_at_grid(lineInd, colInd+1, isolatedGrid) or isolatedGrid[lineInd][colInd+1] != key:
							if sideCountingRight == false:
								gardenSides += 1
							sideCountingRight = true
						else:
							sideCountingRight = false
					else:
						sideCountingLeft = false
						sideCountingRight = false
			
			solution += gardenArea * gardenSides
	
	return solution
