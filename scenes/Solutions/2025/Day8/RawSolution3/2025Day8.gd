extends Solution

func parse_input(inputSplit: PackedStringArray) -> Array[Vector3i]:
	var pointArr: Array[Vector3i]
	for line: String in inputSplit:
		var lineSplit: Array = Array(line.split(",")).map(func(s): return int(s))
		var pointAssemble: Vector3i = Vector3i(lineSplit[0], lineSplit[1], lineSplit[2])
		pointArr.append(pointAssemble)
	return pointArr



func make_possible_connections(singlePoints: Array[Vector3i]) -> Dictionary[Array, int]:
	var possibleConnections: Dictionary[Array, int] = {}
	#print("#########")
	#var testArr: Array = []
	for vec1: Vector3i in singlePoints:
		for vec2: Vector3i in singlePoints:
			if vec1 == vec2: continue
			if not possibleConnections.has([vec2, vec1]) and not possibleConnections.has([vec1, vec2]):
				possibleConnections[[vec1, vec2]] = vec1.distance_squared_to(vec2)
				#if vec1.x == 862 or vec2.x == 862:
					#testArr.append([vec1, vec2, vec1.distance_squared_to(vec2)])
	#for link: Array in testArr:
		#print(link)
	#print("#########")
	return possibleConnections

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var singlePoints: Array[Vector3i] = parse_input(inputSplit)
	#print(singlePoints)
	
	var possibleConnections: Dictionary[Array, int] = make_possible_connections(singlePoints)
	#Helper.print_dict(possibleConnections)
	var tempKeys: Array = possibleConnections.keys()
	var tempValues: Array = possibleConnections.values()
	var tempValuesSorted: Array = tempValues.duplicate()
	tempValuesSorted.sort()
	var tempMax: int = tempValues.size()
	var circuits: Array[Array] = []
	
	var maxIter: int = 1000
	var currIter: int = 0
	
	while tempValues.size() != 0 and currIter < maxIter:
		#print_log(tempValues.size()/float(tempMax))
		currIter += 1
		var valMin: int = tempValues.min()
		var valMinInd: int = tempValues.find(valMin)
		var nodeConnection: Array = tempKeys[valMinInd]
		
		var hasP1: bool = false
		var hasP2: bool = false
		var madeCircuit: Array = []
		for circuit: Array in circuits:
			hasP1 = false
			hasP2 = false
			if circuit.has(nodeConnection[0]):
				hasP1 = true
			if circuit.has(nodeConnection[1]):
				hasP2 = true
			if hasP1 and not hasP2:
				for subcircuit: Array in circuits:
					if subcircuit.has(nodeConnection[1]):
						circuit.append_array(subcircuit)
						circuits.erase(subcircuit)
						circuit.erase(nodeConnection[1])
				circuit.append(nodeConnection[1])
				
				singlePoints.erase(nodeConnection[1])
				madeCircuit = circuit
				break
			elif not hasP1 and hasP2:
				for subcircuit: Array in circuits:
					if subcircuit.has(nodeConnection[0]):
						circuit.append_array(subcircuit)
						circuits.erase(subcircuit)
						circuit.erase(nodeConnection[0])
				circuit.append(nodeConnection[0])
				singlePoints.erase(nodeConnection[0])
				madeCircuit = circuit
				break
			elif hasP1 and hasP2:
				break
		if not hasP1 and not hasP2:
			madeCircuit = [nodeConnection[0], nodeConnection[1]]
			singlePoints.erase(nodeConnection[0])
			singlePoints.erase(nodeConnection[1])
			circuits.append(madeCircuit)
		#print(str(nodeConnection) + " : " + str(hasP1) + ", " + str(hasP2) + " : " + str(valMin) + " : " + str(valMinInd) + " : " + str(singlePoints.size()) + " : \n" + str(madeCircuit))
		tempValues.remove_at(valMinInd)
		tempKeys.remove_at(valMinInd)
		
	#for circuit: Array in circuits:
		#print_log(str(circuit.size()) + " : " + str(circuit))
	
	var circuitLens: Array = circuits.map(func(s): return s.size())
	solution *= circuitLens.max()
	circuitLens.erase(circuitLens.max())
	solution *= circuitLens.max()
	circuitLens.erase(circuitLens.max())
	solution *= circuitLens.max()
	circuitLens.erase(circuitLens.max())
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = -1
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var singlePoints: Array[Vector3i] = parse_input(inputSplit)
	var permanentSinglePoints: Array[Vector3i] = singlePoints.duplicate()
	#print(singlePoints)
	
	var possibleConnections: Dictionary[Array, int] = make_possible_connections(singlePoints)
	#Helper.print_dict(possibleConnections)
	var tempKeys: Array = possibleConnections.keys()
	var tempValues: Array = possibleConnections.values()
	var tempValuesSorted: Array = tempValues.duplicate()
	tempValuesSorted.sort()
	var tempMax: int = tempValues.size()
	var circuits: Array[Array] = []
	
	while tempValues.size() != 0 and solution == -1:
		var valMin: int = tempValues.min()
		var valMinInd: int = tempValues.find(valMin)
		var nodeConnection: Array = tempKeys[valMinInd]
		
		if nodeConnection[0].x == 216 and nodeConnection[1].x == 117:
			pass
		
		var hasP1: bool = false
		var hasP2: bool = false
		var madeCircuit: Array = []
		for circuit: Array in circuits:
			hasP1 = false
			hasP2 = false
			if circuit.has(nodeConnection[0]):
				hasP1 = true
			if circuit.has(nodeConnection[1]):
				hasP2 = true
			if hasP1 and not hasP2:
				for subcircuit: Array in circuits:
					if subcircuit.has(nodeConnection[1]):
						circuit.append_array(subcircuit)
						circuits.erase(subcircuit)
						circuit.erase(nodeConnection[1])
						
				circuit.append(nodeConnection[1])
				singlePoints.erase(nodeConnection[1])
				madeCircuit = circuit
				if circuit.size() == permanentSinglePoints.size():
					print(str(nodeConnection[0].x) + " * " + str(nodeConnection[1].x))
					solution = nodeConnection[0].x * nodeConnection[1].x
				break
			elif not hasP1 and hasP2:
				for subcircuit: Array in circuits:
					if subcircuit.has(nodeConnection[0]):
						circuit.append_array(subcircuit)
						circuits.erase(subcircuit)
						circuit.erase(nodeConnection[0])
						
				circuit.append(nodeConnection[0])
				singlePoints.erase(nodeConnection[0])
				madeCircuit = circuit
				if circuit.size() == permanentSinglePoints.size():
					print(str(nodeConnection[0].x) + " * " + str(nodeConnection[1].x))
					solution = nodeConnection[0].x * nodeConnection[1].x
				break
			elif hasP1 and hasP2:
				break
		if not hasP1 and not hasP2:
			madeCircuit = [nodeConnection[0], nodeConnection[1]]
			singlePoints.erase(nodeConnection[0])
			singlePoints.erase(nodeConnection[1])
			circuits.append(madeCircuit)
		#print(str(nodeConnection) + " : " + str(hasP1) + ", " + str(hasP2) + " : " + str(valMin) + " : " + str(valMinInd) + " : " + str(singlePoints.size()) + " : \n" + str(madeCircuit))
		tempValues.remove_at(valMinInd)
		tempKeys.remove_at(valMinInd)
		
		
	#for circuit: Array in circuits:
		#print_log(str(circuit.size()) + " : " + str(circuit))
	
	return solution
