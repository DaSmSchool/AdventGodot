extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var maxBoxInRow: int = 0

func can_move_boxes1(pos: Vector2i, direction: String, grid: Array) -> bool:
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
		return can_move_boxes1(focusPos, direction, grid)
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
	
	#Helper.print_grid(grid)
	#print(instrList)
	
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
			var canMove: bool = can_move_boxes1(focusPos, instr, grid)
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

var horizTileCache: Vector2i = Vector2i()

func can_move_boxes2_no_aff(pos: Vector2i, direction: String, grid: Array) -> bool:
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
	
	var currentTile: String = grid[pos.y][pos.x]
	var focusTile: String = grid[focusPos.y][focusPos.x]
	var focusDir: Vector2i = focusPos-pos
	
	if "<>".contains(direction):
		if "[]".contains(focusTile):
			var nextTileCheck: bool = can_move_boxes2_no_aff(pos+focusDir*2, direction, grid)
			if nextTileCheck:
				grid[(focusPos).y][(focusPos).x] = "."
				return true
			else:
				return false
		elif focusTile == "#":
			return false
		elif focusTile == ".":
			return true
	elif "^v".contains(direction):
		var partnerTilePos: Vector2i
		if "[" == focusTile:
			partnerTilePos = Vector2i(focusPos)+Vector2i(1, 0)
		elif "]" == focusTile:
			partnerTilePos = Vector2i(focusPos)+Vector2i(-1, 0)
		
		if "[]".contains(focusTile):
			if focusTile != currentTile:
				var pushResult: bool = can_move_boxes2_no_aff(focusPos, direction, grid) and can_move_boxes2_no_aff(partnerTilePos, direction, grid)
				if pushResult:
					return true
			else:
				var pushResult: bool = can_move_boxes2_no_aff(focusPos, direction, grid)
				if pushResult:
					return true
		elif focusTile == "#":
			return false
		elif focusTile == ".":
			return true
	
	return false

func can_move_boxes2(pos: Vector2i, direction: String, grid: Array) -> bool:
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
	
	var currentTile: String = grid[pos.y][pos.x]
	var focusTile: String = grid[focusPos.y][focusPos.x]
	var focusDir: Vector2i = focusPos-pos
	
	if "<>".contains(direction):
		if "[]".contains(focusTile):
			var nextTileCheck: bool = can_move_boxes2(pos+focusDir*2, direction, grid)
			if nextTileCheck:
				grid[(focusPos+focusDir*2).y][(focusPos+focusDir*2).x] = grid[(focusPos+focusDir).y][(focusPos+focusDir).x]
				grid[(focusPos+focusDir).y][(focusPos+focusDir).x] = grid[(focusPos).y][(focusPos).x]
				grid[(focusPos).y][(focusPos).x] = "."
				return true
			else:
				return false
		elif focusTile == "#":
			return false
		elif focusTile == ".":
			return true
	elif "^v".contains(direction):
		var partnerTilePos: Vector2i
		if "[" == focusTile:
			partnerTilePos = Vector2i(focusPos)+Vector2i(1, 0)
		elif "]" == focusTile:
			partnerTilePos = Vector2i(focusPos)+Vector2i(-1, 0)
		
		if "[]".contains(focusTile):
			if focusTile != currentTile:
				var pushResult: bool = can_move_boxes2_no_aff(focusPos, direction, grid) and can_move_boxes2_no_aff(partnerTilePos, direction, grid)
				if pushResult:
					can_move_boxes2(focusPos, direction, grid) and can_move_boxes2(partnerTilePos, direction, grid)
					grid[(focusPos+focusDir).y][(focusPos+focusDir).x] = grid[(focusPos).y][(focusPos).x]
					grid[(focusPos).y][(focusPos).x] = "."
					grid[(partnerTilePos+focusDir).y][(partnerTilePos+focusDir).x] = grid[(partnerTilePos).y][(partnerTilePos).x]
					grid[(partnerTilePos).y][(partnerTilePos).x] = "."
					return true
			else:
				var pushResult: bool = can_move_boxes2_no_aff(focusPos, direction, grid)
				if pushResult:
					can_move_boxes2(focusPos, direction, grid)
					grid[(focusPos+focusDir).y][(focusPos+focusDir).x] = grid[(focusPos).y][(focusPos).x]
					grid[(focusPos).y][(focusPos).x] = "."
					return true
		elif focusTile == "#":
			return false
		elif focusTile == ".":
			return true
	
	return false


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var gridInput: PackedStringArray = inputSplit[0].split("\n")
	var robotInstructionsInput: PackedStringArray = inputSplit[1].split("\n")
	
	var robotPos: Vector2i = Vector2i()
	
	var grid: Array = []
	for rowInd: int in gridInput.size():
		var addRow: String = ""
		for characterInd: int in gridInput[rowInd].length():
			if gridInput[rowInd][characterInd] == "@":
				gridInput[rowInd][characterInd] = "."
				robotPos.x = characterInd*2
				robotPos.y = rowInd
			if gridInput[rowInd][characterInd] == ".":
				addRow += ".."
			elif gridInput[rowInd][characterInd] == "O":
				addRow += "[]"
			elif gridInput[rowInd][characterInd] == "#":
				addRow += "##"
		grid.append(addRow.split(""))
	
	var instrList: String = ""
	for line: String in robotInstructionsInput:
		instrList += line
	
	#Helper.print_grid(grid)
	#print(instrList)
	
	var displayGrid: Array
	
	var moveNumber: int = 0
	for instr: String in instrList:
		moveNumber += 1
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
		if focusChar == "[" or focusChar == "]":
			var canMove: bool = can_move_boxes2(robotPos, instr, grid)
			if canMove:
				robotPos = focusPos
		elif focusChar == ".":
			robotPos = focusPos
		elif focusChar == "#":
			pass
		
		#displayGrid = grid.duplicate(true)
		#displayGrid[robotPos.y][robotPos.x] = "@"
		#Helper.print_grid(displayGrid)
		#print("(" + str(moveNumber) + ") " + "(" + instr + ") " + "(" + focusChar + ") " + str(robotPos) + " " + str(focusPos))
		#
		#await get_tree().create_timer(0.01).timeout
	
	Helper.print_grid(displayGrid)
	
	for rowInd: int in grid.size():
		for colInd: int in grid[rowInd].size():
			if grid[rowInd][colInd] == "[":
				solution += 100 * rowInd
				solution += colInd
		
	return solution
