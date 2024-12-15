extends Solution

@export var areaDims: Vector2i = Vector2i(11, 7)
@export var waitSeconds: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var robots: Array = []
	
	
	for line: String in inputSplit:
		if line == "": continue
		var robot: Array = []
		
		var lineSplit: PackedStringArray = line.split(" ")
		var posSplit: PackedStringArray = lineSplit[0].split(",")
		var velSplit: PackedStringArray = lineSplit[1].split(",")
		var robotPos: Vector2i = Vector2i(posSplit[0].substr(2).to_int(), posSplit[1].to_int())
		var robotVel: Vector2i = Vector2i(velSplit[0].substr(2).to_int(), velSplit[1].to_int())
		
		#print(robotPos)
		#print(robotVel)
		#print()
		
		robot.append(robotPos)
		robot.append(robotVel)
		robots.append(robot)
	
	var postMovePositions: Array[Vector2i] = []
	var robotsInQuadrants: Array = [[], [], [], []]
	
	for robot: Array in robots:
		var movedX = robot[0].x
		var movedY = robot[0].y
		
		for second: int in waitSeconds:
			movedX += robot[1].x
			movedY += robot[1].y
			if movedX < 0:
				movedX = (areaDims.x+movedX)
			elif movedX >= areaDims.x:
				movedX = movedX-areaDims.x
			if movedY < 0:
				movedY = (areaDims.y+movedY)
			elif movedY >= areaDims.y:
				movedY = movedY-areaDims.y
			#print([movedX, movedY])
		postMovePositions.append(Vector2i(movedX, movedY))
	
	#print("____")
	
	#print((areaDims.y-1)/2)
	#print((areaDims.x-1)/2)
	
	for robot: Vector2i in postMovePositions:
		#print(robot)
		
		if robot.y < (areaDims.y-1)/2:
			if robot.x < (areaDims.x-1)/2:
				robotsInQuadrants[0].append(robot)
			elif robot.x > (areaDims.x-1)/2:
				robotsInQuadrants[1].append(robot)
		elif robot.y > (areaDims.y-1)/2:
			if robot.x < (areaDims.x-1)/2:
				robotsInQuadrants[2].append(robot)
			elif robot.x > (areaDims.x-1)/2:
				robotsInQuadrants[3].append(robot)
	
	solution = 1
	for quadrant: Array in robotsInQuadrants:
		#print(quadrant)
		solution *= quadrant.size()
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var robots: Array = []
	
	
	
	for line: String in inputSplit:
		if line == "": continue
		var robot: Array = []
		
		var lineSplit: PackedStringArray = line.split(" ")
		var posSplit: PackedStringArray = lineSplit[0].split(",")
		var velSplit: PackedStringArray = lineSplit[1].split(",")
		var robotPos: Vector2i = Vector2i(posSplit[0].substr(2).to_int(), posSplit[1].to_int())
		var robotVel: Vector2i = Vector2i(velSplit[0].substr(2).to_int(), velSplit[1].to_int())
		
		#print(robotPos)
		#print(robotVel)
		#print()
		
		robot.append(robotPos)
		robot.append(robotVel)
		robots.append(robot)
	
	
	var maxVariance: int = 0
	var secondsSinceLastMaxVariance: int = 0
	var secondsAtMaxVariance = 0
	var secondsPassed = 0
	
	while secondsSinceLastMaxVariance < 5000:
		#print("Max: %d" % maxVariance)
		#print("Seconds at Max: %d" % secondsAtMaxVariance)
		#print("Seconds since last Max: %d" % secondsSinceLastMaxVariance)
		#print("Seconds Passed: %d" % secondsPassed)
		
		secondsPassed += 1
		var secondTotalVariance: int = 0
		
		var robotsAtX: Array = []
		var robotsAtY: Array = []
		
		for x in areaDims.x:
			robotsAtX.append([])
		for y in areaDims.y:
			robotsAtY.append([])
		
		for robot: Array in robots:
			robot[0].x += robot[1].x
			robot[0].y += robot[1].y
			if robot[0].x < 0:
				robot[0].x = (areaDims.x+robot[0].x)
			elif robot[0].x >= areaDims.x:
				robot[0].x = robot[0].x-areaDims.x
			if robot[0].y < 0:
				robot[0].y = (areaDims.y+robot[0].y)
			elif robot[0].y >= areaDims.y:
				robot[0].y = robot[0].y-areaDims.y
			
			robotsAtX[robot[0].x].append(robot[0].y)
			robotsAtY[robot[0].y].append(robot[0].x)
		
		#for x in robotsAtX.size():
			#print("%d: %s" % [x, str(robotsAtX[x])])
		
		for robot: Array in robots:
			var robotVariance: int = 0
			
			for focusY: int in robotsAtX[robot[0].x]:
				if abs(robot[0].y - focusY) == 1:
					robotVariance += 1
			for focusX: int in robotsAtY[robot[0].y]:
				if abs(robot[0].x - focusX) == 1:
					robotVariance += 1
			secondTotalVariance += pow(robotVariance, 2)
		
		if secondTotalVariance > maxVariance:
			maxVariance = secondTotalVariance
			secondsAtMaxVariance = secondsPassed
			secondsSinceLastMaxVariance = 0
		else:
			secondsSinceLastMaxVariance += 1
	
	solution = secondsAtMaxVariance
	
	return solution
