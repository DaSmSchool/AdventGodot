extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func evolve_num(sn: int) -> int:
	var mult1: int = sn * 64
	sn ^= mult1
	sn %= 16777216
	var div1: int = floor(float(sn)/32)
	sn ^= div1
	sn %= 16777216
	var mult2: int = sn * 2048
	sn ^= mult2
	sn %= 16777216
	return sn


func solve1(input: String) -> int:
	var solution: int = 0
	
	var initialSecrets: PackedInt64Array = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	for line: String in inputSplit:
		if line == "": continue
		initialSecrets.append(line.to_int())
	
	var resultSecrets: PackedInt64Array = []
	
	for num: int in initialSecrets:
		for i in range(2000):
			num = evolve_num(num)
		resultSecrets.append(num)
	
	for num: int in resultSecrets:
		solution += num
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var initialSecrets: PackedInt64Array = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	for line: String in inputSplit:
		if line == "": continue
		initialSecrets.append(line.to_int())
	
	var resultSecrets: PackedInt64Array = []
	var priceLists: Array = []
	
	# gather prices throughout time
	for num: int in initialSecrets:
		var changeList: PackedInt64Array = []
		changeList.append(num % 10)
		for i: int in range(2000):
			num = evolve_num(num)
			changeList.append(num % 10)
		priceLists.append(changeList)
	
	# gather price differences
	var priceDiffs: Array = []
	for buyerInd: int in priceLists.size():
		var diffList: PackedInt64Array = []
		for priceInd: int in range(0, priceLists[buyerInd].size()-1):
			diffList.append(priceLists[buyerInd][priceInd+1]-priceLists[buyerInd][priceInd])
		priceDiffs.append(diffList)
	
	#print(priceLists)
	#print(priceDiffs)
	
	# gather possible price difference sets
	var possiblePriceDiffSets: Dictionary = {}
	var buyerSets: Array = []
	
	for buyerInd: int in priceDiffs.size():
		print(float(buyerInd)/priceDiffs.size())
		var buyerSet: Array = []
		for priceInd: int in range(0, priceDiffs[buyerInd].size()-3):
			var focusList: PackedInt64Array = priceDiffs[buyerInd].slice(priceInd, priceInd+4)
			if possiblePriceDiffSets.get(focusList, -1) == -1:
				possiblePriceDiffSets.get_or_add(focusList, 0)
			if !buyerSet.has(focusList):
				possiblePriceDiffSets[focusList] += priceLists[buyerInd][priceInd+4]
				buyerSet.append(focusList)
		#buyerSets.append(buyerSet)
	
	
	
	#for buyerInd: int in buyerSets.size():
		#print(float(buyerInd)/buyerSets.size())
		#for diffSet: PackedInt64Array in buyerSets[buyerInd]:
			#for priceInd: int in range(0, priceDiffs[buyerInd].size()-3):
				#var focusList: PackedInt64Array = priceDiffs[buyerInd].slice(priceInd, priceInd+4)
				#if focusList == diffSet:
					#possiblePriceDiffSets[diffSet] += priceLists[buyerInd][priceInd+4]
					#break
	#print(bananasReceivedInSets)
	
	#for key in possiblePriceDiffSets:
		#print("KEY: " + str(key) + " VAL: " + str(possiblePriceDiffSets[key]))
		#await get_tree().create_timer(0.0001).timeout
	
	solution = possiblePriceDiffSets.values().max()
	
	return solution
