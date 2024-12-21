extends Node

# This day took me about 4 days to complete. What did I do and learn?
# I learned Dijkstra's algorithm, it seems pretty cool
# I implemented Dijkstras, sloppily tried to fit the path tracking system required for part 2 while working on part 1
# I ended up messing up that code once I refactored the code to actually implement dijkstra's, leaving disfunctional code
# I never cleaned up that code because "what if it's actually important since the path length counting "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var unvisitedSpots: Dictionary = {}
var visitedSpots: Dictionary = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# main path length getter
func get_path_length(path: String) -> int:
	var pathLength: int = 0
	
	for charInd: int in path.length():
		if charInd == 0: pass
		else:
			if path[charInd] != path[charInd-1]: pathLength += 1000
			pathLength += 1
	
	return pathLength

# treats turns as only 1 extra weight
func get_path_action_score(path: String) -> int:
	var pathLength: int = 0
	
	for charInd: int in path.length():
		if charInd == 0: pass
		else:
			if path[charInd] != path[charInd-1]: pathLength += 1
			pathLength += 1
	
	return pathLength


func dir_to_string(dir: Vector2i) -> String:
	if dir == Vector2i.UP:
		return "^"
	elif dir == Vector2i.DOWN:
		return "v"
	elif dir == Vector2i.LEFT:
		return "<"
	elif dir == Vector2i.RIGHT:
		return ">"
	# no proper handling for this case
	else:
		return "?"


func string_to_dir(dir: String) -> Vector2i:
	if dir == "^":
		return Vector2i.UP
	elif dir == "v":
		return Vector2i.DOWN
	elif dir == "<":
		return Vector2i.LEFT
	elif dir == ">":
		return Vector2i.RIGHT
	# no proper handling for this case
	else:
		return Vector2i.ZERO


func increment_path_list(pathArray: Array, dir: Vector2i) -> Array:
	var assemble: Array = pathArray.duplicate(true)
	
	for strInd: int in assemble.size():
		assemble[strInd] += dir_to_string(dir)
	
	return assemble

# this does more than just "add if the spot is the lowest one in the queue so far"!
func add_if_lowest(masterArr: Array, attemptAdd: Array) -> bool:
	var sameTargetArray: Array = []
	
	# grab every spot that has the same position as attemptAdd
	for spot: Array in masterArr:
		if spot[0] == attemptAdd[0]:
			sameTargetArray.append(spot)
	
	# grab possible neighbors from the spot list
	var neighborSpots: Array = []
	for yOff: int in range(-1, 2):
		for xOff: int in range(-1, 2):
			if abs(yOff) != abs(xOff):
				var neighborPos: Vector2i = Vector2i(attemptAdd[0].x+xOff, attemptAdd[0].y+yOff)
				for spot: Array in masterArr:
					if spot[0] == neighborPos:
						neighborSpots.append(spot)
	
	# if any of the neighboring spots have the same action score (not path/real score), append that neighbor's paths to our own
	for neighborSpot: Array in neighborSpots:
		if get_path_action_score(neighborSpot[1][0]) == get_path_action_score(attemptAdd[1][0]):
			var neighborDir: Vector2i =  attemptAdd[0] - neighborSpot[0]
			
			var dirString: = dir_to_string(neighborDir)
			
			for path: String in neighborSpot[1]:
				attemptAdd[1].append(path+dirString)
	
	# determines if the path we are trying to add is the smallest amongst other paths in the same position
	var smaller: bool = true
	for similarSpot: Array in sameTargetArray:
		if similarSpot[1][0] == attemptAdd[1][0]: continue
		
		var extraPaths: Array = []
		
		for focusPath: String in similarSpot[1]:
			var focusLength: int = get_path_length(focusPath)
			for path: String in attemptAdd[1]:
				var pathLength: int = get_path_length(path)
				if path == focusPath:
					smaller = false
				
				if focusLength < pathLength:
					smaller = false

				elif focusLength == pathLength:
					smaller = false
					
					# we use a separate array to avoid a loop in continuously adding paths to iterate over
					extraPaths.append_array(attemptAdd[1])
				if !smaller: break
		similarSpot[1].append_array(extraPaths)

	# clears previously defined spots if another node encounters them and has a lower score going into that spot
	if smaller:
		for spot: Array in sameTargetArray:
			for yOff: int in range(-1, 2):
				for xOff: int in range(-1, 2):
					var offsetSpot: Vector2i = Vector2i(spot[0].x + xOff, spot[0].y + yOff)
					if abs(yOff) != abs(xOff) and visitedSpots.has(offsetSpot):
						visitedSpots.erase(offsetSpot)
						unvisitedSpots.get_or_add(offsetSpot, INF)
			
			masterArr.erase(spot)
		masterArr.append(attemptAdd)
	
		var noDupPaths: Dictionary = {}
		for path: String in attemptAdd[1]:
			noDupPaths.get_or_add(path)
		attemptAdd[1] = noDupPaths.keys()
	
	return smaller

