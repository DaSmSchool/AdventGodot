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
	
	var maskDict: Dictionary = {}
	var assignDict: Dictionary = {}
	
	for lineInd: int in inputSplit.size()-1:
		var line: String = inputSplit[lineInd]
		if line.contains("mask = "):
			maskDict.get_or_add(lineInd, line.substr(7))
			print(maskDict[maskDict.keys().back()])
		elif line.contains("mem["):
			assignDict.get_or_add(lineInd, [line.substr(4, line.find("]")-4).to_int(), line.substr(line.find("] = ")+4).to_int()])
			print(assignDict[assignDict.keys().back()])
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
