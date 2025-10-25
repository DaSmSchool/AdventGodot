extends Solution

# the best advent solutions are the ones you come up with while you are at a christmas party

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	var computers: Dictionary = {}
	for line: String in inputSplit:
		if line == "": continue
		var lineComputers: PackedStringArray = line.split("-")
		
		if computers.get(lineComputers[0], []) == []:
			computers.get_or_add(lineComputers[0], [lineComputers[1]])
		else:
			computers[lineComputers[0]].append(lineComputers[1])
			
		if computers.get(lineComputers[1], []) == []:
			computers.get_or_add(lineComputers[1], [lineComputers[0]])
		else:
			computers[lineComputers[1]].append(lineComputers[0])
	
	var trios: Array = []
	
	for computer: String in computers.keys():
		for connected: String in computers[computer]:
			for focus: String in computers[computer]:
				if focus == connected: continue
				var compareArray: = [computer, connected, focus]
				compareArray.sort()
				if computers[focus].has(connected):
					var hasCombo: bool = false
					for trio: Array in trios:
						if trio == compareArray:
							hasCombo = true
							break
					if !hasCombo: 
						var trioList: Array = [computer, connected, focus]
						trioList.sort()
						trios.append(trioList)
	
	for trio: Array in trios:
		for computer: String in trio:
			if computer[0] == "t":
				solution += 1
				break
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	var computers: Dictionary = {}
	for line: String in inputSplit:
		if line == "": continue
		var lineComputers: PackedStringArray = line.split("-")
		
		if computers.get(lineComputers[0], []) == []:
			computers.get_or_add(lineComputers[0], [lineComputers[1]])
		else:
			computers[lineComputers[0]].append(lineComputers[1])
			
		if computers.get(lineComputers[1], []) == []:
			computers.get_or_add(lineComputers[1], [lineComputers[0]])
		else:
			computers[lineComputers[1]].append(lineComputers[0])
	
	var biggestInComputers: Array = []
	
	# gets an array of the biggest group that a computer belongs to
	for computer: String in computers:
		
		# get mutable list of connected neighbors
		var connectedComputers: Array = computers[computer].duplicate()
		# valid computers in group
		var computersInGroup: Array = []
		
		# checking all computers
		while connectedComputers.size() != 0:
			
			# get the first computer to check against whatever remains in the list
			var focusComputer: String = connectedComputers[0]
			connectedComputers = connectedComputers.slice(1)
			
			# if the rest of the computers aren't connected to the focus computer, remove them
			var computersToRemove: Array = []
			for computerCheck: String in connectedComputers:
				if !computers[focusComputer].has(computerCheck):
					computersToRemove.append(computerCheck)
			
			# if any computers are removed, recheck the focus later, otherwise add as valid
			if computersToRemove.is_empty():
				computersInGroup.append(focusComputer)
			else:
				for removeComp: String in computersToRemove:
					connectedComputers.erase(removeComp)
				connectedComputers.append(focusComputer)
		
		computersInGroup.append(computer)
		computersInGroup.sort()
		
		biggestInComputers.append(computersInGroup)
		
	var biggestComputerSet: Array = biggestInComputers.reduce(func(accum, focus): return focus if focus.size()>accum.size() else accum, biggestInComputers[0])
	
	#print(biggestComputerSet)
	var assembleAnswer: String = ""
	
	for computer: String in biggestComputerSet:
		assembleAnswer += computer + ","
	assembleAnswer = assembleAnswer.substr(0, assembleAnswer.length()-1)
	
	print(assembleAnswer)
	
	return solution