func solve1(input: String) -> int:
	return 0
	var solution: int = 0
	
	var grid: Array = []
	
	for row in input.split("\n"):
		if row == "": continue
		grid.append(row.split(""))
	
	unvisitedSpots = {}
	visitedSpots = {}
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
	#print(totalSpots)
	var spotsChecked: int = 0
	
	var hasSearchable: bool = true
	
	var possiblePaths: Dictionary = {}
	var spotsToVisit: Array = []
	spotsToVisit.append([startPos, [">"]])
	
	# available connections loop
	while spotsToVisit.size() != 0:
		#print("{percent}%".format({"percent": "%4.2f" % (spotsChecked*100.0/totalSpots)}))
		#print("Spots to check: %d" % spotsToVisit.size())
		#print("Spots checked: %d" % spotsChecked)
		
		# grab minimum score path
		var focusSpot: Array
		if spotsToVisit.size() == 1:
			focusSpot = spotsToVisit[0]
		else: 
			focusSpot = spotsToVisit.reduce(func(min, spot): return spot if get_path_length(spot[1][0]) < get_path_length(min[1][0]) else min)
		
		#print(spotsToVisit)
		#print(focusSpot)
		#print()
		
		# apply paths
		if focusSpot[0] == finishPos:
			for path: String in focusSpot[1]:
				possiblePaths.get_or_add(path)
			spotsToVisit.erase(focusSpot)
			continue
		
		# neighbor checks
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				var offsetSpot: Vector2i = Vector2i(focusSpot[0].x + xOff, focusSpot[0].y + yOff)
				# if adjacent, is a travelable spot, and not visited yet
				if abs(yOff) != abs(xOff) and ".E".contains(grid[offsetSpot.y][offsetSpot.x]) and unvisitedSpots.has(offsetSpot):
					var dirVec: Vector2i = Vector2i(xOff, yOff)
					
					var dirString: String = dir_to_string(dirVec)
					
					var visitSpotPaths: Array = []
					
					var focusLength: int = get_path_length(focusSpot[1][0]+dirString)
					# check every queued spot if there is another identical spot
					for checkSpotInd: int in spotsToVisit.size():
						if spotsToVisit[checkSpotInd][0] != offsetSpot: continue
						
						var checklength: int = get_path_length(spotsToVisit[checkSpotInd][1][0])
						if focusLength < checklength:
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							spotsToVisit[checkSpotInd][1] = visitSpotPaths
						elif focusLength == checklength:
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							spotsToVisit[checkSpotInd][1].append_array(visitSpotPaths)
						#print(spotsToVisit)
						continue
					
					# if visitSpotPaths wasn't defined earlier, do so now
					if visitSpotPaths.is_empty():
						visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
					
					
					add_if_lowest(spotsToVisit, [offsetSpot, visitSpotPaths])
					#spotsToVisit.append([offsetSpot, visitSpotPaths])
		
		# clearing current node from unvisiteds and prep for next node
		visitedSpots.get_or_add(focusSpot[0], focusSpot[1])
		unvisitedSpots.erase(focusSpot[0])
		spotsToVisit.erase(focusSpot)
		spotsChecked += 1
	
	var pathScores: Array[int] = []
	for path: String in possiblePaths:
		#print(path)
		var pathScore: int = get_path_length(path)
		#print(pathScore)
		pathScores.append(pathScore)
	
	solution = pathScores.min()
	
	return solution


