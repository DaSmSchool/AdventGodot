extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_group(yPos: int, xPos: int, grid: Array) -> Array:
	var returnGrid: Array = []
	var grabbedGrid: Array[Vector2i] = [Vector2i(xPos, yPos)]
	
	while grabbedGrid.size() != 0:
		var focusPoints: Array[Vector2i] = grabbedGrid.duplicate(true)
		grabbedGrid = []
		for point: Vector2i in focusPoints:
			for yInd: int in range(-1, 2, 1):
				for xInd: int in range(-1, 2, 1):
					if abs(yInd) != abs(xInd) and Helper.valid_pos_at_grid(point.y+yInd, point.x+xInd, grid):
						if grid[point.y][point.x] == grid[point.y+yInd][point.x+xInd]:
							grabbedGrid.append(Vector2(point.x+xInd, point.y+yInd))

		returnGrid.append_array(grabbedGrid)
	
	return returnGrid

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
	
	var groupsMade: Dictionary = {}
	var gardenIndLists: Array = []
	
	var assignGroup: String = grid[0][0]
	groupsMade
	
	for lineInd: int in grid.size():
		for charInd in grid[0].size():
			
			
	
	
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
