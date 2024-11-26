extends Solution

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func solve(input: String) -> int:
	var solution: int = 0
	var splitInput: PackedStringArray = input.split("\n")
	var num1: String
	var num2: String
	
	for line1 in splitInput:
		for line2 in splitInput:
			if line1.hash() == line2.hash():
				if line1.to_int() == 1010:
					num1 = line1
					num2 = line2
					break
				continue
			
	
	return solution
