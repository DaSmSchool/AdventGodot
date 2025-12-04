extends Solution

var wordNumberToInt: Dictionary[String, int] = {
	"one": 1,
	"two": 2,
	"three": 3,
	"four": 4,
	"five": 5,
	"six": 6,
	"seven": 7,
	"eight": 8,
	"nine": 9,
}

func get_number_from_entry(entry: String) -> int:
	var numberArr: Array = []
	for character: String in entry:
		if character.is_valid_int():
			numberArr.append(character.to_int())
	return numberArr.front() * 10 + numberArr.back()

func numberize_entry(entry: String) -> String:
	var numberizedEntry: String =  ""
	while not entry.is_empty():
		if entry[0].is_valid_int():
			numberizedEntry += entry[0]
		else:
			for word: String in wordNumberToInt:
				if entry.find(word) == 0:
					numberizedEntry += str(wordNumberToInt[word])
					break
		entry = entry.substr(1)
		
	return numberizedEntry

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var entriesSplit: PackedStringArray = input.split("\n", false)
	for entry: String in entriesSplit:
		solution += get_number_from_entry(entry)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var entriesSplit: PackedStringArray = input.split("\n", false)
	for entry: String in entriesSplit:
		var numberizedEntry: String = numberize_entry(entry)
		print_log(entry)
		print_log(numberizedEntry)
		var value: int = get_number_from_entry(numberizedEntry)
		print_log(value)
		print_log("")
		solution += value
	
	return solution
