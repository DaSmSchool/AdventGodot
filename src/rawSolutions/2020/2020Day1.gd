extends Solution

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func solve1(input: String) -> int:
	var solution: int = 0
	var splitInput: PackedStringArray = input.split("\n")
	
	for line1 in splitInput:
		var n1 = line1.to_int()
		for line2 in splitInput:
			var n2 = line2.to_int()
			if n1 == n2:
				if n1 == 1010:
					return n1*n1
				continue
			
			if n1 + n2 == 2020:
				return n1*n2
	
	return solution

func solve2(input: String) -> int:
	var solution: int = 0
	var splitInput: PackedStringArray = input.split("\n")
	
	for line1 in splitInput:
		var n1 = line1.to_int()
		for line2 in splitInput:
			var n2 = line2.to_int()
			for line3 in splitInput:
				var n3 = line3.to_int()
				if n1 + n2 + n3 == 2020:
					return n1*n2*n3
	
	return solution
