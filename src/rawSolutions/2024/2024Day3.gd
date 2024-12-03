extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("mul(")
	
	var multSum: int = 0
	for line: String in inputSplit:
		#print(line)
		var funEnd: int = line.find(")")
		if funEnd != -1:
			var cutLine: String = line.substr(0, funEnd)
			#print(cutLine)
			var comInd: int = cutLine.find(",")
			if comInd != -1:
				var splitParams: PackedStringArray = cutLine.split(",")
				#print(splitParams)
				#print(splitParams[0].is_valid_int())
				#print(splitParams[1].is_valid_int())
				if splitParams[0].is_valid_int() and splitParams[1].is_valid_int():
					multSum += splitParams[0].to_int() * splitParams[1].to_int()
		#print()
	
	solution = multSum
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	
	return solution
