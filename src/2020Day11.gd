extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var newGrid: Array = []

func update_grid1(grid: Array) -> int:
	
	var sameGrid: bool = true
	var takenCount: int = 0
	
	var modGrid: Array = grid.duplicate(true)
	
	for r in modGrid.size():
		for c in modGrid[0].size():
			var adjSeats: Array = []
			for fr in range(-1, 2):
				var adjRow: Array = []
				for fc in range(-1, 2):
					# this would be the current seat
					if fc == 0 and fr == 0: continue
					if r+fr >= 0 and r+fr < grid.size() and c+fc >= 0 and c+fc < grid[0].size():
						adjRow.append(grid[r+fr][c+fc])
						
				adjSeats.append(adjRow)
			
			var emptyCount: int = 0
			var fullCount: int = 0
			for row in adjSeats:
				for seat in row:
					if seat == "L": emptyCount += 1
					elif seat == "#": fullCount += 1
			
			if modGrid[r][c] == "L":
				if fullCount == 0:
					modGrid[r][c] = "#"
			elif modGrid[r][c] == "#":
				if fullCount >= 4:
					modGrid[r][c] = "L"
			
			if sameGrid: 
				if modGrid[r][c] != grid[r][c]: 
					sameGrid = false
				else:
					if modGrid[r][c] == "#":
						takenCount += 1
	#print("INPUT")
	#for row in grid:
		#print(row)
	#print("OUTPUT")
	#for row in modGrid:
		#print(row)
	#print()
	newGrid = modGrid
	
	if sameGrid:
		return takenCount
	else:
		return -1

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var viewGrid: Array = []
	
	for row in inputLines:
		if row == "": continue
		var splitRow: PackedStringArray = row.split()
		viewGrid.append(splitRow)
	
	var seatsTaken = update_grid1(viewGrid)
	viewGrid = newGrid
	
	while seatsTaken == -1:
		seatsTaken = update_grid1(viewGrid)
		viewGrid = newGrid
	
	solution = seatsTaken
	
	return solution

func update_grid2(grid: Array) -> int:
	
	var sameGrid: bool = true
	var takenCount: int = 0
	
	var modGrid: Array = grid.duplicate(true)
	
	for r in modGrid.size():
		for c in modGrid[0].size():
			if r == 1 and c == 8:
				true
			var adjSeats: Array = []
			for fr in range(-1, 2):
				var adjRow: Array = []
				for fc in range(-1, 2):
					# this would be the current seat
					if fc == 0 and fr == 0: continue
					
					var checkFR: int = fr
					var checkFC: int = fc
					while true:
						if r+checkFR >= 0 and r+checkFR < grid.size() and c+checkFC >= 0 and c+checkFC < grid[0].size():
							if grid[r+checkFR][c+checkFC] == ".":
								checkFR += sign(checkFR)
								checkFC += sign(checkFC)
							else:
								adjRow.append(grid[r+checkFR][c+checkFC])
								break
						else:
							break
				adjSeats.append(adjRow)
			
			var emptyCount: int = 0
			var fullCount: int = 0
			for row in adjSeats:
				for seat in row:
					if seat == "L": emptyCount += 1
					elif seat == "#": fullCount += 1
			
			if modGrid[r][c] == "L":
				if fullCount == 0:
					modGrid[r][c] = "#"
			elif modGrid[r][c] == "#":
				if fullCount >= 5:
					modGrid[r][c] = "L"
			
			if sameGrid: 
				if modGrid[r][c] != grid[r][c]: 
					sameGrid = false
				else:
					if modGrid[r][c] == "#":
						takenCount += 1
	#print("INPUT")
	#for row in grid:
		#print("".join(row))
	#print("OUTPUT")
	#for row in modGrid:
		#print("".join(row))
	#print()
	newGrid = modGrid
	
	if sameGrid:
		return takenCount
	else:
		return -1

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var viewGrid: Array = []
	
	for row in inputLines:
		if row == "": continue
		var splitRow: PackedStringArray = row.split()
		viewGrid.append(splitRow)
	
	var seatsTaken = update_grid2(viewGrid)
	viewGrid = newGrid
	
	while seatsTaken == -1:
		seatsTaken = update_grid2(viewGrid)
		viewGrid = newGrid
	
	solution = seatsTaken
	
	return solution
