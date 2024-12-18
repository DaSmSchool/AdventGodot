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
			if unvisitedSpots.has(Vector2i(charInd, rowInd)): continue
			if grid[rowInd][charInd] == ".":
				unvisitedSpots.get_or_add(Vector2i(charInd, rowInd), INF)
			elif grid[rowInd][charInd] == "S":
				startPos = Vector2i(charInd, rowInd)
				visitedSpots.get_or_add(Vector2i(charInd, rowInd), [""])
			elif grid[rowInd][charInd] == "E":
				finishPos = Vector2i(charInd, rowInd)
				unvisitedSpots.get_or_add(Vector2i(charInd, rowInd), INF)
	
	var hasSearchable: bool = true
	
	var possiblePaths: Dictionary = {}
	var spotsToVisit: Array = []
	spotsToVisit.append([startPos, [">"]])
	
	while spotsToVisit.size() != 0:
		
		var focusSpot: Array
		if spotsToVisit.size() == 1:
			focusSpot = spotsToVisit[0]
		else: 
			focusSpot = spotsToVisit.reduce(func(min, spot): return spot if get_path_length(spot[1][0]) < get_path_length(min[1][0]) else min)
		
		#print(spotsToVisit)
		print(focusSpot)
		print()
		
		if focusSpot[0] == finishPos:
			for path: String in focusSpot[1]:
				possiblePaths.get_or_add(path)
		
		
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				var offsetSpot: Vector2i = Vector2i(focusSpot[0].x + xOff, focusSpot[0].y + yOff)
				var dirVec: Vector2i = Vector2i(xOff, yOff)
				if abs(yOff) != abs(xOff) and ".E".contains(grid[offsetSpot.y][offsetSpot.x]):
					var visitSpotPaths: Array = focusSpot[1].duplicate()
					
					for strInd: int in visitSpotPaths.size():
						if dirVec == Vector2i.UP:
							visitSpotPaths[strInd] += "^"
						elif dirVec == Vector2i.DOWN:
							visitSpotPaths[strInd] += "v"
						elif dirVec == Vector2i.LEFT:
							visitSpotPaths[strInd] += "<"
						elif dirVec == Vector2i.RIGHT:
							visitSpotPaths[strInd] += ">"
					
					if !unvisitedSpots.has(offsetSpot):
						if get_path_length_no_turn(visitSpotPaths[0]) < get_path_length_no_turn(visitedSpots[offsetSpot][0]):
							visitedSpots[offsetSpot] = visitSpotPaths
						elif get_path_length_no_turn(visitSpotPaths[0]) == get_path_length_no_turn(visitedSpots[offsetSpot][0]):
							visitedSpots[offsetSpot].append_array(visitSpotPaths)
						else:
							continue
					
					
					
					spotsToVisit.append([offsetSpot, visitSpotPaths])
					
					if grid[offsetSpot.y][offsetSpot.x] == ".":
						unvisitedSpots.erase(offsetSpot)
						visitedSpots.get_or_add(offsetSpot, visitSpotPaths)
				
		spotsToVisit.erase(focusSpot)
	
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
