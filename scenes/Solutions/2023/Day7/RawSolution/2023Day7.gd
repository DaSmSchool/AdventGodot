extends Solution

const cardPrecedence: Dictionary[String, int] = {
	"A": 14,
	"K": 13,
	"Q": 12,
	"J": 11,
	"T": 10,
	"9": 9,
	"8": 8,
	"7": 7,
	"6": 6,
	"5": 5,
	"4": 4,
	"3": 3,
	"2": 2,
	"1": 1,
}

const cardPrecedence2: Dictionary[String, int] = {
	"A": 14,
	"K": 13,
	"Q": 12,
	"T": 10,
	"9": 9,
	"8": 8,
	"7": 7,
	"6": 6,
	"5": 5,
	"4": 4,
	"3": 3,
	"2": 2,
	"1": 1,
	"J": 0,
}

func populate_data(input: String, hands: Dictionary[String, Array], cardsToBids: Dictionary[String, int], p2: bool) -> void:
	var inputSplit: PackedStringArray = input.split("\n", false)
	for rawHand: String in inputSplit:
		var splitPart: PackedStringArray = rawHand.split(" ", false)
		cardsToBids[splitPart[0]] = splitPart[1].to_int()
		var handType: String = evaluate_hand(splitPart[0], p2)
		print_log(splitPart[0] + " : " + handType)
		hands[handType].append(splitPart[0])

func evaluate_hand(hand: String, p2: bool) -> String:
	var cardCount: Array = Array(hand.split("", false)).map(func(s): return hand.count(s))
	#print_log(cardCount)
	var cardCountDict: Dictionary[String, int] = {}
	for cardInd: int in cardCount.size():
		cardCountDict[hand[cardInd]] = cardCount[cardInd]
		
	var jCount: int = 0
	if p2 and cardCountDict.has("J"):
		jCount = cardCountDict["J"]
		cardCountDict.erase("J")
		
	var shortenedValues: Array = cardCountDict.values()
	
	# JJJJJ case in part 2
	if p2 and shortenedValues.size() == 0:
		return "5"
	
	var mostCardAmount: int = shortenedValues.max()
	var maxInd: int = shortenedValues.find(mostCardAmount)
	shortenedValues[maxInd] += jCount
	mostCardAmount += jCount
	match mostCardAmount:
		5:
			return "5"
		4:
			return "4"
		3:
			if shortenedValues.has(2):
				return "F"
			return "3"
		2:
			if cardCount.count(2) == 4:
				return "2"
			else:
				return "1"
		1:
			return "H"
	return ""

func sort_individual_hand(a: String, b: String) -> bool:
	for ind: int in a.length():
		var cardAScore: int = cardPrecedence[a[ind]]
		var cardBScore: int = cardPrecedence[b[ind]]
		if cardAScore != cardBScore:
			if max(cardAScore, cardBScore) == cardBScore:
				return false
			else:
				return true
	return false

func sort_individual_hand2(a: String, b: String) -> bool:
	for ind: int in a.length():
		var cardAScore: int = cardPrecedence2[a[ind]]
		var cardBScore: int = cardPrecedence2[b[ind]]
		if cardAScore != cardBScore:
			if max(cardAScore, cardBScore) == cardBScore:
				return false
			else:
				return true
	return false

func solve1(input: String) -> Variant:
	var solution: int = 0
	var hands: Dictionary[String, Array] = {
		"5": [],
		"4": [],
		"F": [],
		"3": [],
		"2": [],
		"1": [],
		"H": []
	}
	var cardsToBids: Dictionary[String, int] = {}
	
	populate_data(input, hands, cardsToBids, false)
		
	var cardRank: int = cardsToBids.size()
	for handType: String in hands:
		var handArray: Array = hands[handType]
		handArray.sort_custom(sort_individual_hand)
		for hand: String in handArray:
			print_log(str(cardsToBids[hand]) + " * " + str(cardRank))
			solution += cardsToBids[hand] * cardRank
			cardRank -= 1
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	var hands: Dictionary[String, Array] = {
		"5": [],
		"4": [],
		"F": [],
		"3": [],
		"2": [],
		"1": [],
		"H": []
	}
	var cardsToBids: Dictionary[String, int] = {}
	
	populate_data(input, hands, cardsToBids, true)
	
		
	var cardRank: int = cardsToBids.size()
	for handType: String in hands:
		var handArray: Array = hands[handType]
		handArray.sort_custom(sort_individual_hand2)
		for hand: String in handArray:
			print_log(str(cardsToBids[hand]) + " * " + str(cardRank))
			solution += cardsToBids[hand] * cardRank
			cardRank -= 1
	
	return solution
