extends Solution

func progress_dial(dialNumber: int, inputLine: String) -> int:
	var direction: String = inputLine[0]
	var turnAmount: int = inputLine.substr(1).to_int()
	
	var adjustedDial: int = dialNumber
	if direction == "L":
		adjustedDial = dialNumber - turnAmount
	elif direction == "R":
		adjustedDial = dialNumber + turnAmount
	
	adjustedDial %= 100
	if sign(adjustedDial) == -1:
		adjustedDial += 100
	return adjustedDial

func progress_dial_p2(dialNumber: int, inputLine: String) -> Array:
	var direction: String = inputLine[0]
	var turnAmount: int = inputLine.substr(1).to_int()
	var timesClicked: int = 0
	
	# full rotation checks
	if turnAmount > 99:
		var timesTurned: int = (turnAmount/100)
		timesClicked += abs(timesTurned)
		turnAmount -= timesTurned*100
		
	var adjustedDial: int = dialNumber
	if direction == "L":
		adjustedDial = dialNumber - turnAmount
	elif direction == "R":
		adjustedDial = dialNumber + turnAmount
	
	adjustedDial %= 100
	
	var directionComparison: int = sign(adjustedDial) + sign(dialNumber)
	if adjustedDial != 0:
		if directionComparison == 0:
			timesClicked += 1
		else:
			if direction == "R":
				if adjustedDial < dialNumber:
					timesClicked += 1
			elif direction == "L":
				if adjustedDial > dialNumber:
					timesClicked += 1
	else:
		timesClicked += 1
	
	if sign(adjustedDial) == -1:
		adjustedDial += 100
	
	print_log(str(adjustedDial) + " : " + str(adjustedDial))
	
	return [adjustedDial, timesClicked]
	

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var dialNumber: int = 50
	var inputSplit: PackedStringArray = input.split("\n", false)
	
	for inputLine: String in inputSplit:
		var dialTurnResult: int = progress_dial(dialNumber, inputLine)
		dialNumber = dialTurnResult
		#print(dialNumber)
		if dialNumber == 0: solution += 1
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var dialNumber: int = 50
	var inputSplit: PackedStringArray = input.split("\n", false)
	
	for inputLine: String in inputSplit:
		var dialTurnResult: Array = progress_dial_p2(dialNumber, inputLine)
		dialNumber = dialTurnResult[0]
		solution += dialTurnResult[1]
	
	return solution
