extends Solution

func find_silly_ids_p1(idStart: int, idEnd: int) -> Array:
	var idArray: Array = []
	
	for id: int in range(idStart, idEnd+1):
		var idStr: String = str(id)
		var idLength: int = idStr.length()
		var firstHalf: String = idStr.substr(0, idLength/2)
		var secondHalf: String = idStr.substr(idLength/2)
		if firstHalf == secondHalf:
			idArray.append(id)
	
	return idArray

func find_silly_ids_p2(idStart: int, idEnd: int) -> Array:
	var idArray: Array = []
	
	for id: int in range(idStart, idEnd+1):
		var idStr: String = str(id)
		var idLength: int = idStr.length()
		if idLength == 1: continue
		for splitDivisions: int in range(2, idLength+1):
			var lengthSegment: float = idLength/splitDivisions
			var validSegment: bool = true
			if lengthSegment == int(lengthSegment):
				var comparisonRepeat: String = idStr.substr(0, lengthSegment)
				for focusInd: int in range(lengthSegment, idLength, lengthSegment):
					if idStr.substr(focusInd, lengthSegment).left(lengthSegment) != comparisonRepeat:
						validSegment = false
			else:
				validSegment = false
			if validSegment:
				idArray.append(id)
				break
				
	
	return idArray

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var rangesSplit: PackedStringArray = input.split(",", false)
	var rangeArray: Array = []
	for rawRange: String in rangesSplit:
		var rangeSet: Array = []
		var splitRawRange: PackedStringArray = rawRange.split("-")
		rangeSet.resize(2)
		rangeSet[0] = splitRawRange[0].to_int()
		rangeSet[1] = splitRawRange[1].to_int()
		rangeArray.append(rangeSet)
	
	var sillyIds: Array = []
	for idRange: Array in rangeArray:
		sillyIds.append_array(find_silly_ids_p1(idRange[0], idRange[1]))
	
	for sillyId: int in sillyIds:
		print_log(str(sillyId))
		solution += sillyId
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var rangesSplit: PackedStringArray = input.split(",", false)
	var rangeArray: Array = []
	for rawRange: String in rangesSplit:
		var rangeSet: Array = []
		var splitRawRange: PackedStringArray = rawRange.split("-")
		rangeSet.resize(2)
		rangeSet[0] = splitRawRange[0].to_int()
		rangeSet[1] = splitRawRange[1].to_int()
		rangeArray.append(rangeSet)
	
	var sillyIds: Array = []
	for idRange: Array in rangeArray:
		sillyIds.append_array(find_silly_ids_p2(idRange[0], idRange[1]))
	
	for sillyId: int in sillyIds:
		print_log(str(sillyId))
		solution += sillyId
	
	return solution
