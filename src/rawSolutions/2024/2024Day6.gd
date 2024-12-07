extends Solution

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var guardX: int = 0
	var guardY: int = 0
	var guardDir: Vector2 = Vector2(0, -1)
	var visitedTiles: Dictionary = {}
	
	var grid: Array[PackedStringArray] = []
	for row: String in input.split("\n"):
		if row == "": continue
		grid.append(row.split(""))
	
	var guardFound: bool = false
	for rowInd: int in grid.size():
		for charInd: int in grid[rowInd].size():
			if grid[rowInd][charInd] == "^":
				grid[rowInd][charInd] = "."
				guardX = charInd
				guardY = rowInd
				guardFound = true
				break
		if guardFound: break
	
	var guardCanAction: bool = true
	while guardCanAction:
		if !visitedTiles.has([guardX, guardY]):
			visitedTiles.get_or_add([guardX, guardY], true)
		#print("X: %d, Y: %d" % [guardX, guardY])
		
		var nextTile: Vector2 = Vector2(guardX+guardDir.x, guardY+guardDir.y)
		
		# oob
		#print(is_equal_approx(nextTile.x, -1))
		#print(is_equal_approx(nextTile.y, -1))
		if is_equal_approx(nextTile.x, -1) or is_equal_approx(nextTile.y, -1) or nextTile.x >= grid[0].size() or nextTile.y >= grid.size():
			guardCanAction = false
		elif grid[nextTile.y][nextTile.x] == "#":
			guardDir = guardDir.rotated(deg_to_rad(90))
			if is_zero_approx(guardDir.x): guardDir.x = 0.0
			if is_zero_approx(guardDir.y): guardDir.y = 0.0
			#print(guardDir)
		else:
			guardX += guardDir.x
			guardY += guardDir.y
	
	solution = visitedTiles.keys().size()
	
	return solution

var validObsTiles: Dictionary = {}

func subSearch(initPos: Vector2, initDir: Vector2, grid: Array[PackedStringArray], addedObstacleCoord: Vector2, visited: Dictionary) -> void:
	var subPos: Vector2 = Vector2(initPos)
	var subDir: Vector2 = Vector2(initDir)
	var subGrid: Array[PackedStringArray] = grid.duplicate(true)
	subGrid[addedObstacleCoord.y][addedObstacleCoord.x] = "#"
	
	
	var subVisitedTiles: Dictionary = {}
	var guardCanAction: bool = true
	while guardCanAction:
		#print("X: %d, Y: %d" % [guardX, guardY])
		if !subVisitedTiles.has([subPos, subDir]):
			subVisitedTiles.get_or_add([subPos, subDir], true)
		else:
			
			#if !validObsTiles.has(subPos): 
			validObsTiles.get_or_add(addedObstacleCoord, true)
			#subGrid[addedObstacleCoord.y][addedObstacleCoord.x] = "O"
			#print()
			#for row: PackedStringArray in subGrid:
				#print(row)
			
			break
		var nextTile: Vector2 = Vector2(subPos.x+subDir.x, subPos.y+subDir.y)
		
		# oob
		#print(is_equal_approx(nextTile.x, -1))
		#print(is_equal_approx(nextTile.y, -1))
		if is_equal_approx(nextTile.x, -1) or is_equal_approx(nextTile.y, -1) or nextTile.x >= subGrid[0].size() or nextTile.y >= subGrid.size():
			guardCanAction = false
		elif subGrid[nextTile.y][nextTile.x] == "#":
			subDir = subDir.rotated(deg_to_rad(90))
			if is_zero_approx(subDir.x): subDir.x = 0.0
			if is_zero_approx(subDir.y): subDir.y = 0.0
			#print(guardDir)
		else:
			subPos.x += subDir.x
			subPos.y += subDir.y

func solve2(input: String) -> int:
	var solution: int = 0
	
	var init: Vector2 = Vector2()
	var guardPos: Vector2 = Vector2(0, 0)
	var guardDir: Vector2 = Vector2(0, -1)
	var visitedTiles: Dictionary = {}
	
	var grid: Array[PackedStringArray] = []
	for row: String in input.split("\n"):
		if row == "": continue
		grid.append(row.split(""))
	
	var guardFound: bool = false
	for rowInd: int in grid.size():
		for charInd: int in grid[rowInd].size():
			if grid[rowInd][charInd] == "^":
				grid[rowInd][charInd] = "."
				init.x = charInd
				init.y = rowInd
				guardPos.x = charInd
				guardPos.y = rowInd
				guardFound = true
				break
		if guardFound: break
	
	var guardCanAction: bool = true
	while guardCanAction:
		if !visitedTiles.has([guardPos, guardDir]):
			visitedTiles.get_or_add([guardPos, guardDir], true)
		#print("X: %d, Y: %d" % [guardX, guardY])
		
		var nextTile: Vector2 = Vector2(guardPos.x+guardDir.x, guardPos.y+guardDir.y)
		
		# oob
		#print(is_equal_approx(nextTile.x, -1))
		#print(is_equal_approx(nextTile.y, -1))
		if is_equal_approx(nextTile.x, -1) or is_equal_approx(nextTile.y, -1) or nextTile.x >= grid[0].size() or nextTile.y >= grid.size():
			guardCanAction = false
		elif grid[nextTile.y][nextTile.x] == "#":
			guardDir = guardDir.rotated(deg_to_rad(90))
			if is_zero_approx(guardDir.x): guardDir.x = 0.0
			if is_zero_approx(guardDir.y): guardDir.y = 0.0
			#print(guardDir)
		elif grid[nextTile.y][nextTile.x] == ".":
			if init != nextTile:
				subSearch(guardPos, guardDir, grid, nextTile, visitedTiles)
			guardPos.x += guardDir.x
			guardPos.y += guardDir.y
	
	solution = validObsTiles.keys().size()
	
	return solution
