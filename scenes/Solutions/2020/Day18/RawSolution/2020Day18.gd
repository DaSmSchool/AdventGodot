extends Solution

func evaluate_equation_recurs(equation: String) -> Array:
	var operator: String = ""
	var evaluatedValue: int = 0
	
	var charMax: int = equation.length()
	var charInd: int = 0
	while charInd < charMax:
		var focusChar: String = equation[charInd]
		match focusChar:
			" ":
				pass
			"+":
				operator = "+"
			"*":
				operator = "*"
			"(":
				var evaluatedParen: Array = evaluate_equation_recurs(equation.substr(charInd+1))
				if operator == "+" or operator == "":
					evaluatedValue += evaluatedParen[0]
				elif operator == "*":
					evaluatedValue *= evaluatedParen[0]
				charInd += evaluatedParen[1]
			")":
				return [evaluatedValue, charInd+1]
			_:
				if focusChar.is_valid_int():
					if evaluatedValue == 0 or operator == "+":
						evaluatedValue += focusChar.to_int()
					elif operator == "*":
						evaluatedValue *= focusChar.to_int()
		charInd += 1
	return [evaluatedValue, charInd]
	

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	
	for equation: String in inputSplit:
		solution += evaluate_equation_recurs(equation)[0]
	
	return solution

func turn_equation_to_array(equation: String) -> Array:
	var equationArray: Array = []
	
	var charMax: int = equation.length()
	var charInd: int = 0
	while charInd < charMax:
		var charStr: String = equation[charInd]
		match charStr:
			"(":
				var innerParenEvaluation: Array = turn_equation_to_array(equation.substr(charInd+1))
				equationArray.append(innerParenEvaluation[0])
				charInd += innerParenEvaluation[1]
			")":
				return [equationArray, charInd+1]
			" ":
				pass
			_:
				if charStr.is_valid_int():
					equationArray.append(charStr.to_int())
				else:
					equationArray.append(charStr)
		charInd += 1
	
	return equationArray
			

func addition_prioritize_array(equationArray: Array) -> void:
	var elementMax: int = equationArray.size()
	var elementInd: int = 0
	while elementInd < elementMax:
		if equationArray[elementInd] is int and equationArray[elementInd] == 8:
			pass
		if equationArray[elementInd] is Array:
			addition_prioritize_array(equationArray[elementInd])
		elif equationArray[elementInd] is String and equationArray[elementInd] == "+" and elementMax != 3:
			if equationArray[elementInd+1] is Array:
				addition_prioritize_array(equationArray[elementInd+1])
			var combinedArray: Array = equationArray.slice(elementInd-1, elementInd+2)
			equationArray[elementInd-1] = combinedArray
			equationArray.pop_at(elementInd)
			equationArray.pop_at(elementInd)
			elementMax = equationArray.size()
			elementInd -= 1
		elementInd += 1

func multiplication_prioritize_array(equationArray: Array) -> void:
	var elementMax: int = equationArray.size()
	var elementInd: int = 0
	while elementInd < elementMax:
		if equationArray[elementInd] is Array:
			multiplication_prioritize_array(equationArray[elementInd])
		elif equationArray[elementInd] is String and equationArray[elementInd] == "*" and elementMax != 3:
			if equationArray[elementInd+1] is Array:
				multiplication_prioritize_array(equationArray[elementInd+1])
			var combinedArray: Array = equationArray.slice(elementInd-1, elementInd+2)
			equationArray[elementInd-1] = combinedArray
			equationArray.pop_at(elementInd)
			equationArray.pop_at(elementInd)
			elementMax = equationArray.size()
			elementInd -= 1
		elementInd += 1
			
func evalulate_equation_recurs_p2(equationArray: Array) -> int:
	var leftSide: int = 0
	var rightSide: int = 0
	
	if equationArray[0] is int: leftSide = equationArray[0]
	else: leftSide = evalulate_equation_recurs_p2(equationArray[0])
	
	if equationArray[2] is int: rightSide = equationArray[2]
	else: rightSide = evalulate_equation_recurs_p2(equationArray[2])
	
	var result: int = 0
	if equationArray[1] == "+":
		result = leftSide + rightSide
	elif equationArray[1] == "*":
		result = leftSide * rightSide
	
	return result

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	
	for equation: String in inputSplit:
		#print(equation)
		var equationArray: Array = turn_equation_to_array(equation)
		#print(equationArray)
		addition_prioritize_array(equationArray)
		#print(equationArray)
		multiplication_prioritize_array(equationArray)
		#print(equationArray)
		if equationArray.size() == 1:
			equationArray = equationArray[0]
		solution += evalulate_equation_recurs_p2(equationArray)
		#print()
		#solution += evaluate_equation_recurs(equation)[0]
	
	return solution
