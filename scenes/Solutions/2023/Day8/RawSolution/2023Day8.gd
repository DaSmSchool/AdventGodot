extends Solution

func build_node_dict(input: String, dict: Dictionary[String, Array]) -> void:
	for rawNode: String in input.split("\n", false):
		var endsSplit: PackedStringArray = rawNode.split(" = ")
		endsSplit[1] = endsSplit[1].substr(1, endsSplit[1].length()-2)
		dict[endsSplit[0]] = Array(endsSplit[1].split(", ", false))

func make_step(currentNode: String, nodes: Dictionary[String, Array], steps: String, stepInd: int) -> String:
	var direction: String = steps[stepInd]
	if direction == "L":
		return nodes[currentNode][0]
	else:
		return nodes[currentNode][1]

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var steps: String = inputSplit[0]
	var nodes: Dictionary[String, Array] = {}
	build_node_dict(inputSplit[1], nodes)
	
	
	var currentNode: String = "AAA"
	var stepInd: int = 0
	var stepsTaken: int = 0
	while currentNode != "ZZZ":
		currentNode = make_step(currentNode, nodes, steps, stepInd)
		stepInd += 1
		stepInd %= steps.length()
		stepsTaken += 1
	solution = stepsTaken
	
	return solution

func get_a_starters(dict: Dictionary[String, Array]) -> Array:
	var aStarters: Array = []
	for key: String in dict:
		if key[2] == "A":
			aStarters.append(key)
	return aStarters

func run_a_starter(aStarter: , nodes, steps) -> Dictionary:
	var aStarterInfo: Dictionary = {
		"ZNode": "",
		"stepsToReachZFirst": 0,
		"ZLoopSteps": 0,
	}
	
	var currentNode: String = aStarter
	var stepInd: int = 0
	var stepsTaken: int = 0
	while currentNode[2] != "Z" or aStarterInfo.ZNode == "":
		if currentNode[2] == "Z":
			aStarterInfo.ZNode = currentNode
			aStarterInfo.stepsToReachZFirst = stepsTaken
		currentNode = make_step(currentNode, nodes, steps, stepInd)
		stepInd += 1
		stepInd %= steps.length()
		stepsTaken += 1
	aStarterInfo.ZLoopSteps = stepsTaken-aStarterInfo.stepsToReachZFirst
	
	return aStarterInfo

func correct_with_common_factors(aStartersInfo: Dictionary[String, Dictionary]) -> int:
	var returnSolution: int = 1
	var commonFactors: Array = Helper.get_positive_factors(aStartersInfo[aStartersInfo.keys().front()].ZLoopSteps)
	for infoKey: String in aStartersInfo:
		commonFactors = Helper.shared_elements(commonFactors, Helper.get_positive_factors(aStartersInfo[infoKey].ZLoopSteps))
	
	for aStarter: Dictionary in aStartersInfo.values():
		for commonFactor: int in commonFactors:
			aStarter.ZLoopSteps /= commonFactor
		returnSolution *= aStarter.ZLoopSteps
	
	for commonFactor: int in commonFactors:
		returnSolution *= commonFactor
	
	return returnSolution

func solve2(input: String) -> Variant:
	var solution: int = 1
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var steps: String = inputSplit[0]
	var nodes: Dictionary[String, Array] = {}
	build_node_dict(inputSplit[1], nodes)
	
	var aStarters: Array = get_a_starters(nodes)
	var aStartersInfo: Dictionary[String, Dictionary]
	for aStarter: String in aStarters:
		aStartersInfo[aStarter] = run_a_starter(aStarter, nodes, steps)
	
	solution = correct_with_common_factors(aStartersInfo)
	
	return solution
