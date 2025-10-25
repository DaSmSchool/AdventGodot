extends Solution

func solve1(input: String) -> int:
	var inputSplit: PackedStringArray = input.split("\n")
	var dateSplits: PackedStringArray = []
	
	var offDates: PackedInt64Array = []
	
	for line: String in inputSplit:
		if line == "": continue
		#print(line)
		var baseUnixTime: int = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_datetime_string(line, false))
		#print(baseUnixTime)
		
		var offsetAdd: int
		
		var offsetString: String
		
		
		if line.contains("+"):
			offsetString = line.substr(line.find("+"))
			offsetAdd = -1
		else:
			offsetString = line.substr(line.find("-")).substr(16)
			offsetAdd = 1
		#print("OFF:" + offsetString)
		var hoursOff: int = offsetString.split(":")[0].to_int()
		var minsOff: int = offsetString.split(":")[1].to_int()
		#print(hoursOff)
		#print(minsOff)
		
		offDates.append(baseUnixTime + (hoursOff * 60 * 60 + minsOff * 60) * offsetAdd)
	
	var highestCountDates: Array[int] = []
	
	for date: int in offDates:
		highestCountDates.append(offDates.count(date))
	
	var highestDateInd: int = highestCountDates.find(highestCountDates.max())
	#print(highestCountDates)
	print(Time.get_datetime_string_from_unix_time(offDates[highestDateInd]) + "+00:00")
	
	return 0