# Not gonna leave another method for this. Worked too long on this to refactor nicely
func solve2(input: String) -> int:
	var solution: int = 0
	
	var grid: Array = []
	
	for row in input.split("\n"):
		if row == "": continue
		grid.append(row.split(""))
	
	unvisitedSpots = {}
	visitedSpots = {}
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
	#print(totalSpots)
	var spotsChecked: int = 0
	
	var hasSearchable: bool = true
	
	var possiblePaths: Dictionary = {}
	var spotsToVisit: Array = []
	spotsToVisit.append([startPos, [">"]])
	
	# available connections loop
	while spotsToVisit.size() != 0:
		print("{percent}%".format({"percent": "%4.2f" % (spotsChecked*100.0/totalSpots)}))
		print("Spots to check: %d" % spotsToVisit.size())
		print("Spots checked: %d" % spotsChecked)
		
		# grab minimum score path
		var focusSpot: Array
		if spotsToVisit.size() == 1:
			focusSpot = spotsToVisit[0]
		else: 
			focusSpot = spotsToVisit.reduce(func(min, spot): return spot if get_path_length(spot[1][0]) < get_path_length(min[1][0]) else min)
		
		#print(spotsToVisit)
		#print(focusSpot)
		#print()
		
		# apply paths
		if focusSpot[0] == finishPos:
			for path: String in focusSpot[1]:
				possiblePaths.get_or_add(path)
			spotsToVisit.erase(focusSpot)
			continue
		
		# neighbor checks
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				var offsetSpot: Vector2i = Vector2i(focusSpot[0].x + xOff, focusSpot[0].y + yOff)
				# if adjacent, is a travelable spot, and not visited yet
				if abs(yOff) != abs(xOff) and ".E".contains(grid[offsetSpot.y][offsetSpot.x]) and unvisitedSpots.has(offsetSpot):
					var dirVec: Vector2i = Vector2i(xOff, yOff)
					
					var dirString: String = dir_to_string(dirVec)
					
					var visitSpotPaths: Array = []
					
					var focusLength: int = get_path_length(focusSpot[1][0]+dirString)
					# check every queued spot if there is another identical spot
					for checkSpotInd: int in spotsToVisit.size():
						if spotsToVisit[checkSpotInd][0] != offsetSpot: continue
						
						var checklength: int = get_path_length(spotsToVisit[checkSpotInd][1][0])
						if focusLength < checklength:
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							spotsToVisit[checkSpotInd][1] = visitSpotPaths
						elif focusLength == checklength:
							visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
							spotsToVisit[checkSpotInd][1].append_array(visitSpotPaths)
						#print(spotsToVisit)
						continue
					
					# if visitSpotPaths wasn't defined earlier, do so now
					if visitSpotPaths.is_empty():
						visitSpotPaths = increment_path_list(focusSpot[1], dirVec)
					
					
					add_if_lowest(spotsToVisit, [offsetSpot, visitSpotPaths])
					#spotsToVisit.append([offsetSpot, visitSpotPaths])
		
		# clearing current node from unvisiteds and prep for next node
		visitedSpots.get_or_add(focusSpot[0], focusSpot[1])
		unvisitedSpots.erase(focusSpot[0])
		spotsToVisit.erase(focusSpot)
		spotsChecked += 1
	
	var pathScores: Array[int] = []
	var paths: PackedStringArray = []
	var bestPaths: PackedStringArray = []
	for path: String in possiblePaths:
		#print(path)
		var pathScore: int = get_path_length(path)
		#print(pathScore)
		pathScores.append(pathScore)
		paths.append(path)
	
	var pathMin: int = pathScores.min()
	
	for scoreInd: int in pathScores.size():
		if pathScores[scoreInd] == pathMin:
			bestPaths.append(paths[scoreInd])
	
	var spotsVisitedInBestPaths: Dictionary = {}
	for path: String in bestPaths:
		var pos: Vector2i = startPos - Vector2i(1, 0)
		for char: String in path:
			pos += string_to_dir(char)
			spotsVisitedInBestPaths.get_or_add(pos)
	
	print(spotsVisitedInBestPaths)
	
	solution = spotsVisitedInBestPaths.keys().size()
	
	return solution
