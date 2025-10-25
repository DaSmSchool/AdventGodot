extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var lastNum: int = 0
var currentNum: int = 0
var timesSaid: int = 0
var saidIndex: Dictionary = {}

func said_to_index(readingStarts: bool) -> void:
	if saidIndex.has(currentNum):
		saidIndex[currentNum].append(timesSaid)
		currentNum = saidIndex[currentNum][-1] - saidIndex[currentNum][-2]
	else:
		saidIndex.get_or_add(currentNum, [timesSaid])
		if !readingStarts:
			currentNum = 0

func say_number(num: int, readingStarts: bool) -> void:
	currentNum = num
	timesSaid += 1
	said_to_index(readingStarts)

func solve1(input: String) -> int:
	
	lastNum = 0
	currentNum = 0
	timesSaid = 0
	saidIndex = {}
	
	var solution: int = 0
	
	var startingNums: PackedStringArray = input.substr(0, input.length()-1).split(",")
	
	for numInd: int in startingNums.size()-1:
		say_number(startingNums[numInd].to_int(), true)
	
	say_number(startingNums[startingNums.size()-1].to_int(), false)
	
	while timesSaid < 2020:
		lastNum = currentNum
		say_number(currentNum, false)
	
	solution = lastNum
	
	return solution

# not gonna bother if it works, i just need to wait a minute or so
func solve2(input: String) -> int:
	
	lastNum = 0
	currentNum = 0
	timesSaid = 0
	saidIndex = {}
	
	var solution: int = 0
	
	var startingNums: PackedStringArray = input.substr(0, input.length()-1).split(",")
	
	for numInd: int in startingNums.size()-1:
		say_number(startingNums[numInd].to_int(), true)
	
	say_number(startingNums[startingNums.size()-1].to_int(), false)
	
	while timesSaid < 30000000:
		lastNum = currentNum
		say_number(currentNum, false)
	
	solution = lastNum
	
	return solution
