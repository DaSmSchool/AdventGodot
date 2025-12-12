extends Solution

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var lineSplit: PackedStringArray = input.split("\n\n", false)
	
	var pieceSizes: Array = []
	var treeConfigs: Array = []
	
	var treesSplit: PackedStringArray = lineSplit[lineSplit.size()-1].split("\n", false)
	for rawTree: String in treesSplit:
		var treeSplit: PackedStringArray = rawTree.split(": ", false)
		var dims: Array = Array(treeSplit[0].split("x")).map(func(d): return int(d))
		var inds: Array = Array(treeSplit[1].split(" ")).map(func(i): return int(i))
		treeConfigs.append([dims, inds])
	
	lineSplit.remove_at(lineSplit.size()-1)
	pieceSizes = Array(lineSplit).map(func(s): return s.count("#"))
	
	for tree: Array in treeConfigs:
		var presentArea: int = 0
		for ind: int in tree[1].size():
			presentArea += tree[1][ind] * pieceSizes[ind]
		var dimArea: int = tree[0][0]*tree[0][1]
		print(str(dimArea) + " : " + str(presentArea))
		print(str(dimArea-presentArea))
		if presentArea <= dimArea:
			solution += 1
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
