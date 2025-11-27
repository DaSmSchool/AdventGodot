extends Solution

func populate_decks(deck1: Array, deck2: Array, inputStr: String) -> void:
	var rawDecksSplit: PackedStringArray = inputStr.split("\n\n", false)
	for deckInd: int in rawDecksSplit.size():
		var deckSplit: PackedStringArray = rawDecksSplit[deckInd].split("\n", false)
		deckSplit.remove_at(0)
		for card: String in deckSplit:
			if deckInd == 0:
				deck1.append(card.to_int())
			else:
				deck2.append(card.to_int())

func advance_deck_round(deck1: Array, deck2: Array) -> void:
	if deck1[0] > deck2[0]:
		deck1.append(deck1[0])
		deck1.append(deck2[0])
		deck1.remove_at(0)
		deck2.remove_at(0)
	else:
		deck2.append(deck2[0])
		deck2.append(deck1[0])
		deck1.remove_at(0)
		deck2.remove_at(0)

func solve1(input: String) -> int:
	var solution: int = 0
	
	var p1Deck: Array = []
	var p2Deck: Array = []
	
	populate_decks(p1Deck, p2Deck, input)
	
	print(p1Deck)
	print(p2Deck)
	
	while p1Deck.size() != 0 and p2Deck.size() != 0:
		advance_deck_round(p1Deck, p2Deck)
	
	print(p1Deck)
	print(p2Deck)
	
	var winningDeck: Array
	
	if p1Deck.size() != 0:
		winningDeck = p1Deck
	else:
		winningDeck = p2Deck
	
	
	for cardInd: int in winningDeck.size():
		var scoringCard: int = winningDeck[winningDeck.size()-1-cardInd]
		solution += (scoringCard * (cardInd+1))
	
	return solution

func record_decks(deck1: Array, deck2: Array, deckRecord: Array) -> bool:
	if deckRecord[0].has(deck1) or deckRecord[1].has(deck2):
		return true
	
	deckRecord[0][deck1] = 1
	deckRecord[1][deck2] = 1
	return false

func play_game_recurs(deck1: Array, deck2: Array) -> Array:
	var deckRecord: Array = [{}, {}]
	while deck1.size() != 0 and deck2.size() != 0:
		var deckPlayed: bool = record_decks(deck1, deck2, deckRecord)
		if deckPlayed: return [deck1, []]
		
		var deck1Played: int = deck1[0]
		var deck2Played: int = deck2[0]
		var whoWon: int = -1
		if deck1.size()-1 >= deck1Played and deck2.size()-1 >= deck2Played:
			var sliceDeck1: Array = deck1.duplicate()
			var sliceDeck2: Array = deck2.duplicate()
			sliceDeck1 = sliceDeck1.slice(1, 1+deck1Played)
			sliceDeck2 = sliceDeck2.slice(1, 1+deck2Played)
			var subgameResult: Array = play_game_recurs(sliceDeck1, sliceDeck2)
			if subgameResult[0] > subgameResult[1]:
				whoWon = 0
			else:
				whoWon = 1
		else:
			if deck1Played > deck2Played:
				whoWon = 0
			else:
				whoWon = 1
		
		if whoWon == 0:
			deck1.append(deck1[0])
			deck1.append(deck2[0])
			deck1.remove_at(0)
			deck2.remove_at(0)
		elif whoWon == 1:
			deck2.append(deck2[0])
			deck2.append(deck1[0])
			deck1.remove_at(0)
			deck2.remove_at(0)
	
	return [deck1, deck2]

func solve2(input: String) -> int:
	var solution: int = 0
	
	var p1Deck: Array = []
	var p2Deck: Array = []
	
	populate_decks(p1Deck, p2Deck, input)
	
	var result: Array = play_game_recurs(p1Deck, p2Deck)
	
	print(p1Deck)
	print(p2Deck)
	
	var winningDeck: Array
	
	if result[0].size() != 0:
		winningDeck = result[0]
	else:
		winningDeck = result[1]
	
	
	for cardInd: int in winningDeck.size():
		var scoringCard: int = winningDeck[winningDeck.size()-1-cardInd]
		solution += (scoringCard * (cardInd+1))
	
	return solution
