extends Solution

var p2_811_Array: Array = [""]

func make_ruleset_from_raw(rawRuleset: PackedStringArray) -> Dictionary:
	var ruleDictionary: Dictionary = {}
	
	for rule: String in rawRuleset:
		var ruleSplit: PackedStringArray = rule.split(": ")
		var ruleNumber: int = ruleSplit[0].to_int()
		var ruleOrders: Array = []
		if ruleSplit[1].contains("\""):
			ruleDictionary[ruleNumber] = ruleSplit[1][1]
			continue
		else:
			ruleOrders.append([])
			for includedRule: String in ruleSplit[1].split(" "):
				if includedRule.is_valid_int():
					ruleOrders.back().append(includedRule.to_int())
				elif includedRule == "|":
					ruleOrders.append([])
		ruleDictionary[ruleNumber] = ruleOrders
	
	return ruleDictionary

func message_passes_rule(message: String, ruleset: Dictionary, ruleNumber: int) -> String:
	var acceptableOrders: Array = ruleset[ruleNumber]
	for order: Array in acceptableOrders:
		var failedOrder: bool = false
		var testMutMessage: String = message
		for orderNumber: int in order:
			# the message == "" check checks for if the message has emptied all of its characters before the other rules are applied
			if testMutMessage == "":
				failedOrder = true 
			if failedOrder: continue
			
			var ruleValue = ruleset[orderNumber]
			if ruleValue is Array:
				var passedMessage: String = message_passes_rule(testMutMessage, ruleset, orderNumber)
				if passedMessage == "-1":
					failedOrder = true
				elif passedMessage.length() < testMutMessage.length():
					testMutMessage = passedMessage
			elif ruleValue is String:
				if testMutMessage[0] == ruleValue:
					testMutMessage = testMutMessage.substr(1)
				else:
					failedOrder = true
		
		if not failedOrder: return testMutMessage
	return "-1"

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split('\n')
	var rawRuleset: PackedStringArray = inputSplit.slice(0, inputSplit.find(''))
	var rawTestStrings: PackedStringArray = inputSplit.slice(inputSplit.find('')+1, inputSplit.size()-1)
	
	#print(rawRuleset)
	#print()
	#print(rawTestStrings)
	
	var ruleset: Dictionary = make_ruleset_from_raw(rawRuleset)
	#for rule: int in ruleset.keys():
		#print(str(rule) + " : " + str(ruleset[rule]))
	for testMessage: String in rawTestStrings:
		if message_passes_rule(testMessage, ruleset, 0) == "":
			#print(testMessage)
			solution += 1
	
	return solution

func message_passes_rule_p2(message: String, ruleset: Dictionary, ruleNumber: int) -> String:
	#if ruleNumber == 8 or ruleNumber == 11:
		#if ruleNumber == 8 and (p2_811_Array.back().right(1) == "y"):
			#p2_811_Array.append("")
		#if ruleNumber == 8 and (p2_811_Array.back().length() == 0 or p2_811_Array.back().right(1) == "x"):
			#p2_811_Array[p2_811_Array.size()-1] += "x"
		#if ruleNumber == 11:
			#p2_811_Array[p2_811_Array.size()-1] += "y"
			
			
	var acceptableOrders: Array = ruleset[ruleNumber]
	for order: Array in acceptableOrders:
		var failedOrder: bool = false
		var testMutMessage: String = message
		for orderNumber: int in order:
			# the message == "" check checks for if the message has emptied all of its characters before the other rules are applied
			if testMutMessage == "":
				failedOrder = true 
			if failedOrder: continue
			
			var ruleValue = ruleset[orderNumber]
			if ruleValue is Array:
				var passedMessage: String = message_passes_rule_p2(testMutMessage, ruleset, orderNumber)
				if passedMessage == "-1":
					failedOrder = true
				elif passedMessage.length() < testMutMessage.length():
					testMutMessage = passedMessage
			elif ruleValue is String:
				if testMutMessage[0] == ruleValue:
					testMutMessage = testMutMessage.substr(1)
				else:
					failedOrder = true
		
		if not failedOrder: return testMutMessage
	return "-1"

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split('\n')
	var rawRuleset: PackedStringArray = inputSplit.slice(0, inputSplit.find(''))
	var rawTestStrings: PackedStringArray = inputSplit.slice(inputSplit.find('')+1, inputSplit.size()-1)
	
	print(rawRuleset)
	print()
	print(rawTestStrings)
	
	var ruleset: Dictionary = make_ruleset_from_raw(rawRuleset)
	
	# I got this idea after seeing someone else simulate multiple branches with regex. I tried to make something that works automatically, but i don't exactly have an idea as to *why* the attempt didn't work.
	for testMessage: String in rawTestStrings:
		var messagePassed: bool = false
		var rule0Array = [11]
		#p2_811_Array = [""]
		for i: int in range(20):
			if messagePassed: continue
			rule0Array.insert(0, 8)
			var rule11Array: Array = []
			for f: int in range(20):
				if messagePassed: continue
				rule11Array.insert(0, 42)
				rule11Array.append(31)
				ruleset[0] = [rule0Array]
				ruleset[11] = [rule11Array]
				if message_passes_rule_p2(testMessage, ruleset, 0) == "":
					print("Success")
					solution += 1
					messagePassed = true
	
	
	return solution
