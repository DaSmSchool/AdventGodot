extends Solution

func parse_input(input: String) -> Dictionary[String, Array]:
	var nodeDict: Dictionary[String, Array] = {}
	for line: String in input.split("\n", false):
		var lineSplit: PackedStringArray = line.split(": ")
		nodeDict[lineSplit[0]] = Array(lineSplit[1].split(" "))
	return nodeDict

func get_paths(node: String, nodeTarget: String, nodes: Dictionary[String, Array], exploredNodes: Dictionary[String, int]) -> int:
	if node == nodeTarget:
		return 1
	if exploredNodes.has(node):
		return exploredNodes[node]
	var paths: int = 0
	for extraNode: String in nodes[node]:
		paths+=get_paths(extraNode, nodeTarget, nodes, exploredNodes)
	exploredNodes[node] = paths
	return paths

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var nodeDict: Dictionary[String, Array] = parse_input(input)
	
	var exploredNodes: Dictionary[String, int] = {}
	solution = get_paths("you", "out", nodeDict, exploredNodes)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 1
	
	var nodeDict: Dictionary[String, Array] = parse_input(input)
	nodeDict["out"] = []
	
	var paths: PackedStringArray = ["svr", "fft", "dac", "out"]
	
	for ind: int in paths.size()-1:
		var exploredNodes: Dictionary[String, int] = {}
		solution *= get_paths(paths[ind], paths[ind+1], nodeDict, exploredNodes)
	
	return solution
