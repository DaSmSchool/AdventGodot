extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var currentNum: int = 0
var timesSaid: int = 0
var saidIndex: Dictionary = {}

func said_to_index() -> void:
	if saidIndex.has(currentNum):
		saidIndex[currentNum].push_back(timesSaid)
	else:
		saidIndex.get_or_add(currentNum, [timesSaid])

func say_number(num: int) -> void:
	currentNum = num
	timesSaid += 1
	said_to_index()

func solve1(input: String) -> int:
	var solution: int = 0
	
	var startingNums: PackedStringArray = input.split(",")
	
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	return solution
