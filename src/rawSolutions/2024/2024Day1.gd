extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var splitInput: PackedStringArray = input.split("\n")
	var idPairs: Array = [[], []]
	
	for line: String in splitInput:
		if line == "": continue
		var rawPair: PackedStringArray = line.split("  ")
		idPairs[0].append(rawPair[0].to_int())
		idPairs[1].append(rawPair[1].to_int())
	
	idPairs[0].sort()
	idPairs[1].sort()
	
	var differences: int = 0
	for pairInd in idPairs[0].size():
		differences += abs(idPairs[0][pairInd] - idPairs[1][pairInd])
	solution = differences
		
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var splitInput: PackedStringArray = input.split("\n")
	var idPairs: Array = [[], []]
	
	for line: String in splitInput:
		if line == "": continue
		var rawPair: PackedStringArray = line.split("  ")
		idPairs[0].append(rawPair[0].to_int())
		idPairs[1].append(rawPair[1].to_int())
	
	idPairs[0].sort()
	idPairs[1].sort()
	
	var similarityScore: int = 0
	
	var list1Ind: int = 0
	var list2Ind: int = 0
	var appearanceCache: Dictionary = {}
	
	# scrolling indeces, avoids iterating through previous values
	while list1Ind < idPairs[0].size():
		if list2Ind == idPairs[1].size(): break
		
		#print("[" + str(list1Ind) + ", " + str(list2Ind) + "]: ( " + str(idPairs[0][list1Ind]) + ", " + str(idPairs[1][list2Ind]) + " )")
		
		if appearanceCache.has(idPairs[0][list1Ind]):
			similarityScore += appearanceCache[idPairs[0][list1Ind]]
			#print(appearanceCache[idPairs[0][list1Ind]])
			list1Ind += 1
			continue
		
		if idPairs[0][list1Ind] < idPairs[1][list2Ind]:
			list1Ind += 1
			continue
		elif idPairs[0][list1Ind] == idPairs[1][list2Ind]:
			var occurences: int = 0
			while list2Ind < idPairs[1].size() and idPairs[0][list1Ind] == idPairs[1][list2Ind]:
				occurences += 1
				list2Ind += 1
			var thisValsSimilarityScore: int = occurences*idPairs[0][list1Ind]
			appearanceCache.get_or_add(idPairs[0][list1Ind], thisValsSimilarityScore)
			similarityScore += thisValsSimilarityScore
			#print(thisValsSimilarityScore)
			list1Ind += 1
		elif idPairs[0][list1Ind] > idPairs[1][list2Ind]:
			list2Ind += 1
			continue
		
	solution = similarityScore
		
	return solution
