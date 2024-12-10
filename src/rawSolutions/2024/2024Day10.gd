extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var countedHeads1: Array[Vector2i] = []

func rec_search1(start: Vector2i, grid: Array):
	var headCount: int = 0
	var searchPos: Vector2i = Vector2i(start)
	
	
	var pathsFound: int = 0
	
	while grid[searchPos.y][searchPos.x] != 9:
		
		var adjacents: Array[Vector2i] = []
		for yCheck: int in range(-1, 2, 1):
			for xCheck: int in range(-1, 2, 1):
				if (yCheck == 0 and xCheck != 0) or (yCheck != 0 and xCheck == 0):pass 
				else: continue
				var focusX: int = searchPos.x+xCheck
				var focusY: int = searchPos.y+yCheck
				if focusY < 0 or focusY >= grid.size() or focusX < 0 or focusX >= grid[0].size():
					pass
				else:
					if grid[focusY][focusX] == grid[searchPos.y][searchPos.x]+1:
						adjacents.append(Vector2i(focusX, focusY))
		if adjacents.size() == 0: return 0
		elif adjacents.size() == 1: searchPos = adjacents[0]
		else:
			for adjacent: Vector2i in adjacents:
				headCount += rec_search1(adjacent, grid)
			break
		
	if grid[searchPos.y][searchPos.x] == 9 and !countedHeads1.has(searchPos): 
		countedHeads1.append(searchPos)
		return headCount+1
	
	return headCount

func solve1(input: String) -> int:
	var solution: int = 0
	
	var grid: Array = []
	var startPositions: Array[Vector2i] = []
	
	for line: String in input.split("\n"):
		if line == "": continue
		var intArr: Array[int] = []
		for char: String in line:
			intArr.append(char.to_int())
		grid.append(intArr)
	
	for rowInd: int in grid.size():
		for colInd: int in grid[rowInd].size():
			var checkedVal = grid[rowInd][colInd]
			if checkedVal == 0:
				startPositions.append(Vector2i(colInd, rowInd))
	
	var trailheadCount: int = 0
	
	for startPosInd: int in startPositions.size():
		countedHeads1 = []
		trailheadCount += rec_search1(startPositions[startPosInd], grid)
		#print(trailheadCount)
	solution = trailheadCount
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	return solution
