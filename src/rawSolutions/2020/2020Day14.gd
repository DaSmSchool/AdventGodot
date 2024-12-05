extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_with_mask(num: int, mask: String) -> int:
	var maskedNum: int = 0
	var longMask: String = mask.lpad(64, "X")
	var longNum: String = String.num_uint64(num, 2).lpad(64, "0")
	
	print(longMask)
	print(longNum)
	
	var assembleNum: String = ""
	for digitInd: int in longNum.length():
		if longMask[digitInd] != "X":
			assembleNum += longMask[digitInd]
		else:
			assembleNum += longNum[digitInd]
	
	maskedNum = assembleNum.bin_to_int()
	
	return maskedNum

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
	
	print(maskDict)
	print(assignDict)
	
	var programCounter: int = 0
	var accumulator: int = 0
	var bitMask: String
	var memory: Dictionary = {}
	
	while maskDict.has(programCounter) or assignDict.has(programCounter):
		if maskDict.has(programCounter):
			bitMask = maskDict.get(programCounter)
		else:
			var setInstrSet: Array = assignDict.get(programCounter)
			var maskedNum: int = add_with_mask(setInstrSet[1], bitMask)
			memory.get_or_add(setInstrSet[0], maskedNum)
		programCounter += 1
	
	for num in memory:
		solution += memory[num]
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
