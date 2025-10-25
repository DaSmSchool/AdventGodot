extends Solution

func solve1(input: String) -> int:
	var solution: int = 0
	var inputLines: PackedStringArray = input.split("\n")
	
	for line in inputLines:
		if line == "": continue
		var charCount: int = line.length()
		var byteCount: int = line.to_utf8_buffer().size()
		
		var canSMS: bool = false
		var canTweet: bool = false
		
		if byteCount <= 160:
			canSMS = true
		
		if charCount <= 140:
			canTweet = true
		
		if canSMS and canTweet:
			solution += 13
		elif canSMS:
			solution += 11
		elif canTweet:
			solution += 7
		#print(solution)
		
	print(solution)
	return solution
