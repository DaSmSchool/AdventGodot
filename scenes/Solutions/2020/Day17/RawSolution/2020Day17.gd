extends Solution

	
#region Solution 1
func pocket_dim_has_cube_in_position_p1(pocketDim: Dictionary, position: Vector3i) -> bool:
	if not pocketDim.has(position.x): return false
	if not pocketDim[position.x].has(position.y): return false
	if not pocketDim[position.x][position.y].has(position.z): return false
	return pocketDim[position.x][position.y][position.z]

func pocket_dim_set_cube_in_position_p1(pocketDim: Dictionary, position: Vector3i, enabled: bool) -> void:
	if not pocketDim.has(position.x): pocketDim[position.x] = {}
	if not pocketDim[position.x].has(position.y): pocketDim[position.x][position.y] = {}
	pocketDim[position.x][position.y][position.z] = enabled

func get_enabled_cube_positions_p1(pocketDim: Dictionary) -> Array:
	var cubePositions: Array = []
	
	for xPos: int in pocketDim.keys():
		for yPos: int in pocketDim[xPos].keys():
			for zPos: int in pocketDim[xPos][yPos].keys():
				if pocketDim[xPos][yPos][zPos] == true: cubePositions.append(Vector3i(xPos, yPos, zPos))
	
	return cubePositions

func get_cube_vicinity_positions_p1(cubePositions: Array) -> Dictionary:
	var checkPostitions: Dictionary = {}
	
	for cubePos: Vector3i in cubePositions:
		for xPosOff: int in range(-1, 2):
			for yPosOff: int in range(-1, 2):
				for zPosOff: int in range(-1, 2):
					var checkPosition: Vector3i = Vector3i(cubePos.x+xPosOff, cubePos.y+yPosOff, cubePos.z+zPosOff)
					checkPostitions[checkPosition] = true
	
	return checkPostitions

func get_pocket_dim_neighbor_count_at_position_p1(pocketDim: Dictionary, position: Vector3i) -> int:
	var neighborCount: int = 0
	for xPosOff: int in range(-1, 2):
		for yPosOff: int in range(-1, 2):
			for zPosOff: int in range(-1, 2):
				if xPosOff == 0 and yPosOff == 0 and zPosOff == 0: continue
				var checkPosition: Vector3i = Vector3i(position.x+xPosOff, position.y+yPosOff, position.z+zPosOff)
				if pocket_dim_has_cube_in_position_p1(pocketDim, checkPosition): 
					checkPosition = Vector3i()
					neighborCount += 1
	return neighborCount

func get_pocket_bounds_p1(pocketDim: Dictionary) -> Dictionary:
	var boundsDict: Dictionary = {
		"minX" : 0,
		"maxX" : 0,
		"minY" : 0,
		"maxY" : 0,
		"minZ" : 0,
		"maxZ" : 0,
	}
	
	var xList: Array = pocketDim.keys()
	boundsDict["minX"] = xList.min()
	boundsDict["maxX"] = xList.max()
	for xSearch: int in xList:
		var yDims: Dictionary = pocketDim[xSearch]
		var yList: Array = yDims.keys()
		if boundsDict["minY"] > yList.min(): boundsDict["minY"] = yList.min()
		if boundsDict["maxY"] < yList.max(): boundsDict["maxY"] = yList.max()
		for ySearch: int in yList:
			var zDims: Dictionary = pocketDim[xSearch][ySearch]
			var zList: Array = zDims.keys()
			if boundsDict["minZ"] > zList.min(): boundsDict["minZ"] = zList.min()
			if boundsDict["maxZ"] < zList.max(): boundsDict["maxZ"] = zList.max()
	
	return boundsDict

func print_pocket_dim_p1(pocketDim: Dictionary) -> void:
	var boundsDict: Dictionary = get_pocket_bounds_p1(pocketDim)
	
	for layer: int in range(boundsDict["minZ"], boundsDict["maxZ"]+1):
		print("LAYER " + str(layer))
		for row: int in range(boundsDict["minY"], boundsDict["maxY"]+1):
			var printString: String = ""
			for col: int in range(boundsDict["minX"], boundsDict["maxX"]+1):
				if pocket_dim_has_cube_in_position_p1(pocketDim, Vector3i(col, row, layer)):
					printString += "#"
				else:
					printString += "."
			print(printString)
		print()

