extends Solution

# my multitude of recursive and momoized approaches have paid off splendidly

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_target_possible(combo: String, availables: PackedStringArray) -> bool:
	if combo == "": return true
	
	for available: String in availables:
		if combo.begins_with(available):
			var check: bool = is_target_possible(combo.substr(available.length()), availables)
			if check: return true
	
	return false
	


func possible_target_count(combo: String, availables: PackedStringArray, cache: Dictionary) -> int:
	var possibleCount: int = 0
	if combo == "": return 1
	
	if cache.has(combo.length()):
		return cache[combo.length()]
	
	for available: String in availables:
		if combo.begins_with(available):
			possibleCount += possible_target_count(combo.substr(available.length()), availables, cache)
	
	cache.get_or_add(combo.length(), possibleCount)
	
	return possibleCount


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var availableTowels: PackedStringArray = inputSplit[0].split(", ")
	#print(availableTowels)
	var targetTowels: PackedStringArray = []
	for line: String in inputSplit[1].split("\n"):
		if line == "": continue
		targetTowels.append(line)
	#print(targetTowels)
	
	var possibleCombos: int = 0
	
	for target: String in targetTowels:
		if is_target_possible(target, availableTowels):
			possibleCombos += 1
			#print(target)
	
	solution = possibleCombos
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var availableTowels: PackedStringArray = inputSplit[0].split(", ")
	#print(availableTowels)
	var targetTowels: PackedStringArray = []
	for line: String in inputSplit[1].split("\n"):
		if line == "": continue
		targetTowels.append(line)
	#print(targetTowels)
	
	var possibleCombos: int = 0
	
	for target: String in targetTowels:
		#print(target)
		var targetCache: Dictionary = {}
		possibleCombos += possible_target_count(target, availableTowels, targetCache)
	
	solution = possibleCombos
	
	return solution
