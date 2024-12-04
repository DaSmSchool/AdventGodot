extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_for_xmas(grid: Array, x: int, y: int) -> int:
	var xmas: String = "XMAS"
	var xmasCount: int = 0
	for yOff: int in range(-1, 2):
		for xOff: int in range(-1, 2):
			if xOff == 0 and yOff == 0: continue
			# 4 times
			var isXmas: bool = true
			for currCharInd: int in range(0, 4):
				var focusX: int = x + xOff*currCharInd
				var focusY: int = y + yOff*currCharInd
				if (focusX >= 0 and focusX < grid[0].size()) and (focusY >= 0 and focusY < grid.size()):
					if grid[focusY][focusX] != xmas[currCharInd]:
						isXmas = false
						break
				else:
					isXmas = false
					break
			if isXmas: 
				#print("FOUND: X==%d, Y==%d, oX==%d, oY==%d" % [x, y , xOff, yOff])
				xmasCount += 1
	return xmasCount

func check_for_cross_mas(grid: Array, x: int, y: int) -> int:
	if grid[x][y] != "A": return 0
	var xmasCount: int = 0
	var isXmasCount: int = 0
	for currCharInd: int in range(-1, 2, 2):
		var focusX1: int = x + currCharInd
		var focusY1: int = y + currCharInd
		var focusX2: int = x + currCharInd*-1
		var focusY2: int = y + currCharInd*-1
		if (focusX1 >= 0 and focusX1 < grid[0].size()) and (focusY1 >= 0 and focusY1 < grid.size()) and (focusX2 >= 0 and focusX2 < grid[0].size()) and (focusY2 >= 0 and focusY2 < grid.size()):
			if (grid[focusY1][focusX1] == "M" and grid[focusY2][focusX2] == "S") or (grid[focusY1][focusX1] == "S" and grid[focusY2][focusX2] == "M"):
				isXmasCount += 1
		else:
			break
	if isXmasCount == 2: 
		#print("FOUND: X==%d, Y==%d, oX==%d, oY==%d" % [x, y , xOff, yOff])
		xmasCount += 1
	return xmasCount

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var crossGrid: Array[PackedStringArray] = []
	
	for line: String in inputSplit:
		if line == "" : continue
		crossGrid.append(line.split())
	
	var xmasCount: int = 0
	for rInd: int in crossGrid.size():
		for cInd: int in crossGrid[rInd].size():
			xmasCount += check_for_xmas(crossGrid, cInd, rInd)
	
	solution = xmasCount
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var crossGrid: Array[PackedStringArray] = []
	
	for line: String in inputSplit:
		if line == "" : continue
		crossGrid.append(line.split())
	
	var xmasCount: int = 0
	for rInd: int in crossGrid.size():
		for cInd: int in crossGrid[rInd].size():
			xmasCount += check_for_cross_mas(crossGrid, cInd, rInd)
	
	solution = xmasCount
	
	return solution
