extends Solution

var dirLChecks: Dictionary[Array, Array] = {
	[Vector2i.DOWN, Vector2i.RIGHT]: [[false, true], [false, false]],
	[Vector2i.DOWN, Vector2i.LEFT]: [[false, true], [true, true]],
	[Vector2i.UP, Vector2i.RIGHT]: [[true, true], [true, false]],
	[Vector2i.UP, Vector2i.LEFT]: [[false, false], [true, false]],
	[Vector2i.RIGHT, Vector2i.DOWN]: [[true, true], [false, true]],
	[Vector2i.RIGHT, Vector2i.UP]: [[true, false], [false, false]],
	[Vector2i.LEFT, Vector2i.DOWN]: [[false, false], [false, true]],
	[Vector2i.LEFT, Vector2i.UP]: [[true, false], [true, true]],
}

func parse_input(input: String) -> Array[Vector2i]:
	var coordList: Array[Vector2i] = []
	for line: String in input.split("\n", false):
		var lineSplit: PackedStringArray = line.split(",")
		coordList.append(Vector2i(lineSplit[0].to_int(), lineSplit[1].to_int()))
	return coordList

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var coordList: Array[Vector2i] = parse_input(input)
	
	var maxAreas: Array = []
	for coordInd: int in coordList.size():
		var coord: Vector2i = coordList[coordInd]
		var maxArea: Array = coordList.map(func(c): return abs((c.x-coord.x+1) * (c.y-coord.y+1)))
		#print(maxArea)
		maxAreas.append(maxArea.max())
	solution = maxAreas.max()
	
	
	return solution

# longass map functions my beloved
# just returns an array of the vector2is present in the input
func parse_points(input: String) -> Array:
	return Array(input.split("\n", false)).map(func(s): return Array(s.split(",")).map(func(c): return int(c))).map(func(v): return Vector2i(v[0], v[1]))

func get_diff_array(pointArray: Array) -> Array:
	var diffArray: Array = []
	for pointInd: int in pointArray.size():
		var offInd: int = pointInd+1
		if offInd == pointArray.size():
			offInd = 0
		var focusVec: Vector2i = pointArray[pointInd]
		var offVec: Vector2i = pointArray[offInd]
		diffArray.append(offVec-focusVec)
	return diffArray

func get_interior_direction(diffArray: Array) -> String:
	var turnString: String = ""
	for pointInd: int in diffArray.size():
		var offInd: int = pointInd-1
		if offInd == -1:
			offInd = diffArray.size()-1
		var focusVec: Vector2i = diffArray[pointInd].sign()
		var offVec: Vector2i = diffArray[offInd].sign()
		#diffArray.append(offVec-focusVec)
		var turnDegrees: float = rad_to_deg(atan2(offVec.y, offVec.x) - atan2(focusVec.y, focusVec.x))
		print(turnDegrees)
		if is_equal_approx(abs(turnDegrees), 90.0):
			turnString += "R"
		elif is_equal_approx(abs(turnDegrees), 270.0):
			turnString += "L"
	print(turnString)
	var lCount: int = turnString.count("L")
	var rCount: int = turnString.count("R")
	if lCount > rCount:
		return "L"
	else:
		return "R"

func sort_vec2i(a: Vector2i, b: Vector2i) -> bool:
	if a.x == b.x:
		if a.y < b.y:
			return true
		return false
	elif a.x < b.x:
		return true
	return false

func sorted_points(points: Array) -> Array:
	var sortPoints: Array = points.duplicate()
	sortPoints.sort_custom(sort_vec2i)
	return sortPoints

func get_quadrant_bounds(point: Vector2i, quadDir: Vector2i, pointXDict: Dictionary[int, Array], pointYDict: Dictionary[int, Array]) -> Array:
	var validXRange: Array
	var validYRange: Array
	if quadDir.x == -1:
		validXRange = [0, point.x]
	elif quadDir.x == 1:
		validXRange = [point.x, pointXDict.keys().max()]
	else:
		assert(false, "qdir invalid")
	if quadDir.y == -1:
		validYRange = [0, point.y]
	elif quadDir.y == 1:
		validYRange = []
	else:
		assert(false, "qdir invalid")
	return [validXRange, validYRange]

func num_in_bounds(num: int, bounds: Array) -> bool:
	return bounds[0] <= num and num <= bounds[1]

func get_largest_area_from_point_towards_quadrant(point: Vector2i, quadDir: Vector2i, pointXDict: Dictionary[int, Array], pointYDict: Dictionary[int, Array]) -> int:
	var manipXDict: Dictionary[int, Array] = pointXDict.duplicate(true)
	var manipYDict: Dictionary[int, Array] = pointYDict.duplicate(true)
	var maxArea: int = 0
	var qBounds: Array = get_quadrant_bounds(point, quadDir, pointXDict, pointYDict)
	for xKey: int in pointXDict:
		if not num_in_bounds(xKey, qBounds[0]):
			manipXDict.erase(xKey)
		else:
			for yKey: int in pointXDict[xKey]:
				if not num_in_bounds(yKey, qBounds[1]):
					manipXDict[xKey].erase(yKey)
	
	for xKeyInd: int in manipXDict.size():
		pass
	
	return maxArea

func check_quadrants_against_point(point: Vector2i, validQuadrants: Array, pointXDict: Dictionary[int, Array], pointYDict: Dictionary[int, Array]) -> int:
	var maxArea: int = 0
	var validQuadDirs: Array = []
	for quadRowInd: int in 2:
		for quadColInd: int in 2:
			if validQuadrants[quadRowInd][quadColInd]:
				validQuadDirs.append(2*Vector2i(quadColInd, quadRowInd)-Vector2i.ONE)
	print(str(point) + " : " + str(validQuadDirs))
	for quadDir: Vector2i in validQuadDirs:
		maxArea = max(maxArea, get_largest_area_from_point_towards_quadrant(point, quadDir, pointXDict, pointYDict))
	
	return maxArea

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var pointArray: Array = parse_points(input)
	var sortedPointArray: Array = sorted_points(pointArray)
	var diffArray: Array = get_diff_array(pointArray)
	
	var interiorDirection: String = get_interior_direction(diffArray)
	
	var pointXDict: Dictionary[int, Array] = {}
	var pointYDict: Dictionary[int, Array] = {}
	
	for point: Vector2i in sortedPointArray:
		if not pointXDict.has(point.x):
			pointXDict[point.x] = []
		if not pointYDict.has(point.y):
			pointYDict[point.y] = []
		pointXDict[point.x].append(point.y)
		pointYDict[point.y].append(point.x)
	pointYDict.sort()
	
	Helper.print_dict(pointXDict)
	print()
	Helper.print_dict(pointYDict)
	print(pointArray)
	print(diffArray)

	for pointInd: int in diffArray.size():
		var offInd: int = pointInd-1
		if offInd == -1:
			offInd = diffArray.size()-1
		var focusVec: Vector2i = diffArray[pointInd].sign()
		var offVec: Vector2i = diffArray[offInd].sign()
		var validQuadrants: Array = dirLChecks[[offVec, focusVec]].duplicate(true)
		# invert valid quadrants if direction isn't L
		if interiorDirection == "R":
			validQuadrants = validQuadrants.map(func(r): return r.map(func(c): return not c))
		
		var pointMax: int = check_quadrants_against_point(pointArray[pointInd], validQuadrants, pointXDict, pointYDict)
	
	return solution
