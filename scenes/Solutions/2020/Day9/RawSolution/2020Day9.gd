extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	var numberList: Array[int] = []
	
	var trail: int = 25
	for line in inputLines:
		if line == "": continue
		numberList.append(line.to_int())
	
	for focusInd in range(trail, numberList.size()):
		var numberPossible: bool = false
		for ind1 in range(focusInd-trail, focusInd-1):
			for ind2 in range(ind1+1, focusInd):
				if numberList[ind1] + numberList[ind2] == numberList[focusInd]:
					numberPossible = true
					break
			if numberPossible: break
		if !numberPossible: 
			solution = numberList[focusInd]
			break
	
	return solution
	
func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	var numberList: Array[int] = []
	
	var trail: int = 25
	for line in inputLines:
		if line == "": continue
		numberList.append(line.to_int())
	
	print(numberList)
	
	var tgtNumber: int = solve1(input)
	
	for startInd in range(0, numberList.size()):
		var sum: int = numberList[startInd]
		var range: int = 0
		while sum < tgtNumber:
			range += 1
			sum += numberList[startInd+range]
		if tgtNumber == sum:
			var sumInts: Array[int] = numberList.slice(startInd, startInd+range+1)
			solution = sumInts.max() + sumInts.min()
			break
	
	return solution
