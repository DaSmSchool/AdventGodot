extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func button_split(str: String) -> Array:
	var buttonSplit: PackedStringArray = str.split(" ")
	var buttonVec: Array = [0, 0]
	buttonVec[0] = buttonSplit[2].substr(2, buttonSplit[2].length()-1).to_int()
	buttonVec[1] = buttonSplit[3].substr(2).to_int()
	return buttonVec


func target_split(str: String) -> Array:
	var buttonSplit: PackedStringArray = str.split(" ")
	var buttonVec: Array = [0, 0]
	buttonVec[0] = buttonSplit[1].substr(2, buttonSplit[1].length()-1).to_int()
	buttonVec[1] = buttonSplit[2].substr(2).to_int()
	return buttonVec


func solve1(input: String) -> int:
	var solution: int = 0
	
	var sectionSplit: PackedStringArray = input.split("\n\n")
	var clawGames: Array = []
	
	for section: String in sectionSplit:
		var sectionString: PackedStringArray = section.split("\n")
		var aButton: Array = button_split(sectionString[0])
		var bButton: Array = button_split(sectionString[1])
		var tgtArea: Array = target_split(sectionString[2])
		#print(aButton)
		#print(bButton)
		#print(tgtArea)
		#print()
		clawGames.append([aButton, bButton, tgtArea])
	
	for game: Array in clawGames:
		# formula garbage
		# made from the sample input, which I turned into (94x + 22y = 8400) and (34x + 67y = 5400) then worked with it until i found an equation that equated both to each other
		var foundBPresses: float = ((game[0][0]*game[2][1]) - (game[0][1]*game[2][0])) / ((game[0][1]*game[1][0]) - (game[0][0]*game[1][1])) * -1
		var foundAPresses: float = ((game[1][0]*game[2][1]) - (game[1][1]*game[2][0])) / ((game[1][0]*game[0][1]) - (game[1][1]*game[0][0]))
		
		#print(foundAPresses)
		#print(game[1].x)
		#print(foundAPresses*game[1].x)
		#print(foundBPresses*game[0].x)
		#print(foundAPresses*game[1].x + foundBPresses*game[0].x)
		#print(game[2].x)
		#print("||||")
		#print(foundAPresses)
		#print(game[1].y)
		#print(foundAPresses*game[1].y)
		#print(foundBPresses*game[0].y)
		#print(foundAPresses*game[1].y + foundBPresses*game[0].y)
		#print(game[2].y)
		#print()
		
		if foundBPresses*game[1][0] + foundAPresses*game[0][0] == game[2][0] and foundBPresses*game[1][1] + foundAPresses*game[0][1] == game[2][1]:
			print("(%s, %s)" % [str(foundAPresses), str(foundBPresses)])
			solution += foundAPresses*3
			solution += foundBPresses
		
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var sectionSplit: PackedStringArray = input.split("\n\n")
	var clawGames: Array = []
	
	for section: String in sectionSplit:
		var sectionString: PackedStringArray = section.split("\n")
		var aButton: Array = button_split(sectionString[0])
		var bButton: Array = button_split(sectionString[1])
		var tgtArea: Array = target_split(sectionString[2])
		tgtArea[0] += 10000000000000
		tgtArea[1] += 10000000000000
		clawGames.append([aButton, bButton, tgtArea])
	
	for game: Array in clawGames:
		# formula garbage
		# made from the sample input, which I turned into (94x + 22y = 8400) and (34x + 67y = 5400) then worked with it until i found an equation that equated both to each other
		var foundBPresses: float = ((game[0][0]*game[2][1]) - (game[0][1]*game[2][0])) / ((game[0][1]*game[1][0]) - (game[0][0]*game[1][1])) * -1
		var foundAPresses: float = ((game[1][0]*game[2][1]) - (game[1][1]*game[2][0])) / ((game[1][0]*game[0][1]) - (game[1][1]*game[0][0]))
		
		if foundBPresses*game[1][0] + foundAPresses*game[0][0] == game[2][0] and foundBPresses*game[1][1] + foundAPresses*game[0][1] == game[2][1]:
			print("(%s, %s)" % [str(foundAPresses), str(foundBPresses)])
			solution += foundAPresses*3
			solution += foundBPresses
		
	
	return solution