func solve1(input: String) -> int:
	var solution: int = 0
	var inputSplit: PackedStringArray = input.split("\n")
	
	var pocketDimDict: Dictionary = {}
	for row: int in inputSplit.size()-1:
		for col: int in inputSplit[row].length():
			if inputSplit[row][col] == "#": pocket_dim_set_cube_in_position_p1(pocketDimDict, Vector3i(col, row, 0), true)
	
	print_pocket_dim_p1(pocketDimDict)
	for key in pocketDimDict.keys():
		print(str(key) + " : " + str(pocketDimDict[key]))
	#print(pocketDimDict)
	
	var cycles: int = 6
	for cycle: int in cycles:
		print("CYCLE" + str(cycle + 1))
		var newPocketDimDict: Dictionary = {}
		var enabledPositions: Array = get_enabled_cube_positions_p1(pocketDimDict)
		var checkPositions: Dictionary = get_cube_vicinity_positions_p1(enabledPositions)
		for checkPosition: Vector3i in checkPositions.keys():
			var neighborCount: int = get_pocket_dim_neighbor_count_at_position_p1(pocketDimDict, checkPosition)
			if pocket_dim_has_cube_in_position_p1(pocketDimDict, checkPosition):
				var stayEnabled: bool = neighborCount == 2 or neighborCount == 3
				pocket_dim_set_cube_in_position_p1(newPocketDimDict, checkPosition, stayEnabled)
			else:
				var stayEnabled: bool = neighborCount == 3
				pocket_dim_set_cube_in_position_p1(newPocketDimDict, checkPosition, stayEnabled)
		
		pocketDimDict = newPocketDimDict
		print_pocket_dim_p1(pocketDimDict)
	
	solution = get_enabled_cube_positions_p1(pocketDimDict).size()
	
	return solution
#endregion

#region Solution 2
func pocket_dim_has_cube_in_position_p2(pocketDim: Dictionary, position: Vector4i) -> bool:
	if not pocketDim.has(position.x): return false
	if not pocketDim[position.x].has(position.y): return false
	if not pocketDim[position.x][position.y].has(position.z): return false
	if not pocketDim[position.x][position.y][position.z].has(position.w): return false
	return pocketDim[position.x][position.y][position.z][position.w]

func pocket_dim_set_cube_in_position_p2(pocketDim: Dictionary, position: Vector4i, enabled: bool) -> void:
	if not pocketDim.has(position.x): pocketDim[position.x] = {}
	if not pocketDim[position.x].has(position.y): pocketDim[position.x][position.y] = {}
	if not pocketDim[position.x][position.y].has(position.z): pocketDim[position.x][position.y][position.z] = {}
	pocketDim[position.x][position.y][position.z][position.w] = enabled

func get_enabled_cube_positions_p2(pocketDim: Dictionary) -> Array:
	var cubePositions: Array = []
	
	for xPos: int in pocketDim.keys():
		for yPos: int in pocketDim[xPos].keys():
			for zPos: int in pocketDim[xPos][yPos].keys():
				for wPos: int in pocketDim[xPos][yPos][zPos].keys():
					if pocketDim[xPos][yPos][zPos][wPos] == true: cubePositions.append(Vector4i(xPos, yPos, zPos, wPos))
	
	return cubePositions

func get_cube_vicinity_positions_p2(cubePositions: Array) -> Dictionary:
	var checkPostitions: Dictionary = {}
	
	for cubePos: Vector4i in cubePositions:
		for xPosOff: int in range(-1, 2):
			for yPosOff: int in range(-1, 2):
				for zPosOff: int in range(-1, 2):
					for wPosOff: int in range(-1, 2):
						var checkPosition: Vector4i = Vector4i(cubePos.x+xPosOff, cubePos.y+yPosOff, cubePos.z+zPosOff, cubePos.w+wPosOff)
						checkPostitions[checkPosition] = true
	
	return checkPostitions

func get_pocket_dim_neighbor_count_at_position_p2(pocketDim: Dictionary, position: Vector4i) -> int:
	var neighborCount: int = 0
	for xPosOff: int in range(-1, 2):
		for yPosOff: int in range(-1, 2):
			for zPosOff: int in range(-1, 2):
				for wPosOff: int in range(-1, 2):
					if xPosOff == 0 and yPosOff == 0 and zPosOff == 0 and wPosOff == 0: continue
					var checkPosition: Vector4i = Vector4i(position.x+xPosOff, position.y+yPosOff, position.z+zPosOff, position.w+wPosOff)
					if pocket_dim_has_cube_in_position_p2(pocketDim, checkPosition): 
						checkPosition = Vector4i()
						neighborCount += 1
	return neighborCount

