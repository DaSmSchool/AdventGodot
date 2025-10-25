extends Solution

func decode_dict_entry(str: String) -> String:
	var assemble: String = ""
	#print(str)
	var charInd: int = 0
	while charInd < str.length():
		var strBin: String = String.num_uint64(str.unicode_at(charInd),2).pad_zeros(8)
		#print(str[charInd] + ": " + strBin)
		
		if strBin[0] == "0":
			assemble += str[charInd]
			charInd += 1
		else:
			var byteCount: int = strBin.find("0")
			var buildNumber: String = ""
			buildNumber += strBin.substr(byteCount+1)
			for byteInd in range(1,byteCount):
				
				var focusStrBin: String = String.num_uint64(str.unicode_at(charInd+byteInd),2).pad_zeros(8)
				#print(str[charInd+byteInd] + ": " + focusStrBin)
				buildNumber += focusStrBin.substr(2)
			var newChar: String = String.chr(buildNumber.bin_to_int())
			#print(buildNumber)
			#print(buildNumber.bin_to_int())
			#print("Replace: " + newChar)
			assemble += newChar
			
			charInd += byteCount
		
	return assemble

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	
	var rawDictionary: String = inputSplit[0]
	var rawCrossword: String = inputSplit[1]
	
	var dictionarySplit: PackedStringArray = rawDictionary.split("\n")
	
	for lineInd: int in range(0, dictionarySplit.size()):
		var encodeTimes: int = 0
		if lineInd % 3 == 2:
			encodeTimes += 1
		if lineInd % 5 == 4:
			encodeTimes += 1
		while encodeTimes != 0:
			dictionarySplit[lineInd] = decode_dict_entry(dictionarySplit[lineInd])
			#print("RESULT: "+rawDictionarySplit[lineInd])
			encodeTimes -= 1
		#print(dictionarySplit[lineInd])
	
	for crosswordLine: String in rawCrossword.split("\n"):
		#print(crosswordLine)
		# will fail if first character is used for given letter
		var lowCrosswordLine: String = crosswordLine.substr(crosswordLine.find("."))
		lowCrosswordLine.lstrip(" \t")
		lowCrosswordLine = lowCrosswordLine.to_lower()
		#print(lowCrosswordLine)
		var tgtLength: int = lowCrosswordLine.length()
		var tgtChar: String = ""
		var tgtCharInd: int
		for char: String in lowCrosswordLine:
			if char not in [".", " "]:
				tgtChar = char
				tgtCharInd = lowCrosswordLine.find(tgtChar)
				break
		
		#print(tgtCharInd)
		#print(tgtLength)
		
		for wordInd: int in dictionarySplit.size():
			var word: String = dictionarySplit[wordInd]
			if word.length() != tgtLength: continue
			#print(word)
			if word[tgtCharInd].to_lower() != tgtChar: continue
			print(word)
			solution += wordInd + 1
			break
			
	
	return solution
