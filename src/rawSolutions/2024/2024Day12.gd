extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var splitInput: PackedStringArray = input.split("\n")
	var grid: Array = []
	var untrackedInds: Dictionary = {}
	
	
	for lineInd: int in splitInput.size():
		if splitInput[lineInd] == "": continue
		for charInd: int in splitInput[lineInd].length():
			grid.append(splitInput[lineInd][charInd])
			untrackedInds.get_or_add([charInd, lineInd])
	
	
	
	
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution