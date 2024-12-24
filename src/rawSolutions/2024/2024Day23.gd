extends Solution


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
	
	
	
	return solution
