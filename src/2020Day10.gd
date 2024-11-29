extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	var existingJoltages: Dictionary = {}
	for line in inputSplit:
		if line == "": continue
		existingJoltages.get_or_add(line.to_int(), false)
	
	var focusJoltage: int = 0
	var currDiff: int = 0
	var singleDiff: int = 0
	var tripleDiff: int = 0
	while currDiff < 4:
		focusJoltage += 1
		currDiff += 1
		if existingJoltages.has(focusJoltage):
			if currDiff == 1:
				singleDiff += 1
			elif currDiff == 3:
				tripleDiff += 1
			currDiff = 0
	
	# the +1 is to represent the phone adapter that supports anything within 3 Jolts
	solution = singleDiff * (tripleDiff + 1)
	
	return solution
	
func get_possible_combos(start: int, jolts: Dictionary, cache: Dictionary) -> int:
	if cache.has(start): return cache[start]
	
	var total: int = 0
	
	var splits: int = 0
	var found = false
	for i in range(1, 4):
		if jolts.has(start+i):
			found = true
			var branchResult: int = get_possible_combos(start+i, jolts, cache)
			total += branchResult
			cache.get_or_add(start+i, branchResult)
	
	if found != true: return total + 1
	return total


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	var existingJoltages: Dictionary = {}
	for line in inputSplit:
		if line == "": continue
		existingJoltages.get_or_add(line.to_int(), false)
	
	var solutionCache: Dictionary = {}
	
	solution = get_possible_combos(0, existingJoltages, solutionCache)
	
	return solution
	
