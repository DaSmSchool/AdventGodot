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

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var v1: Vector2i = Vector2i.LEFT
	var v2: Vector2i = Vector2i.UP
	print(v1)
	print(v2)
	print(rad_to_deg(atan2(v1.y, v1.x) - atan2(v2.y, v2.x)))
	
	var v3: Vector2i = Vector2i.DOWN
	var v4: Vector2i = Vector2i.RIGHT
	print(v3)
	print(v4)
	print(fmod(360 + rad_to_deg(atan2(v3.y, v3.x) - atan2(v4.y, v4.x)), 360))
	
	return solution
