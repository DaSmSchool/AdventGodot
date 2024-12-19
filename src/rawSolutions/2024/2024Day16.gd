extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_path_length(path: String) -> int:
	var pathLength: int = 0
	
	for charInd: int in path.length():
		if charInd == 0: pass
		else:
			if path[charInd] != path[charInd-1]: pathLength += 1000
			pathLength += 1
	
	return pathLength


func get_path_length_no_turn(path: String) -> int:
	var pathLength: int = 0
	
	for charInd: int in path.length():
		if charInd == 0: pass
		else:
			pathLength += 1
	
	return pathLength


func increment_path_list(pathArray: Array, dir: Vector2i) -> Array:
	var assemble: Array = pathArray.duplicate(true)
	
	for strInd: int in assemble.size():
		if dir == Vector2i.UP:
			assemble[strInd] += "^"
		elif dir == Vector2i.DOWN:
			assemble[strInd] += "v"
		elif dir == Vector2i.LEFT:
			assemble[strInd] += "<"
		elif dir == Vector2i.RIGHT:
			assemble[strInd] += ">"
	
	return assemble


func add_if_lowest(masterArr: Array, attemptAdd: Array) -> bool:
	var sameTargetArray: Array = []
	
	for spot: Array in masterArr:
		if spot[0] == attemptAdd[0]:
			sameTargetArray.append(spot)
	
	var smaller: bool = true
	for similarSpot: Array in sameTargetArray:
		if get_path_length_no_turn(similarSpot[1][0]) <= get_path_length_no_turn(attemptAdd[1][0]):
				smaller = false
				break
	
	if smaller:
		for spot: Array in sameTargetArray:
			masterArr.erase(spot)
		masterArr.append(attemptAdd)
	
	return smaller

func solve1(input: String) -> int:
	var solution: int = 0
	
	var grid: Array = []
	
	for row in input.split("\n"):
		if row == "": continue
		grid.append(row.split(""))
	
	var unvisitedSpots: Dictionary = {}
	var visitedSpots: Dictionary = {}
	var startPos: Vector2i = Vector2i()
	var finishPos: Vector2i = Vector2i()
	
	for rowInd: int in grid.size():
		for charInd: int in grid[rowInd].size():
			if grid[rowInd][charInd] == ".":
				unvisitedSpots.get_or_add(Vector2i(charInd, rowInd), INF)
			elif grid[rowInd][charInd] == "S":
				startPos = Vector2i(charInd, rowInd)
				visitedSpots.get_or_add(Vector2i(charInd, rowInd), [""])
			elif grid[rowInd][charInd] == "E":
				finishPos = Vector2i(charInd, rowInd)
				unvisitedSpots.get_or_add(Vector2i(charInd, rowInd), INF)
	
	var totalSpots: int = unvisitedSpots.size()
	print(totalSpots)
	var spotsChecked: int = 0
	
	var hasSearchable: bool = true
	
	var possiblePaths: Dictionary = {}
	var spotsToVisit: Array = []
	spotsToVisit.append([startPos, [">"]])
	
	while spotsToVisit.size() != 0:
		print("{percent}%".format({"percent": "%4.2f" % (spotsChecked*100.0/totalSpots)}))
		print("Spots to check: %d" % spotsToVisit.size())
		print("Spots checked: %d" % spotsChecked)
		var focusSpot: Array
		if spotsToVisit.size() == 1:
			focusSpot = spotsToVisit[0]
		else: 
			focusSpot = spotsToVisit.reduce(func(min, spot): return spot if get_path_length(spot[1][0]) < get_path_length(min[1][0]) else min)
		
		#print(spotsToVisit)
		#print(focusSpot)
		#print()
		
		if focusSpot[0] == finishPos:
			for path: String in focusSpot[1]:
				possiblePaths.get_or_add(path)
			spotsToVisit.erase(focusSpot)
			continue
		
		
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				var offsetSpot: Vector2i = Vector2i(focusSpot[0].x + xOff, focusSpot[0].y + yOff)
				if abs(yOff) != abs(xOff) and ".E".contains(grid[offsetSpot.y][offsetSpot.x]) and unvisitedSpots.has(offsetSpot):
					var dirVec: Vector2i = Vector2i(xOff, yOff)
					var visitSpotPaths: Array = []
					
					for checkSpot: Array in spotsToVisit:
						if checkSpot[0] != focusSpot[0]: continue
						if get_path_length_no_turn(focusSpot[1][0]+".") < get_path_length_no_turn(checkSpot[1][0]):
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							checkSpot[1] = visitSpotPaths
						elif get_path_length_no_turn(focusSpot[1][0]+".") == get_path_length_no_turn(checkSpot[1][0]):
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							checkSpot[1].append_array(visitSpotPaths)
							
						continue
					
					if visitSpotPaths.is_empty():
						visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
					
					add_if_lowest(spotsToVisit, [offsetSpot, visitSpotPaths])
					#spotsToVisit.append([offsetSpot, visitSpotPaths])
					
		
		visitedSpots.get_or_add(focusSpot[0], focusSpot[1])
		unvisitedSpots.erase(focusSpot[0])
		spotsToVisit.erase(focusSpot)
		spotsChecked += 1
	
	var pathScores: Array[int] = []
	for path: String in possiblePaths:
		print(path)
		var pathScore: int = get_path_length(path)
		print(pathScore)
		pathScores.append(pathScore)
	
	solution = pathScores.min()
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
