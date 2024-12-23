extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var grid: Array = []
	var startPoint: Vector2i
	var endPoint: Vector2i
	
	for rowInd: int in inputSplit.size():
		if inputSplit[rowInd] == "": continue
		var gridRow: Array = []
		for charInd: int in inputSplit[rowInd].length():
			
			match inputSplit[rowInd][charInd]:
				"#":
					gridRow.append("#")
				".":
					gridRow.append(".")
				"S":
					gridRow.append(".")
					startPoint = Vector2i(charInd, rowInd)
				"E":
					gridRow.append(".")
					endPoint = Vector2i(charInd, rowInd)
		grid.append(gridRow)
	
	var pathIndeces: Dictionary = {}
	var currIndex: int = 0
	var currPos: Vector2i = startPoint
	pathIndeces.get_or_add(currPos, currIndex)
	
	while currPos != endPoint:
		var foundNext: bool = false
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(xOff) == abs(yOff): continue
				var absPoint: Vector2i = currPos + Vector2i(xOff, yOff)
				if grid[absPoint.y][absPoint.x] == "." and !pathIndeces.has(absPoint):
					foundNext = true
					currIndex += 1
					pathIndeces.get_or_add(absPoint, currIndex)
					currPos = absPoint
			if foundNext: break
	
	# rerun through maze to find cheats
	var cheatList: Array = []
	currPos = startPoint
	while currPos != endPoint:
		var foundNext: bool = false
		
		var nextPoint: Vector2i
		
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(xOff) == abs(yOff): continue
				var dir: Vector2i = Vector2i(xOff, yOff)
				var absPoint: Vector2i = currPos + dir
				#print(absPoint)
				if !Helper.valid_pos_at_grid(absPoint.y, absPoint.x, grid): continue
				if grid[absPoint.y][absPoint.x] == "#":
					if !Helper.valid_pos_at_grid(absPoint.y+dir.y, absPoint.x+dir.x, grid): continue
					if grid[absPoint.y+dir.y][absPoint.x+dir.x] == ".":
						cheatList.append([currPos, absPoint+dir, pathIndeces[absPoint+dir]-pathIndeces[currPos]-2])
				
				elif grid[absPoint.y][absPoint.x] == "." and pathIndeces[absPoint] > pathIndeces[currPos]:
					nextPoint = absPoint

		currPos = nextPoint
	
	#print(pathIndeces)
	#print()
	
	var savingCheats: int = 0
	for cheat: Array in cheatList:
		if cheat[2] >= 100:
			savingCheats += 1
		#print(cheat)
	#print(cheatList)
	
	solution = savingCheats
	
	return solution

func check_cheats_p2(pos: Vector2i, moves: int, grid: Array, inds: Dictionary, cheatList: Array) -> void:
	# -2 #  X  
	# -1 # XXX 
	#  0 #XX0XX
	#  1 # XXX 
	#  2 #  X  
	for yOff in range(moves*-1, moves+1):
		for xOff in range(moves*-1, moves+1):
			if abs(yOff) + abs(xOff) == 0: continue
			if abs(yOff) + abs(xOff) > moves: continue
			var posOffset: Vector2i = Vector2i(xOff, yOff)
			var focusPos: Vector2i = pos + posOffset
			if !Helper.valid_pos_at_grid(focusPos.y, focusPos.x, grid): continue
			if inds.has(focusPos):
				var timeSaved: int = (inds[focusPos] - inds[pos]) - (abs(yOff) + abs(xOff))
				cheatList.append([pos, focusPos, timeSaved])

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var grid: Array = []
	var startPoint: Vector2i
	var endPoint: Vector2i
	
	for rowInd: int in inputSplit.size():
		if inputSplit[rowInd] == "": continue
		var gridRow: Array = []
		for charInd: int in inputSplit[rowInd].length():
			
			match inputSplit[rowInd][charInd]:
				"#":
					gridRow.append("#")
				".":
					gridRow.append(".")
				"S":
					gridRow.append(".")
					startPoint = Vector2i(charInd, rowInd)
				"E":
					gridRow.append(".")
					endPoint = Vector2i(charInd, rowInd)
		grid.append(gridRow)
	
	var pathIndeces: Dictionary = {}
	var currIndex: int = 0
	var currPos: Vector2i = startPoint
	pathIndeces.get_or_add(currPos, currIndex)
	
	while currPos != endPoint:
		var foundNext: bool = false
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(xOff) == abs(yOff): continue
				var absPoint: Vector2i = currPos + Vector2i(xOff, yOff)
				if grid[absPoint.y][absPoint.x] == "." and !pathIndeces.has(absPoint):
					foundNext = true
					currIndex += 1
					pathIndeces.get_or_add(absPoint, currIndex)
					currPos = absPoint
			if foundNext: break
	
	# rerun through maze to find cheats
	var cheatList: Array = []
	
	var pathIndSize: int = pathIndeces.keys().size()
	
	currPos = startPoint
	while currPos != endPoint:
		var foundNext: bool = false
		
		
		
		#print("Checking Path Index: " + str(pathIndeces[currPos]))
		#print("Path Percent: " + str(float(pathIndeces[currPos])/pathIndSize))
		check_cheats_p2(currPos, 20, grid, pathIndeces, cheatList)
		
		var nextPoint: Vector2i
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(xOff) == abs(yOff): continue
				var dir: Vector2i = Vector2i(xOff, yOff)
				var absPoint: Vector2i = currPos + dir
				if grid[absPoint.y][absPoint.x] == "." and pathIndeces[absPoint] > pathIndeces[currPos]:
					nextPoint = absPoint
					break
			if nextPoint == null: break

		currPos = nextPoint
	
	#print(pathIndeces)
	#print()
	
	var savingCheats: int = 0
	for cheat: Array in cheatList:
		if cheat[2] >= 100:
			savingCheats += 1
		#print(cheat)
	#print(cheatList)
	
	solution = savingCheats
	
	return solution
