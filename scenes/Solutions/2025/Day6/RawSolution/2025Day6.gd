extends Solution

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var equationArray: Array = []
	var rawSplit: PackedStringArray = input.split("\n", false)
	for rawLine: String in rawSplit:
		equationArray.append(rawLine.split(" ", false))
	
	for equationLine: Array in equationArray:
		print_log(equationLine)
	
	for equationInd: int in equationArray[0].size():
		var equationValue: int = 0
		var equationMode: String = equationArray.back()[equationInd]
		if equationMode == "*":
			equationValue += 1
		for equationLineInd: int in equationArray.size()-1:
			if equationMode == "+":
				equationValue += equationArray[equationLineInd][equationInd].to_int()
			elif equationMode == "*":
				equationValue *= equationArray[equationLineInd][equationInd].to_int()
		solution += equationValue
	
	return solution

func get_equations_p2(input: PackedStringArray) -> Array:
	input = input.duplicate()
	var equationArray: Array = []
	
	var xInd: int = 0
	while xInd <= input[0].length():
		if input[0].length() == 0: break
		var allSpaces: bool = true
		if xInd < input[0].length():
			for lineInd: int in input.size():
				if input[lineInd][xInd] != " ":
					allSpaces = false
					break
		
		if allSpaces:
			var equationAssemble: Array = []
			for equationRowInd: int in input.size():
				equationAssemble.append(input[equationRowInd].substr(0, xInd))
				input[equationRowInd] = input[equationRowInd].substr(xInd+1)
			xInd = -1
			equationArray.append(equationAssemble)
		xInd += 1
	
	return equationArray

func evaluate_equation(equation: Array) -> int:
	var equationValue: int = 0
	var equationMode: String = equation.back().split(" ", false)[0]
	if equationMode == "*":
		equationValue = 1
	for xInd: int in range(equation[0].length()-1, -1, -1):
		var assembleNumber: String = ""
		for rowInd: int in equation.size()-1:
			var focusChar: String = equation[rowInd][xInd]
			if focusChar.is_valid_int():
				assembleNumber += focusChar
		if equationMode == "+":
			equationValue += assembleNumber.to_int()
		elif equationMode == "*":
			equationValue *= assembleNumber.to_int()
	return equationValue

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var equationArray: Array = []
	var rawSplit: PackedStringArray = input.split("\n", false)
	equationArray = get_equations_p2(rawSplit)
	
	for equation: Array in equationArray:
		for equationLine: String in equation:
			print_log(equationLine)
		print_log()
	
	for equation: Array in equationArray:
		solution += evaluate_equation(equation)
	
	return solution
