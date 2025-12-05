extends Solution

func parse_input(input: String) -> Array:
	var inputSplit: PackedStringArray = input.split("\n", false)
	var ticketArray: Array = []
	for rawTicket: String in inputSplit:
		rawTicket = rawTicket.substr(rawTicket.find(": ")+2)
		var splitNumbers: PackedStringArray = rawTicket.split(" | ")
		var winningNumbers: PackedByteArray = Array(splitNumbers[0].split(" ", false)).map(func(s): return int(s))
		var gameNumbers: PackedByteArray = Array(splitNumbers[1].split(" ", false)).map(func(s): return int(s))
		ticketArray.append([winningNumbers, gameNumbers])
	return ticketArray
	
func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var tickets: Array = parse_input(input)
	for ticket: Array in tickets:
		var numbersWon: int = Helper.shared_elements(ticket[0], ticket[1]).size()-1
		if numbersWon != -1:
			solution += pow(2.0, numbersWon)
	
	return solution

func play_card(cardNumber: int, cards: Array, cardHistory: Array) -> int:
	if cardHistory[cardNumber] != -1: return cardHistory[cardNumber]
	var card: Array = cards[cardNumber]
	var numbersWon: int = Helper.shared_elements(card[0], card[1]).size()
	var cardsPlayed: int = 1
	#print_log(str(cardNumber) + " : " + str(numbersWon))
	for i: int in range(numbersWon):
		cardsPlayed += play_card(cardNumber+i+1, cards, cardHistory)
	cardHistory[cardNumber] = cardsPlayed
	return cardsPlayed

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var cards: Array = parse_input(input)
	var cardsPlayedHistory: Array = []
	cardsPlayedHistory.resize(cards.size())
	cardsPlayedHistory.fill(-1)
	for cardInd: int in cards.size():
		solution += play_card(cardInd, cards, cardsPlayedHistory)
	#print_log(cardsPlayedHistory)
	return solution
