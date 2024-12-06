extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func solve1(input: String) -> int:
	var seatIds: Array[int] = []
	
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	for line in inputLines:
		if line == "": continue
		var row: int = 0
		for i in range(7):
			if line[6-i] == "B":
				row += pow(2, i)
		
		var seat: int = 0
		for i in range(3):
			if line[9-i] == "R":
				seat += pow(2, i)
		
		seatIds.push_front(row*8 + seat)
	
	seatIds.sort()
	
	solution = seatIds.max()	
	return solution


func solve2(input: String) -> int:
	var seatIds: Array[int] = []
	
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	for line in inputLines:
		if line == "": continue
		var row: int = 0
		for i in range(7):
			if line[6-i] == "B":
				row += pow(2, i)
		
		var seat: int = 0
		for i in range(3):
			if line[9-i] == "R":
				seat += pow(2, i)
		
		seatIds.push_front(row*8 + seat)
	
	seatIds.sort()
	print(seatIds)
	
	for id in range(1, seatIds.size()-1):
		if (seatIds[id+1] - seatIds[id-1]) == 3: solution = seatIds[id]-1
	
	return solution
