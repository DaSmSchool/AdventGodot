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

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
