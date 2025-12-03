extends Solution

func find_biggest_voltage(bank: Array) -> int:
	var tensPlaceMax: int = bank.slice(0, bank.size()-1).max()
	var onesPlaceMax: int = bank.slice(bank.find(tensPlaceMax)+1).max()
	return tensPlaceMax * 10 + onesPlaceMax

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n", false)
	var bankSet: Array = []
	for rawBank: String in inputSplit:
		var bank: PackedByteArray = []
		for rawBattery: String in rawBank:
			bank.append(rawBattery.to_int())
		bankSet.append(bank)
	
	for bank: Array in bankSet:
		solution += find_biggest_voltage(bank)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
