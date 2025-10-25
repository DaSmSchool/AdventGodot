extends Solution


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	for line: String in inputLines:
		if line == "": continue
		var inputSet: PackedStringArray = line.split(" ")
		var policySet: PackedStringArray = inputSet[0].split("-")
		var minCount: int = policySet[0].to_int()
		var maxCount: int = policySet[1].to_int()
		var selectedChar: String = inputSet[1][0]
		var possiblePassword: String = inputSet[2]
		
		var appearCount: int = 0
		for char in possiblePassword:
			if char == selectedChar: appearCount += 1
		
		if appearCount <= maxCount and appearCount >= minCount: solution += 1
		
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	for line: String in inputLines:
		if line == "": continue
		var inputSet: PackedStringArray = line.split(" ")
		var policySet: PackedStringArray = inputSet[0].split("-")
		var ind1: int = policySet[0].to_int() - 1
		var ind2: int = policySet[1].to_int() - 1
		var selectedChar: String = inputSet[1][0]
		var possiblePassword: String = inputSet[2]
		
		var charAtInd1: int = int(possiblePassword[ind1] == selectedChar)
		var charAtInd2: int = int(possiblePassword[ind2] == selectedChar)
		
		if charAtInd1 ^ charAtInd2: solution += 1
		
	return solution
