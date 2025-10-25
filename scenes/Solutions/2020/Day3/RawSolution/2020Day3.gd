extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var slopeSet: Array = [
	[1, 1],
	[3, 1],
	[5, 1],
	[7, 1],
	[1, 2]
]

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var posX: int = 0
	
	for line: String in inputLines:
		if line == "" or line == inputLines[0]: continue
		var focusX: int = posX + 3
		
		if focusX >= line.length(): focusX -= line.length()
		if line[focusX] == "#": solution += 1
		
		posX = focusX
		
	return solution

func check_slope_trees(input: PackedStringArray, xShift: int, yShift: int):
	var slopes: int = 0
	
	var posX: int = 0
	
	for yInd in range(yShift, input.size(), yShift):
		if input[yInd] == "": continue
		var focusX: int = posX + xShift
		
		if focusX >= input[yInd].length(): focusX -= input[yInd].length()
		if input[yInd][focusX] == "#": slopes += 1
		
		posX = focusX
	
	return slopes

func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	for slope in slopeSet:
		if slope == slopeSet[0]: solution = check_slope_trees(inputLines, slope[0], slope[1])
		else: solution *= check_slope_trees(inputLines, slope[0], slope[1])
		
	return solution
