extends Solution

func find_silly_ids_p1(idStart: int, idEnd: int) -> int:
	var idSum: int = 0
	
	for id: int in range(idStart, idEnd+1):
		var idStr: String = str(id)
		var idLength: int = idStr.length()
		var firstHalf: String = idStr.substr(0, idLength/2)
		var secondHalf: String = idStr.substr(idLength/2)
		if firstHalf == secondHalf:
			idSum += id
	
	return idSum

func find_silly_ids_p2(idStart: int, idEnd: int) -> int:
	var idSum: int = 0
	
	for id: int in range(idStart, idEnd+1):
		var idStr: String = str(id)
		var idLength: int = idStr.length()
		if idLength == 1: continue
		for splitDivisions: int in range(2, idLength+1):
			var lengthSegment: float = idLength/float(splitDivisions)
			if lengthSegment == int(lengthSegment):
				var comparisonRepeat: String = idStr.substr(0, lengthSegment)
				if idStr.count(comparisonRepeat) == splitDivisions:
					#print_log(str(id) + " : " + str(comparisonRepeat) + " : " + str(idStr.count(comparisonRepeat)))
					idSum += id
					break
	
	return idSum

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var rangesSplit: PackedStringArray = input.split(",", false)
	for rawRange: String in rangesSplit:
		var splitRawRange: PackedStringArray = rawRange.split("-")
		solution += find_silly_ids_p1(splitRawRange[0].to_int(), splitRawRange[1].to_int())
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var rangesSplit: PackedStringArray = input.split(",", false)
	for rawRange: String in rangesSplit:
		var splitRawRange: PackedStringArray = rawRange.split("-")
		solution += find_silly_ids_p2(splitRawRange[0].to_int(), splitRawRange[1].to_int())
	
	return solution
