extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	
	var rules: Dictionary = {}
	var myTicket: Array[int] = []
	var otherTickets: Array = []
	
	for rule: String in inputSplit[0].split("\n"):
		var splitRuleRaw: PackedStringArray = rule.split(": ")
		var ruleName: String = splitRuleRaw[0]
		var ruleRanges: Array = []
		var rawRanges: PackedStringArray = splitRuleRaw[1].split(" or ")
		var intRange: Array[int]
		for range: String in rawRanges:
			intRange = []
			var splitRange: PackedStringArray = range.split("-")
			intRange.append(splitRange[0].to_int())
			intRange.append(splitRange[1].to_int())
			ruleRanges.append(intRange)
		rules.get_or_add(ruleName, ruleRanges)
	
	var myTicketRaw: String = inputSplit[1].split("\n")[1]
	for num: String in myTicketRaw.split(","):
		myTicket.append(num.to_int())
	
	var otherTicketsRaw: PackedStringArray = inputSplit[2].split("\n")
	for ticketInd: int in range(1, otherTicketsRaw.size()-1):
		var otherTicket: Array[int] = []
		var ticketRaw: PackedStringArray = otherTicketsRaw[ticketInd].split(",")
		for num: String in ticketRaw:
			otherTicket.append(num.to_int())
		otherTickets.append(otherTicket)
	
	var impossibleSum: int = 0
	
	for ticket: Array in otherTickets:
		for num: int in ticket:
			var numFits = false
			for type: String in rules.keys():
				for range: Array in rules[type]:
					if range[0] <= num and num <= range[1]:
						numFits = true
						break
				if numFits: break
			if !numFits: impossibleSum += num
	
	solution = impossibleSum
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	
	var rules: Dictionary = {}
	var myTicket: Array[int] = []
	var otherTickets: Array = []
	var validTickets: Array = []
	
	for rule: String in inputSplit[0].split("\n"):
		var splitRuleRaw: PackedStringArray = rule.split(": ")
		var ruleName: String = splitRuleRaw[0]
		var ruleRanges: Array = []
		var rawRanges: PackedStringArray = splitRuleRaw[1].split(" or ")
		var intRange: Array[int]
		for range: String in rawRanges:
			intRange = []
			var splitRange: PackedStringArray = range.split("-")
			intRange.append(splitRange[0].to_int())
			intRange.append(splitRange[1].to_int())
			ruleRanges.append(intRange)
		rules.get_or_add(ruleName, ruleRanges)
	
	var myTicketRaw: String = inputSplit[1].split("\n")[1]
	for num: String in myTicketRaw.split(","):
		myTicket.append(num.to_int())
	
	var otherTicketsRaw: PackedStringArray = inputSplit[2].split("\n")
	for ticketInd: int in range(1, otherTicketsRaw.size()-1):
		var otherTicket: Array[int] = []
		var ticketRaw: PackedStringArray = otherTicketsRaw[ticketInd].split(",")
		for num: String in ticketRaw:
			otherTicket.append(num.to_int())
		otherTickets.append(otherTicket)
	
	for ticket: Array in otherTickets:
		var validTicket: bool = true
		for num: int in ticket:
			var numFits = false
			for type: String in rules.keys():
				for range: Array in rules[type]:
					if range[0] <= num and num <= range[1]:
						numFits = true
						break
				if numFits: break
			if !numFits:
				validTicket = false
				break
		if validTicket:
			validTickets.append(ticket)
	
	var possibleCategories: Array = []
	for num: int in validTickets[0].size():
		possibleCategories.append(rules.keys().duplicate())
	
	for possiblesInd: int in possibleCategories.size():
		for ticket: Array in validTickets:
			if possibleCategories[possiblesInd].size() == 1: break
			# eliminate possible rules
			for rule: String in rules.keys():
				if possibleCategories[possiblesInd].size() == 1: break
				var validForRule: = false
				for range: Array in rules[rule]:
					if range[0] <= ticket[possiblesInd] and ticket[possiblesInd] <= range[1]:
						validForRule = true
						break
				if !validForRule: possibleCategories[possiblesInd].erase(rule)
	
		
	# remove redundant rules by checking for indeces that have 1 possible rule, then removing that rule from other indeces
	
	# thanks visualisation helper that screwed me up :3
	#possibleCategories.sort_custom(func(a, b): return a.size() < b.size())
	
	var checkedRules: Array = []
	
	var highlightInd: int = 0
	
	while highlightInd < possibleCategories.size():
		var focusArray: Array = possibleCategories[highlightInd]
		if focusArray.size() == 1 and !checkedRules.has(focusArray[0]):
			#print(focusArray[0])
			for clearArray: int in possibleCategories.size():
				#print(possibleCategories[clearArray])
				if possibleCategories[clearArray].size() != 1:
					possibleCategories[clearArray].erase(focusArray[0])
				#print(possibleCategories[clearArray])
			highlightInd = 0
			checkedRules.append(focusArray[0])
			continue
		highlightInd += 1
	
	var ruleToInd: Dictionary = {}
	
	for possibleInd: int in possibleCategories.size():
		ruleToInd.get_or_add(possibleCategories[possibleInd][0], myTicket[possibleInd])
	
	var departureMult: int = 1
	
	for rule: String in ruleToInd.keys():
		if rule.contains("departure "):
			departureMult *= ruleToInd[rule]
	
	#print(ruleToInd)
	
	solution = departureMult
	
	return solution
