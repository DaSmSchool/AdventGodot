extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var grids: Array[PackedStringArray] = []
	
	for grid: String in inputSplit:
		if grid == "": continue
		var gridAssemble: PackedStringArray = []
		var gridSplit: PackedStringArray = grid.split("\n")
		for charInd: int in gridSplit[0].length():
			var row: String = ""
			for rowInd: int in gridSplit.size():
				if gridSplit[rowInd] == "": continue
				row += gridSplit[rowInd][charInd]
			gridAssemble.append(row)
		grids.append(gridAssemble)
	
	var keyNums: Array = []
	var lockNums: Array = []
	for grid: PackedStringArray in grids:
		var assembleInts: Array[int] = []
		# key
		if grid[0][0] == ".":
			for row: String in grid:
				assembleInts.append(6-row.find("#"))
			keyNums.append(assembleInts)
		# lock
		else:
			for row: String in grid:
				assembleInts.append(row.find(".")-1)
			lockNums.append(assembleInts)
	
	for key: Array in keyNums:
		for lock: Array in lockNums:
			var canFit: bool = true
			for focusInd: int in key.size():
				if key[focusInd] + lock[focusInd] > 5:
					canFit = false
					break
			if canFit: solution += 1
	
	#print(keyNums)
	#print(lockNums)
	
	return solution
