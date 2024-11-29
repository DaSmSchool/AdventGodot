extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func solve1(input: String) -> int:
	var solution: int = 0
	
	var groupList: Array = []
	var currGroup: Array[String] = []
	
	var inputLines: PackedStringArray = input.split("\n")
	for line in inputLines:
		if line == "":
			groupList.push_front(currGroup)
			currGroup = []
			continue
		for answer in line:
			if !currGroup.has(answer):
				currGroup.push_front(answer)
	
	for group: Array[String] in groupList:
		solution += group.size()
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	
	var groupList: Array = []
	var groupCounts: Array[int] = [0]
	var currGroup: Dictionary = {}
	
	var inputLines: PackedStringArray = input.split("\n")
	for line in inputLines:
		if line == "":
			groupList.push_back(currGroup)
			currGroup = {}
			groupCounts.push_back(0)
			continue
		else:
			groupCounts[groupCounts.size()-1] += 1
		
		for answer in line:
			if currGroup.has(answer):
				currGroup[answer] += 1
			else:
				currGroup.get_or_add(answer, 1)

	var groupCount: int = 0
	for group: Dictionary in groupList:
		for answer in group.keys():
			if group.get(answer) == groupCounts[groupCount]:
				solution += 1
		
		groupCount += 1
		
	return solution
