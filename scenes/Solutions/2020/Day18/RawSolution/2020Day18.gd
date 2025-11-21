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
