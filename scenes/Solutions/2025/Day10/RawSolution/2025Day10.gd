extends Solution

# a few one liner map parsers. as a treat.
func parse_input(input: String, lightArray: Array, buttonArray: Array, joltageArray: Array) -> void:
	var lineSplit: PackedStringArray = input.split("\n", false)
	for line: String in lineSplit:
		var fieldSplit: PackedStringArray = line.split(" ")
		lightArray.append(Array(fieldSplit[0].substr(1, fieldSplit[0].length()-2).split("")).map(func(l): return true if l == "#" else false))
		fieldSplit.remove_at(0)
		joltageArray.append(Array(fieldSplit[fieldSplit.size()-1].substr(1, fieldSplit[fieldSplit.size()-1].length()-2).split(",")).map(func(j): return int(j)))
		fieldSplit.remove_at(fieldSplit.size()-1)
		buttonArray.append(Array(fieldSplit).map(func(b): return Array(b.substr(1, b.length()-1).split(",")).map(func(n): return int(n)))) 

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var lightArray: Array = []
	var buttonArray: Array = []
	var joltageArray: Array = []
	parse_input(input, lightArray, buttonArray, joltageArray)
	
	var shortestButtonPossibilities: Array = []
	shortestButtonPossibilities.resize(lightArray.size())
	
	for setInd: int in lightArray.size():
		var validButtonCombos: Array[String] = []
		var lightSet: Array = []
		lightSet.resize(lightArray[setInd].size())
		
		var combinationAmount: int = pow(2, buttonArray[setInd].size())
		for i: int in combinationAmount:
			# set to no lights
			lightSet = lightSet.map(func(_s): return false)
			
			var strRepresentation: String = String.num_int64(i, 2).reverse()
			for buttonInd: int in strRepresentation.length():
				if strRepresentation[buttonInd] == "0": continue
				var focusButton: Array = buttonArray[setInd][buttonInd]
				for lightInvertIndex: int in focusButton:
					lightSet[lightInvertIndex] = not lightSet[lightInvertIndex]
			if lightSet == lightArray[setInd]:
				validButtonCombos.append(strRepresentation)
			#print(strRepresentation)
			#print(lightSet)
			#print(lightArray[setInd])
			#print()
		#print(validButtonCombos)
		shortestButtonPossibilities[setInd] = validButtonCombos.map(func(s): return s.count("1")).min()
		#print(lightArray[setInd])
		#print(buttonArray[setInd])
		#print(joltageArray[setInd])
		#print()
	
	#print(shortestButtonPossibilities)
	for lowest: int in shortestButtonPossibilities:
		solution += lowest
	#print(buttonArray.map(func(s): return pow(2, s.size())).max())
	#
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
