extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var maxBoxInRow: int = 0

func can_move_boxes(pos: Vector2i, direction: String, grid: Array) -> bool:
	maxBoxInRow += 1
	var focusPos: Vector2i = Vector2i(pos)
	
	if direction == "<":
		focusPos.x -= 1
	elif direction == "^":
		focusPos.y -= 1
	elif direction == ">":
		focusPos.x += 1
	elif direction == "v":
		focusPos.y += 1
	else:
		return false
	
	if grid[focusPos.y][focusPos.x] == "O":
		return can_move_boxes(focusPos, direction, grid)
	elif grid[focusPos.y][focusPos.x] == ".":
		return true
	elif grid[focusPos.y][focusPos.x] == "#":
		return false
	else: return false
	

func solve1(input: String) -> int:
	maxBoxInRow = 0
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var gridInput: PackedStringArray = inputSplit[0].split("\n")
	var robotInstructionsInput: PackedStringArray = inputSplit[1].split("\n")
	
	var robotPos: Vector2i = Vector2i()
	
	var grid: Array = []
	for rowInd: int in gridInput.size():
		var addRow: PackedStringArray = gridInput[rowInd].split("")
		for characterInd: int in addRow.size():
			if addRow[characterInd] == "@":
				addRow[characterInd] = "."
				robotPos.x = characterInd
				robotPos.y = rowInd
		grid.append(addRow)
	
	var instrList: String = ""
	for line: String in robotInstructionsInput:
		instrList += line
	
	Helper.print_grid(grid)
	print(instrList)
	
	for instr: String in instrList:
		maxBoxInRow = 0
		var focusPos: Vector2i = Vector2i(robotPos)
	
		if instr == "<":
			focusPos.x -= 1
		elif instr == "^":
			focusPos.y -= 1
		elif instr == ">":
			focusPos.x += 1
		elif instr == "v":
			focusPos.y += 1
		
		var focusChar: String = grid[focusPos.y][focusPos.x]
		if focusChar == "O":
			var canMove: bool = can_move_boxes(focusPos, instr, grid)
			var traverseDir: Vector2i = focusPos - robotPos
			
			if canMove:
				var swapPos: Vector2i = focusPos + (traverseDir * maxBoxInRow)
				robotPos = focusPos
				grid[focusPos.y][focusPos.x] = "."
				grid[swapPos.y][swapPos.x] = "O"
				
		elif focusChar == ".":
			robotPos = focusPos
		elif focusChar == "#":
			pass
		
		#Helper.print_grid(grid)
	
	for rowInd: int in grid.size():
		for colInd: int in grid[rowInd].size():
			if grid[rowInd][colInd] == "O":
				solution += 100 * rowInd
				solution += colInd
		
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
