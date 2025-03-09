extends Solution

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	for line: String in inputSplit:
		if line.length() < 4:
			continue
		elif line.length() > 12:
			continue
		
		var hasDigit: bool = false
		var hasUppercase: bool = false
		var hasLowercase: bool = false
		var hasNonASCII: bool = false
		
		for char: String in line:
			if char.is_valid_int(): hasDigit = true
			if char.to_upper() == char and char.to_lower() != char: hasUppercase = true
			if char.to_upper() != char and char.to_lower() == char: hasLowercase = true
			if char.unicode_at(0) > 127: hasNonASCII = true
		
		if hasDigit and hasUppercase and hasLowercase and hasNonASCII:
			solution += 1
			#print("YES!")
		#else:
			#print("no")
		
	
	return solution
	
