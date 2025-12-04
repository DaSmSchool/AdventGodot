extends Solution

var colorLimit: Dictionary = {
	"red": 12,
	"green": 13,
	"blue": 14,
}

func parse_games(input: String) -> Array[Dictionary]:
	var gameArray: Array[Dictionary] = []
	for gameLine: String in input.split("\n", false):
		var gameSplit: PackedStringArray = gameLine.split(": ")
		var matchesSplit: PackedStringArray = gameSplit[1].split("; ")
		var gameDict: Dictionary = {}
		for gameMatch: String in matchesSplit:
			var cubesSplit: PackedStringArray = gameMatch.split(", ")
			for cubeSplit: String in cubesSplit:
				var amountSplit: PackedStringArray = cubeSplit.split(" ")
				if not gameDict.has(amountSplit[1]):
					gameDict[amountSplit[1]] = []
				gameDict[amountSplit[1]].append(amountSplit[0].to_int())
		gameArray.append(gameDict)
	return gameArray

func is_game_valid(game: Dictionary) -> bool:
	for color: String in colorLimit:
		if game[color].max() > colorLimit[color]:
			return false
	return true

func get_factor(game: Dictionary) -> int:
	var factor: int = 1
	for color: String in colorLimit:
		factor *= game[color].max()
	return factor

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var gamesList: Array[Dictionary] = parse_games(input)
	for gameInd: int in gamesList.size():
		if is_game_valid(gamesList[gameInd]):
			solution += gameInd+1
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var gamesList: Array[Dictionary] = parse_games(input)
	for gameInd: int in gamesList.size():
		solution += get_factor(gamesList[gameInd])
	
	return solution
