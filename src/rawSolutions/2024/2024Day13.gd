extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func button_split(str: String) -> Vector2i:
	var buttonSplit: PackedStringArray = str.split(" ")
	var buttonVec: Vector2i = Vector2()
	buttonVec.x = buttonSplit[2].substr(2, buttonSplit[2].length()-1).to_int()
	buttonVec.y = buttonSplit[3].substr(2).to_int()
	return buttonVec


func target_split(str: String) -> Vector2i:
	var buttonSplit: PackedStringArray = str.split(" ")
	var buttonVec: Vector2i = Vector2()
	buttonVec.x = buttonSplit[1].substr(2, buttonSplit[1].length()-1).to_int()
	buttonVec.y = buttonSplit[2].substr(2).to_int()
	return buttonVec


func solve1(input: String) -> int:
	var solution: int = 0
	
	var sectionSplit: PackedStringArray = input.split("\n\n")
	var clawGames: Array = []
	
	for section: String in sectionSplit:
		var sectionString: PackedStringArray = section.split("\n")
		var aButton: Vector2i = button_split(sectionString[0])
		var bButton: Vector2i = button_split(sectionString[1])
		var tgtArea: Vector2i = target_split(sectionString[2])
		#print(aButton)
		#print(bButton)
		#print(tgtArea)
		#print()
		clawGames.append([aButton, bButton, tgtArea])
	
	for game: Array in clawGames:
		var totalPossiblePos: Array[Vector2i] = []
		var xPossiblePos: Array[Vector2i] = []
		var yPossiblePos: Array[Vector2i] = []
		for xTry in range(0, 101):
			if (game[2]-game[0]*xTry) % game[1] == 0:
				
	
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
