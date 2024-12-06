extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_ord_rules(section: String) -> Dictionary:
	var dictAssemble: Dictionary = {}
	
	for line: String in section.split("\n"):
		#print(line)
		var nums: PackedStringArray = line.split("|")
		#print(nums)
		if dictAssemble.has(nums[0].to_int()):
			var prevList: Array = dictAssemble[nums[0].to_int()]
			prevList.append(nums[1].to_int())
		else:
			var numList: Array = []
			numList.append(nums[1].to_int())
			dictAssemble.get_or_add(nums[0].to_int(), numList)
	
	return dictAssemble


func get_updates(section: String) -> Array:
	var dictAssemble: Array = []
	
	for line: String in section.split("\n"):
		if line == "": continue
		
		var updateValList: Array[int] = []
		var updateVals: PackedStringArray = line.split(",")
		for rawVal: String in updateVals: updateValList.append(rawVal.to_int())
		dictAssemble.append(updateValList)
	
	return dictAssemble

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSections: PackedStringArray = input.split("\n\n")
	#print(inputSections[0])
	
	var pageOrdRules: Dictionary = {}
	var updates: Array = []
	var validUpdates: Array = []
	
	pageOrdRules = get_ord_rules(inputSections[0])
	updates = get_updates(inputSections[1])
	
	for upd: Array[int] in updates:
		var isValid: bool = true
		for val: int in upd:
			if pageOrdRules.has(val):
				var compareIndArray: Array = pageOrdRules[val]
				#print(pageOrdRules)
				for cmp: int in compareIndArray:
					if upd.has(cmp):
						if upd.find(val) < upd.find(cmp):
							pass
						else: 
							isValid = false
							break
				if !isValid: break
		if isValid: validUpdates.append(upd)
	
	#print(validUpdates)
	
	for update: Array in validUpdates:
		solution += update[floor(update.size()/2)]
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSections: PackedStringArray = input.split("\n\n")
	#print(inputSections[0])
	
	var pageOrdRules: Dictionary = {}
	var updates: Array = []
	var validUpdates: Array = []
	var invalidUpdates: Array = []
	
	pageOrdRules = get_ord_rules(inputSections[0])
	updates = get_updates(inputSections[1])
	
	for upd: Array[int] in updates:
		var isValid: bool = true
		for val: int in upd:
			if pageOrdRules.has(val):
				var compareIndArray: Array = pageOrdRules[val]
				#print(pageOrdRules)
				for cmp: int in compareIndArray:
					if upd.has(cmp):
						if upd.find(val) < upd.find(cmp):
							pass
						else: 
							isValid = false
							break
				if !isValid: break
		if isValid: validUpdates.append(upd)
		else: invalidUpdates.append(upd)
	
	# bubble sort based off presence in pageOrdRules
	for update in invalidUpdates:
		var needSort: bool = true
		while needSort:
			needSort = false
			for ind in range(0, update.size()-1):
				if pageOrdRules[update[ind+1]].has(update[ind]):
					var swapTransfer = update[ind+1]
					update[ind+1] = update[ind]
					update[ind] = swapTransfer
					needSort = true
	
	for update: Array in invalidUpdates:
		solution += update[floor(update.size()/2)]
	
	return solution
	
