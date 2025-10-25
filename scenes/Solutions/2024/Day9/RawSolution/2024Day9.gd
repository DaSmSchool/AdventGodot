extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var assemble: Array[int] = []
	
	var empty: bool = false
	var addNum: int = 0
	for char: String in input:
		if char == "\n": continue
		if !empty:
			for amount: int in char.to_int():
				assemble.append(addNum)
			addNum += 1
		else:
			for amount: int in char.to_int():
				assemble.append(-1)
		empty = !empty
	
	var forwardInd: int = 0
	var backwardInd: int = assemble.size()-1
	
	#print(assemble)
	
	while forwardInd < backwardInd:
		if assemble[forwardInd] == -1:
			if assemble[backwardInd] != -1:
				assemble[forwardInd] = assemble[backwardInd]
				assemble[backwardInd] = -1
			else:
				backwardInd -= 1
		else:
			forwardInd += 1
	
	assemble
	
	for charInd: int in assemble.size():
		if assemble[charInd] != -1:
			solution += charInd * assemble[charInd]
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var assemble: Array[int] = []
	
	var empty: bool = false
	var addNum: int = 0
	for char: String in input:
		if char == "\n": continue
		if !empty:
			for amount: int in char.to_int():
				assemble.append(addNum)
			addNum += 1
		else:
			for amount: int in char.to_int():
				assemble.append(-1)
		empty = !empty
	
	var focusNum: int = assemble.max()
	while focusNum >= 0:
		#print("Foc: %d" % focusNum)
		var numEndInd: int = assemble.rfind(focusNum)
		var extentInd = 0
		var numAmount = 0
		while assemble[numEndInd+extentInd] == focusNum:
			numAmount += 1
			extentInd -= 1
		
		var forwardSearch: int = 0
		while assemble[forwardSearch] != focusNum:
			if assemble[forwardSearch] == -1:
				#print(assemble)
				var emptyExtentInd = 0
				var emptyNumAmount = 0
				while assemble[forwardSearch+emptyExtentInd] == -1:
					emptyNumAmount += 1
					emptyExtentInd -= 1
				if emptyNumAmount >= numAmount:
					for numOff: int in numAmount:
						#print("%d %d" % [numOff, forwardSearch])
						assemble[forwardSearch+emptyExtentInd+numOff+1] = focusNum
						assemble[numEndInd-numAmount+numOff+1] = -1
					forwardSearch = -1
					break
			forwardSearch += 1
		
		focusNum -= 1
	
	#print(assemble)
	
	for charInd: int in assemble.size():
		if assemble[charInd] != -1:
			solution += charInd * assemble[charInd]
		
	return solution
