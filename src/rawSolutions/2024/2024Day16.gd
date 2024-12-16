extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var grid: Array = []
	
	for row in input.split(""):
		if row == "": continue
		grid.append(row.split(""))
	
	var unvisitedSpots: Dictionary = {}
	var reindeerStart: Vector2i = Vector2i()
	var finishPos: Vector2i = Vector2i()
	
	for rowInd: int in grid.size():
		for charInd: int in grid[rowInd].size():
			if grid[rowInd][charInd] == ".":
				unvisitedSpots.get_or_add(Vector2i(charInd, rowInd), INF)
			elif grid[rowInd][charInd] == "S":
				reindeerStart = Vector2i(charInd, rowInd)
			elif grid[rowInd][charInd] == "E":
				finishPos = Vector2i(charInd, rowInd)
	
	
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