func get_pocket_bounds_p2(pocketDim: Dictionary) -> Dictionary:
	var boundsDict: Dictionary = {
		"minX" : 0,
		"maxX" : 0,
		"minY" : 0,
		"maxY" : 0,
		"minZ" : 0,
		"maxZ" : 0,
		"minW" : 0,
		"maxW" : 0,
	}
	
	var xList: Array = pocketDim.keys()
	boundsDict["minX"] = xList.min()
	boundsDict["maxX"] = xList.max()
	for xSearch: int in xList:
		var yDims: Dictionary = pocketDim[xSearch]
		var yList: Array = yDims.keys()
		if boundsDict["minY"] > yList.min(): boundsDict["minY"] = yList.min()
		if boundsDict["maxY"] < yList.max(): boundsDict["maxY"] = yList.max()
		for ySearch: int in yList:
			var zDims: Dictionary = pocketDim[xSearch][ySearch]
			var zList: Array = zDims.keys()
			if boundsDict["minZ"] > zList.min(): boundsDict["minZ"] = zList.min()
			if boundsDict["maxZ"] < zList.max(): boundsDict["maxZ"] = zList.max()
			for zSearch: int in zList:
				var wDims: Dictionary = pocketDim[xSearch][ySearch][zSearch]
				var wList: Array = wDims.keys()
				if boundsDict["minW"] > wList.min(): boundsDict["minW"] = wList.min()
				if boundsDict["maxW"] < wList.max(): boundsDict["maxW"] = wList.max()
	
	return boundsDict

func print_pocket_dim_p2(pocketDim: Dictionary) -> void:
	var boundsDict: Dictionary = get_pocket_bounds_p2(pocketDim)
	
	for wLayer: int in range(boundsDict["minW"], boundsDict["maxW"]+1):
		for layer: int in range(boundsDict["minZ"], boundsDict["maxZ"]+1):
			print("WLAYER " + str(wLayer) + ", LAYER " + str(layer))
			for row: int in range(boundsDict["minY"], boundsDict["maxY"]+1):
				var printString: String = ""
				for col: int in range(boundsDict["minX"], boundsDict["maxX"]+1):
					if pocket_dim_has_cube_in_position_p2(pocketDim, Vector4i(col, row, layer, wLayer)):
						printString += "#"
					else:
						printString += "."
				print(printString)
			print()

func solve2(input: String) -> int:
	var solution: int = 0
	var inputSplit: PackedStringArray = input.split("\n")
	
	var pocketDimDict: Dictionary = {}
	for row: int in inputSplit.size()-1:
		for col: int in inputSplit[row].length():
			if inputSplit[row][col] == "#": pocket_dim_set_cube_in_position_p2(pocketDimDict, Vector4i(col, row, 0, 0), true)
	
	print_pocket_dim_p2(pocketDimDict)
	for key in pocketDimDict.keys():
		print(str(key) + " : " + str(pocketDimDict[key]))
	#print(pocketDimDict)
	
	var cycles: int = 6
	for cycle: int in cycles:
		print("CYCLE" + str(cycle + 1))
		var newPocketDimDict: Dictionary = {}
		var enabledPositions: Array = get_enabled_cube_positions_p2(pocketDimDict)
		var checkPositions: Dictionary = get_cube_vicinity_positions_p2(enabledPositions)
		for checkPosition: Vector4i in checkPositions.keys():
			var neighborCount: int = get_pocket_dim_neighbor_count_at_position_p2(pocketDimDict, checkPosition)
			if pocket_dim_has_cube_in_position_p2(pocketDimDict, checkPosition):
				var stayEnabled: bool = neighborCount == 2 or neighborCount == 3
				pocket_dim_set_cube_in_position_p2(newPocketDimDict, checkPosition, stayEnabled)
			else:
				var stayEnabled: bool = neighborCount == 3
				pocket_dim_set_cube_in_position_p2(newPocketDimDict, checkPosition, stayEnabled)
		
		pocketDimDict = newPocketDimDict
		print_pocket_dim_p2(pocketDimDict)
	
	solution = get_enabled_cube_positions_p2(pocketDimDict).size()
	
	return solution
#endregion
