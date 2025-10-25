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
	var grid: Array[PackedStringArray] = []
	var nodeGroups: Dictionary = {}
	var antinodePos: Dictionary = {}
	var validAntinodes: Dictionary = {}
	
	for line: String in inputSplit:
		if line == "": continue
		grid.append(line.split())
	
	for rowInd: int in grid.size():
		for colInd: int in grid[rowInd].size():
			var focusChar: String = grid[rowInd][colInd]
			if focusChar != ".":
				if !nodeGroups.has(focusChar):
					nodeGroups.get_or_add(focusChar, [[colInd, rowInd]])
				else:
					nodeGroups[focusChar].append([colInd, rowInd])
	
	for key: String in nodeGroups:
		for node1: Array in nodeGroups[key]:
			for node2: Array in nodeGroups[key]:
				if node1 != node2:
					var antinodeAssemble: Array = [node1[0]-(node2[0]-node1[0]), node1[1]-(node2[1]-node1[1])]
					antinodePos.get_or_add(antinodeAssemble)
					if 0 <= antinodeAssemble[0] and antinodeAssemble[0] < grid[0].size() and 0 <= antinodeAssemble[1] and antinodeAssemble[1] < grid.size():
						validAntinodes.get_or_add(antinodeAssemble)
	
	#for key: Array in validAntinodes:
		#print(key)
	
	solution = validAntinodes.keys().size()
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var grid: Array[PackedStringArray] = []
	var nodeGroups: Dictionary = {}
	var antinodePos: Dictionary = {}
	var validAntinodes: Dictionary = {}
	
	for line: String in inputSplit:
		if line == "": continue
		grid.append(line.split())
	
	for rowInd: int in grid.size():
		for colInd: int in grid[rowInd].size():
			var focusChar: String = grid[rowInd][colInd]
			if focusChar != ".":
				if !nodeGroups.has(focusChar):
					nodeGroups.get_or_add(focusChar, [[colInd, rowInd]])
				else:
					nodeGroups[focusChar].append([colInd, rowInd])
	
	for key: String in nodeGroups:
		for node1: Array in nodeGroups[key]:
			for node2: Array in nodeGroups[key]:
				if node1 != node2:
					validAntinodes.get_or_add([node1[0], node1[1]])
					var xDiff: int = (node2[0]-node1[0])
					var yDiff: int = (node2[1]-node1[1])
					var antinodeAssemble: Array = [node1[0]-xDiff, node1[1]-yDiff]
					while 0 <= antinodeAssemble[0] and antinodeAssemble[0] < grid[0].size() and 0 <= antinodeAssemble[1] and antinodeAssemble[1] < grid.size():
						validAntinodes.get_or_add(antinodeAssemble.duplicate(true))
						antinodeAssemble[0] -= xDiff
						antinodeAssemble[1] -= yDiff
						antinodePos.get_or_add(antinodeAssemble)
					#if 0 <= antinodeAssemble[0] and antinodeAssemble[0] < grid[0].size() and 0 <= antinodeAssemble[1] and antinodeAssemble[1] < grid.size():
						#validAntinodes.get_or_add(antinodeAssemble)
	
	#for key: Array in validAntinodes:
		#print(key)
	
	solution = validAntinodes.keys().size()
	
	return solution
