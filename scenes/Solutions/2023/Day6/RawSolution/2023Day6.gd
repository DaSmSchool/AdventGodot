extends Solution

func run_race(time: int, distance: int) -> int:
	var quadraticFormulaMinimumSolution: int = ceil((time - sqrt(pow(time, 2) - 4*distance))/2)
	#print_log(quadraticFormulaMinimumSolution)
	var ways: int = time-(2*quadraticFormulaMinimumSolution)+1
	# removes races that tie the distance
	if quadraticFormulaMinimumSolution * (time-quadraticFormulaMinimumSolution) == distance:
		ways -= 2
	#print_log(ways)
	#print_log()
	return ways

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var rawTime: PackedStringArray = inputSplit[0].split(" ", false)
	var rawDistance: PackedStringArray = inputSplit[1].split(" ", false)
	rawTime = rawTime.slice(1)
	rawDistance = rawDistance.slice(1)
	
	for raceInd: int in rawTime.size():
		solution *= run_race(rawTime[raceInd].to_int(), rawDistance[raceInd].to_int())
		
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 1
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var rawTime: PackedStringArray = inputSplit[0].split(" ", false)
	var rawDistance: PackedStringArray = inputSplit[1].split(" ", false)
	rawTime = rawTime.slice(1)
	rawDistance = rawDistance.slice(1)
	
	var bigTime: String = ""
	var bigDistance: String = ""
	
	for numInd: int in rawTime.size():
		bigTime += rawTime[numInd]
		bigDistance += rawDistance[numInd]
	
	
	solution *= run_race(bigTime.to_int(), bigDistance.to_int())
		
	return solution
