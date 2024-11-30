extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var shipDirection1: String = "E"
var shipX1: int = 0
var shipY1: int = 0

static var directions: Array = ["N", "E", "S", "W"]

func move1_N(amount: int) -> void:
	shipY1 += amount
	

func move1_E(amount: int) -> void:
	shipX1 += amount
	

func move1_S(amount: int) -> void:
	shipY1 -= amount
	

func move1_W(amount: int) -> void:
	shipX1 -= amount
	
func move_dir1(dir: String, amount: int) -> void:
	var moveMethod: Callable = Callable(self, "move1_"+dir)
	moveMethod.call(amount)

func solve1(input: String) -> int:
	var solution: int = 0
	
	var instructions: Array = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	for line in inputSplit:
		if line == "": continue
		var instrSet = []
		instrSet.append(line[0])
		instrSet.append(line.substr(1).to_int())
		instructions.append(instrSet)
	
	for instruction: Array in instructions:
		if instruction[0] == "L":
			var shipDirInd: int = directions.find(shipDirection1)
			shipDirInd -= int((instruction[1]%360)/90)
			if shipDirInd < 0:
				shipDirInd += 4
			shipDirection1 = directions[shipDirInd]
		elif instruction[0] == "R":
			var shipDirInd: int = directions.find(shipDirection1)
			shipDirInd += int((instruction[1]%360)/90)
			if shipDirInd > 3:
				shipDirInd -= 4
			shipDirection1 = directions[shipDirInd]
		elif instruction[0] == "F":
			move_dir1(shipDirection1, instruction[1])
		else:
			move_dir1(instruction[0], instruction[1])
	
	solution = abs(shipX1) + abs(shipY1)
	
	return solution

var shipDirection2: String = "E"
var shipX2: int = 0
var shipY2: int = 0
var waypointX: int = 10
var waypointY: int = 1

func move2_N(amount: int) -> void:
	waypointY += amount
	

func move2_E(amount: int) -> void:
	waypointX += amount
	

func move2_S(amount: int) -> void:
	waypointY -= amount
	

func move2_W(amount: int) -> void:
	waypointX -= amount
	
	
func move_dir2(dir: String, amount: int) -> void:
	var moveMethod: Callable = Callable(self, "move2_"+dir)
	moveMethod.call(amount)


func solve2(input: String) -> int:
	var solution: int = 0
	
	var instructions: Array = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	for line in inputSplit:
		if line == "": continue
		var instrSet = []
		instrSet.append(line[0])
		instrSet.append(line.substr(1).to_int())
		instructions.append(instrSet)
	
	for instruction: Array in instructions:
		var wayOffX: int = waypointX - shipX2
		var wayOffY: int = waypointY - shipY2
		if instruction[0] == "R":
			for i in int(instruction[1]/90):
				wayOffX = waypointX - shipX2
				wayOffY = waypointY - shipY2
				waypointX = shipX2 + wayOffY
				waypointY = shipY2 - wayOffX
		elif instruction[0] == "L":
			for i in int(instruction[1]/90):
				wayOffX = waypointX - shipX2
				wayOffY = waypointY - shipY2
				waypointX = shipX2 - wayOffY
				waypointY = shipY2 + wayOffX
		elif instruction[0] == "F":
			for i in instruction[1]:
				waypointX += wayOffX
				waypointY += wayOffY
				shipX2 += wayOffX
				shipY2 += wayOffY
		else:
			move_dir2(instruction[0], instruction[1])
		print("WP: (" + str(waypointX) + ", " + str(waypointY) + ")")
		print("SHIP: (" + str(shipX2) + ", " + str(shipY2) + ")")
	
	solution = abs(shipX2) + abs(shipY2)
	
	return solution
