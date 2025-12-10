extends Solution

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

static func rect_compare(a: Rect2i, b: Rect2i) -> bool:
	if a.get_area() > b.get_area():
		return true
	return false

func edges_in_rect(rect: Rect2i, edgeData: Array, coordList: Array[Vector2i]) -> bool:
	var shiftRect: Rect2i = rect
	
	for edge: Array in edgeData:
		var edgeDiff: Vector2i = edge[1]-edge[0]
		var edgeRect: Rect2i = Rect2i(edge[0], edgeDiff).abs()
		print("EDGE: " + str(edgeRect.position) + " : " + str(edgeRect.position+edgeRect.size))
		
		if shiftRect.intersects(edgeRect):
			print("INTERSECT?: " + str(shiftRect.intersection(edgeRect)))
			if coordList.has(shiftRect.intersection(edgeRect).position):
				pass
			else:
				print("INTERSECT!: " + str(shiftRect.intersection(edgeRect)))
				return true
	return false

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var coordList: Array[Vector2i] = parse_input(input)
	var offsetCoordList  = coordList.duplicate()
	offsetCoordList.push_front(offsetCoordList.pop_back())
	var edgeData: Array = []
	edgeData.resize(coordList.size())
	for coordInd: int in coordList.size():
		edgeData[coordInd] = [coordList[coordInd], offsetCoordList[coordInd]]
		#print_log(edgeData[coordInd])
	
	
	var possibleRectangleSet: Dictionary[Rect2i, int] = {}
	for coordInd: int in coordList.size():
		var coord: Vector2i = coordList[coordInd]
		var rectangles: Array = coordList.map(func(c): return Rect2i(coord, (c-coord)+(c-coord).sign()).abs())
		for rectangle: Rect2i in rectangles:
			if rectangle.position in coordList:
				possibleRectangleSet[rectangle] = rectangle.get_area()
	
	var sortedRects: Array = possibleRectangleSet.keys()
	sortedRects.sort_custom(rect_compare)
	
	
	for rect: Rect2i in sortedRects:
		print(str(rect) + " : " + str(rect.get_area()))
		if not edges_in_rect(rect, edgeData, coordList):
			solution = rect.get_area()
			break
	
	return solution
