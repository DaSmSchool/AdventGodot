extends Solution

func parse_input(input: String, jBoxList: Array[Vector3i]) -> void:
	for line: String in input.split("\n", false):
		var lineParts: Array = Array(line.split(",")).map(func(s): return int(s))
		jBoxList.append(Vector3i(lineParts[0], lineParts[1], lineParts[2],))

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var singleJBoxList: Array[Vector3i] = []
	parse_input(input, singleJBoxList)
	
	var distancesArray: Array = []
	
	for jBoxInd: int in singleJBoxList.size():
		var jBox: Vector3i = singleJBoxList[jBoxInd]
		var distanceList: Array = singleJBoxList.map(func(s): return jBox.distance_to(s))
		distanceList[jBoxInd] = 1_000_000_000
		distancesArray.append(distanceList)
	
	
	var circuitArray: Array = []
	
	var iterSingleJBoxList: Array = singleJBoxList.duplicate()
	
	var iterMax: int = 10
	var iterInd: int = 0
	while iterSingleJBoxList.size() != 0 and iterInd < iterMax:
		var focusJIterBox: Vector3i = iterSingleJBoxList[iterInd]
		if focusJIterBox not in singleJBoxList:
			iterInd += 1
			continue
		var focusJBox: Vector3i = singleJBoxList[iterInd]
		var focusDistanceList: Array = distancesArray[iterInd]
		var smallestSingleDistance: float = focusDistanceList.min()
		var smallestSingleDistanceInd: int = focusDistanceList.find(smallestSingleDistance)
		print(smallestSingleDistance)
		print(smallestSingleDistanceInd)
		pass
		var smallestCircuitInd: int = -1
		var smallestCircuitIndInd: int = -1
		var smallestCircuitDistance: float = 1_000_000
		
		for circuitInd: int in circuitArray.size():
			var circuitArr: Array = circuitArray[circuitInd]
			var distanceToFocusList: Array = circuitArr.map(func(s): return focusJBox.distance_to(s))
			var minimumCircuitDistance: float = distanceToFocusList.min()
			var minimumCircuitDistanceInd: int = focusDistanceList.find(distanceToFocusList.min())
			if smallestCircuitInd == -1 or min(minimumCircuitDistance, smallestCircuitDistance) == minimumCircuitDistance:
				smallestCircuitInd = circuitInd
				smallestCircuitIndInd = minimumCircuitDistanceInd
				smallestCircuitDistance = minimumCircuitDistance
		
		if smallestSingleDistance < smallestCircuitDistance:
			var newCircuit: Array = [focusJBox, singleJBoxList[smallestSingleDistanceInd]]
			
			print(newCircuit)
			print()
			circuitArray.append(newCircuit)
			distancesArray.remove_at(smallestSingleDistanceInd)
			for distanceArr: Array in distancesArray:
				distanceArr.remove_at(smallestSingleDistanceInd)
			singleJBoxList.remove_at(smallestSingleDistanceInd)
			
			#var newCircuit: Array = [focusJBox]
			#
			#circuitArray.append(newCircuit)
			
		else:
			circuitArray[smallestCircuitInd].append(focusJBox)
			
		distancesArray.remove_at(iterInd)
		for distanceArr: Array in distancesArray:
			distanceArr.remove_at(iterInd)
		singleJBoxList.remove_at(iterInd)
		
		iterInd += 1
	
	print_log()
	print_log("CIRCUITS: ")
	for circuitArr: Array in circuitArray:
		print_log(circuitArr)
	
	var circuitSizes: Array = circuitArray.map(func(s): return s.size())
	
	solution *= circuitSizes.max()
	circuitSizes.erase(circuitSizes.max())
	solution *= circuitSizes.max()
	circuitSizes.erase(circuitSizes.max())
	solution *= circuitSizes.max()
	circuitSizes.erase(circuitSizes.max())
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
