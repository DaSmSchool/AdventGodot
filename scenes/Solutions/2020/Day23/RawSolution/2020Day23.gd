extends Solution


func solve1(input: String) -> String:
	var cupOrderMax: int = 0
	var cupOrder: Array = []
	
	for cup: String in input.split("\n", false)[0]:
		cupOrder.append(cup.to_int())
		cupOrderMax += 1
	
	var currentCup: int = cupOrder[0]
	
	#print(cupOrder)
	
	for i: int in range(100):
		var currentCupInd: int = cupOrder.find(currentCup)
		var removeArr: Array[int] = []
		
		var amountRotate: int = 3
		removeArr.resize(amountRotate)
		for f: int in range(amountRotate):
			removeArr[f] = cupOrder[(currentCupInd+f+1)%cupOrderMax]
			cupOrder[(currentCupInd+f+1) % cupOrderMax] = null
		while cupOrder.has(null):
			cupOrder.erase(null)
		
		var targetCup: int = currentCup-1
		if targetCup == 0: targetCup = cupOrderMax
		while not cupOrder.has(targetCup):
			targetCup -= 1
			if targetCup == 0: targetCup = cupOrderMax
		
		var targetCupInd: int = cupOrder.find(targetCup)
		for f: int in range(amountRotate):
			cupOrder.insert(targetCupInd+1+f, removeArr[f])
		
		currentCupInd = cupOrder.find(currentCup)+1
		if currentCupInd >= cupOrderMax:
			currentCupInd = 0
		currentCup = cupOrder[currentCupInd]
		#print(cupOrder)
		#print(removeArr)
		#print(targetCup)
		#print()
	
	var solutionString: String = ""
	for cup: int in cupOrder:
		solutionString += str(cup)
	
	var solSplit: PackedStringArray = solutionString.split("1")
	
	return solSplit[1] + solSplit[0]

class Cup:
	var value: int
	var prev: Cup
	var next: Cup
	
	func _init(value: int, prev: Cup = null, next: Cup = null) -> void:
		if prev == null:
			self.prev = self
		else:
			self.prev = prev
		if next == null:
			self.next = self
		else:
			self.next = next
		self.value = value

func add_cup(cupNumber: int, cupDict: Array, firstNumber: int, lastNumber: int) -> void:
	if lastNumber == 0:
		cupDict[cupNumber] = Cup.new(cupNumber)
	else:
		var prev: Cup = cupDict[lastNumber]
		var next: Cup = cupDict[firstNumber]
		var newCup: Cup = Cup.new(cupNumber, prev, next)
		prev.next = newCup
		next.prev = newCup
		cupDict[cupNumber] = newCup

func make_cups(cupCount: int, cupArray: Array, input: String) -> void:
	var cupsMade: int = 0
	
	var firstMade: int = input[0].to_int()
	var lastMade: int = 0
	
	for number: String in input.split("\n", false)[0]:
		add_cup(number.to_int(), cupArray, firstMade, lastMade)
		lastMade = number.to_int()
		cupsMade += 1
		print("L: " + str(lastMade))
	print(cupsMade)
	while cupsMade < cupCount:
		add_cup(cupsMade+1, cupArray, firstMade, lastMade)
		lastMade = cupsMade+1
		cupsMade += 1
	

func get_post_three_slice(currentCup: Cup) -> Array:
	var sliceArray: Array = []
	sliceArray.append(currentCup.next)
	sliceArray.append(currentCup.next.next)
	sliceArray.append(currentCup.next.next.next)
	return sliceArray

func print_cup(cup: Cup) -> void:
	print(str(cup.prev.value) + " : " + str(cup.value) + " : " + str(cup.next.value))

func make_move(cupDict: Array, currentCupNumber: int) -> int:
	var currentCup: Cup = cupDict[currentCupNumber]
	var threeSlice: Array = get_post_three_slice(currentCup)
	
	currentCup.next = threeSlice[2].next
	threeSlice[2].next.prev = currentCup
	
	var designationCupNumber: int = currentCupNumber-1
	if designationCupNumber == 0: designationCupNumber = cupDict.size()-1
	while cupDict[designationCupNumber] in threeSlice:
		designationCupNumber -= 1
		if designationCupNumber == 0: designationCupNumber = cupDict.size()-1
	
	var designationCup: Cup = cupDict[designationCupNumber]
	var aboutToBeReplacedDestNext: Cup = designationCup.next
	
	threeSlice[2].next = aboutToBeReplacedDestNext
	aboutToBeReplacedDestNext.prev = threeSlice[2]
	threeSlice[0].prev = designationCup
	designationCup.next = threeSlice[0]
	
	#print("G")
	#print_cup(designationCup)
	#print_cup(threeSlice[0])
	#print_cup(threeSlice[1])
	#print_cup(threeSlice[2])
	#print_cup(aboutToBeReplacedDestNext)
	#print()
	
	return currentCup.next.value

func print_order(cupArray: Array) -> void:
	var startingCount = cupArray[1].next.value
	var orderString: String = ""
	while cupArray[startingCount].value != 1:
		orderString += str(startingCount)
		startingCount = cupArray[startingCount].next.value
	print(orderString)

func solve2(input: String) -> int:
	var solution: int = 0
	var cupArray: Array = []
	
	var cupCount: int = 1_000_000
	cupArray.resize(cupCount+1)
	var moveCount: int = 10_000_000
	
	make_cups(cupCount, cupArray, input)
	
	#print_order(cupArray)
	
	var currentCup: int = input[0].to_int()
	for move: int in range(moveCount):
		if move % 1_000_000 == 0:
			print(move)
		currentCup = make_move(cupArray, currentCup)
		#print_order(cupArray)
	
	
	return cupArray[1].next.value * cupArray[1].next.next.value
