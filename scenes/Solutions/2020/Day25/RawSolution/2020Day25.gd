extends Solution


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	
	var cardPublic: int = inputSplit[0].to_int()
	var doorPublic: int = inputSplit[1].to_int()
	var cardLoop: int = 0
	
	var testRound: int = 1
	while testRound != cardPublic:
		testRound *= 7
		testRound %= 20201227
		cardLoop += 1
	
	testRound = 1
	for i: int in range(cardLoop):
		testRound *= doorPublic
		testRound %= 20201227
	
	return testRound

func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
