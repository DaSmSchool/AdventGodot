extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSections: PackedStringArray = input.split("\n\n")
	print(inputSections[0])
	
	var pageOrdRules: Dictionary = {}
	var pageOrdRulesRev: Dictionary = {}
	var updates: Array = []
	var validUpdates: Array = []
	
	for line: String in inputSections[0].split("\n"):
		#print(line)
		var nums: PackedStringArray = line.split("|")
		#print(nums)
		if pageOrdRules.has(nums[0].to_int()):
			var prevList: Array = pageOrdRules[nums[0].to_int()]
			prevList.append(nums[1].to_int())
		else:
			var numList: Array = []
			numList.append(nums[1].to_int())
			pageOrdRules.get_or_add(nums[0].to_int(), numList)
		
		if pageOrdRulesRev.has(nums[1].to_int()):
			var prevList: Array = pageOrdRulesRev[nums[1].to_int()]
			prevList.append(nums[0].to_int())
		else:
			var numList: Array = []
			numList.append(nums[0].to_int())
			pageOrdRulesRev.get_or_add(nums[1].to_int(), numList)
	
	for line: String in inputSections[1].split("\n"):
		if line == "": continue
		
		var updateValList: Array[int] = []
		var updateVals: PackedStringArray = line.split(",")
		for rawVal: String in updateVals: updateValList.append(rawVal.to_int())
		updates.append(updateValList)
	
	print("ASDASD" + str(updates))
	
	for upd: Array[int] in updates:
		var isValid: bool = true
		for val: int in upd:
			if pageOrdRules.has(val):
				var compareIndArray: Array = pageOrdRules[val]
				print(pageOrdRules)
				for cmp: int in compareIndArray:
					if upd.has(cmp) and upd.find(val) < upd.find(cmp):
						pass
					else: 
						isValid = false
						break
				if !isValid: break
		if isValid: validUpdates.append(upd)
	
	print(validUpdates)
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	return solution
	
