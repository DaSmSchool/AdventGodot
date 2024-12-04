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
	
	return solution
