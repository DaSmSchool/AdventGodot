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
		shortestButtonPossibilities[setInd] = validButtonCombos.map(func(s): return s.count("1")).min()
	
	#print(shortestButtonPossibilities)
	for lowest: int in shortestButtonPossibilities:
		solution += lowest
	#print(buttonArray.map(func(s): return pow(2, s.size())).max())
	#
	return solution

func get_joltage_difference(joltageArray: Array, buildUpJoltageArray: Array) -> Array:
	var diffArray: Array = []
	for jInd: int in joltageArray.size():
		diffArray.append(joltageArray[jInd]-buildUpJoltageArray[jInd])
	return diffArray

func get_button_scores(buttonArray: Array, remainingJoltageDifference: Array) -> Array:
	var buttonScores: Array = []
	for buttonInd: int in buttonArray.size():
		var button: Array = buttonArray[buttonInd]
		var buttonPressed: int = 0
		var testDiffArray: Array = remainingJoltageDifference.duplicate()
		while true:
			var pressingDone: bool = false
			for joltInd: int in button:
				testDiffArray[joltInd]-=1
				
				if testDiffArray[joltInd] < 0:
					pressingDone = true
					break
			if not pressingDone:
				buttonPressed += 1
			else:
				buttonScores.append(buttonPressed*button.size())
				break
	return buttonScores

func get_lowest_joltage_presses(buttonArray: Array, joltageArray: Array) -> int:
	var buttonPresses: int = 0
	var buildUpJoltageArray: Array = joltageArray.map(func(_j): return 0)
	while buildUpJoltageArray != joltageArray:
		var remainingJoltageDifference: Array = get_joltage_difference(joltageArray, buildUpJoltageArray)
		var buttonScores: Array = get_button_scores(buttonArray, remainingJoltageDifference)
		var maxScore: int = buttonScores.max()
		var maxInd: int = buttonScores.find(maxScore)
		for joltInd: int in buttonArray[maxInd]:
			buildUpJoltageArray[joltInd]+=1
			buttonPresses+=1
	return buttonPresses
		
func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var lightArray: Array = []
	var buttonArray: Array = []
	var joltageArray: Array = []
	parse_input(input, lightArray, buttonArray, joltageArray)
	
	var shortestButtonPossibilities: Array = []
	shortestButtonPossibilities.resize(lightArray.size())
	
	for setInd: int in lightArray.size():
		get_lowest_joltage_presses(buttonArray[setInd], joltageArray[setInd])
	
	return solution
