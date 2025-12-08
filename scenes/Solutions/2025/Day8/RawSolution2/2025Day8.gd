extends Solution

func parse_input(inputSplit: PackedStringArray) -> Array[Vector3i]:
    var pointArr: Array[Vector3i]
    for line: String in inputSplit:
        var lineSplit: Array = Array(line.split(",")).map(func(s): return int(s))
        var pointAssemble: Vector3i = Vector3i(lineSplit[0], lineSplit[1], lineSplit[2])
        pointArr.append(pointAssemble)
    return pointArr

func make_possible_connections(singlePoints: Array[Vector3i]) -> Dictionary[Array, float]:
    var possibleConnections: Dictionary[Array, float] = {}
    for vec1: Vector3i in singlePoints:
        for vec2: Vector3i in singlePoints:
            if vec1 == vec2: continue
            if not possibleConnections.has([vec2, vec1]) and not possibleConnections.has([vec1, vec2]):
                possibleConnections[[vec1, vec2]] = vec1.distance_to(vec2)
    return possibleConnections

func get_min_ind(array: Array) -> int:
    var min: float = array.min()
    return array.find(min)

func flip_connections(dict: Dictionary[Array, float]) -> Dictionary:
    var flipped: Dictionary = {}
    for key in dict:
        if flipped.has(dict[key]):
            flipped[dict[key]].append(key)
        else:
            flipped[dict[key]] = [key]
    return flipped

func get_flip_connections(points: Array[Vector3i]) -> Dictionary:
    var possibleConnections: Dictionary[Array, float] = make_possible_connections(points)
    Helper.print_dict(possibleConnections)
    print("############")
    var connectionsFlipped: Dictionary = flip_connections(possibleConnections)
    connectionsFlipped.sort()
    
    return connectionsFlipped

func solve1(input: String) -> Variant:
    var solution: int = 1
    
    var inputSplit: PackedStringArray = input.split("\n", false)
    var singlePoints: Array[Vector3i] = parse_input(inputSplit)
    #print(singlePoints)
    
    var connectionsFlipped: Dictionary = get_flip_connections(singlePoints)
    
    Helper.print_dict(connectionsFlipped)
    
    var pointGraph: Dictionary[Vector3i, Array] = {}
    
    for point: Vector3i in singlePoints:
        pointGraph[point] = []
    var connectionsFlippedKeys: Array = connectionsFlipped.keys()
    var keySize: int = connectionsFlippedKeys.size()
    for lengthInd: int in keySize:
        
        var length: float = connectionsFlippedKeys[lengthInd]
        if lengthInd % 100 == 0:
            print_log(lengthInd/float(keySize))
        for connections: Array in connectionsFlipped[length]:
            if not connections[1] in pointGraph[connections[0]]:
                pointGraph[connections[0]].append(connections[1])
            if not connections[0] in pointGraph[connections[1]]:
                pointGraph[connections[1]].append(connections[0])
        #print(connectionsFlipped[length])
        #Helper.print_dict(pointGraph)
        pass
    
    Helper.print_dict(pointGraph)
    
    #for circuit: Array in circuits:
        #print_log(str(circuit.size()) + " : " + str(circuit))
    
    #var circuitLens: Array = circuits.map(func(s): return s.size())
    #solution *= circuitLens.max()
    #circuitLens.erase(circuitLens.max())
    #solution *= circuitLens.max()
    #circuitLens.erase(circuitLens.max())
    #solution *= circuitLens.max()
    #circuitLens.erase(circuitLens.max())
    
    
    
    return solution

func solve2(input: String) -> Variant:
    var solution: int = 0
    
    return solution
