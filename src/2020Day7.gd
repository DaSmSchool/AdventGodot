extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recursiveCheckBag(key: String, rules: Dictionary, cache: Dictionary, count: int) -> int:
	if cache.has(key): return cache[key]
	
	var possibles: int = 0
	
	for bag: Dictionary in rules[key]:
		if bag.keys()[0] == "shiny gold": possibles += 1
		elif bag.keys()[0] == "other bags": pass
		else:
			possibles += recursiveCheckBag(bag.keys()[0], rules, cache, count)
	
	cache.get_or_add(key, possibles)
	return possibles
	
func recursiveCheckBagCount(key: String, rules: Dictionary, cache: Dictionary, count: int) -> int:
	var bagsRequired: int = 0
	
	
	for bag: Dictionary in rules[key]:
		if bag.keys()[0] == "other bags": pass
		else:
			var bagMultiple: int = bag[bag.keys()[0]]
			bagsRequired += bagMultiple
			
			var containCheck: int
			if cache.has(bag.keys()[0]):
				containCheck = cache[bag.keys()[0]]
			else:
				containCheck = recursiveCheckBagCount(bag.keys()[0], rules, cache, count)
				cache.get_or_add(bag.keys()[0], containCheck)
			bagsRequired += bagMultiple * containCheck
	
	return bagsRequired

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var containRules: Dictionary = {}
	
	for line in inputLines:
		if line == "": continue
		
		var contentDef: PackedStringArray = line.split(" contain ")
		
		# removes period at the end
		contentDef[1] = contentDef[1].substr(0, contentDef[1].length()-1)
		
		var bagKey: String = contentDef[0].substr(0, contentDef[0].length()-5)
		var bagContents: Array[Dictionary] = []
		
		# assemble bag contents
		var contentList: PackedStringArray = contentDef[1].split(", ")
		for bagListing: String in contentList:
			var contentListing: PackedStringArray = bagListing.split(" ")
			
			var contentDict = {}
			# no bags inside is insdicated with "no bags inside" in the input, 
			# so we have to insert a 0 manually
			if contentListing[0] == "no":
				contentDict.get_or_add(contentListing[1] + " " + contentListing[2], 0)
			else:
				contentDict.get_or_add(contentListing[1] + " " + contentListing[2], contentListing[0].to_int())
			
			bagContents.append(contentDict)
			
		containRules.get_or_add(bagKey, bagContents)
	
	var checkedBagsCache: Dictionary = {}
	
	for key: String in containRules.keys():
		recursiveCheckBag(key, containRules, checkedBagsCache, 0)
		
	for key: String in checkedBagsCache.keys():
		if checkedBagsCache[key] > 0: solution += 1
		#print(checkedBagsCache[key])
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var containRules: Dictionary = {}
	
	for line in inputLines:
		if line == "": continue
		
		var contentDef: PackedStringArray = line.split(" contain ")
		
		# removes period at the end
		contentDef[1] = contentDef[1].substr(0, contentDef[1].length()-1)
		
		var bagKey: String = contentDef[0].substr(0, contentDef[0].length()-5)
		var bagContents: Array[Dictionary] = []
		
		# assemble bag contents
		var contentList: PackedStringArray = contentDef[1].split(", ")
		for bagListing: String in contentList:
			var contentListing: PackedStringArray = bagListing.split(" ")
			
			var contentDict = {}
			# no bags inside is insdicated with "no bags inside" in the input, 
			# so we have to insert a 0 manually
			if contentListing[0] == "no":
				contentDict.get_or_add(contentListing[1] + " " + contentListing[2], 0)
			else:
				contentDict.get_or_add(contentListing[1] + " " + contentListing[2], contentListing[0].to_int())
			
			bagContents.append(contentDict)
			
		containRules.get_or_add(bagKey, bagContents)
	
	var bagCountCache: Dictionary = {}
	
	solution = recursiveCheckBagCount("shiny gold", containRules, bagCountCache, 0)
	
	return solution
