extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func dijkstraP1(grid: Array, unvisited: Array) -> int:
	var shortest: int = 0
	
	for point: Array in unvisited:
		if point[0] == Vector2i.ZERO:
			point[1] = 0
			break
	
	var winningPoint: Vector2i = Vector2i(70, 70)
	
	while unvisited.size() != 0:
		
		# get smallest distance point
		var focusPoint: Array = unvisited[0]
		for pointInd: int in range(1, unvisited.size()):
			if unvisited[pointInd][1] < focusPoint[1]:
				focusPoint = unvisited[pointInd]
		
		if focusPoint[0] == winningPoint:
			return focusPoint[1]
		
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(yOff) == abs(xOff): continue
				
				var offPoint: Vector2i = Vector2i(0, 0)
				offPoint.x = focusPoint[0].x + xOff
				offPoint.y = focusPoint[0].y + yOff
				if !Helper.valid_pos_at_grid(offPoint.y, offPoint.x, grid): continue
				
				if grid[offPoint.y][offPoint.x] == ".":
					for point: Array in unvisited:
						if point == focusPoint: continue
						if point[0] != offPoint: continue
						if point[1] > focusPoint[1]+1:
							point[1] = focusPoint[1]+1
							pass
		
		unvisited.erase(focusPoint)
		
	
	return shortest


func solve1(input: String) -> int:
	var solution: int = 0
	
	var corruptPoints: Array[Vector2i] = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	for line: String in inputSplit:
		if line == "": continue
		corruptPoints.append(Vector2i(line.split(",")[0].to_int(), line.split(",")[1].to_int()))
	
	var selectPoints: Array[Vector2i] = corruptPoints.slice(0, 1024)
	var grid: Array = []
	var unvisitedPoints: Array = []
	for rowInd: int in range(71):
		var rowAssemble: PackedStringArray = []
		
		for colInd: int in range(71):
			var checkPoint: Vector2i = Vector2i(colInd, rowInd)
			if selectPoints.has(checkPoint):
				rowAssemble.append("#")
			else:
				rowAssemble.append(".")
				unvisitedPoints.append([checkPoint, INF])
		
		grid.append(rowAssemble)
	
	solution = dijkstraP1(grid, unvisitedPoints)
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	return solution
