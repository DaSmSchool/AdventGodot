extends Solution

func parse_input(input: String) -> Array:
	var inputSplit: PackedStringArray = input.split("\n", false)
	var bankSet: Array = []
	for rawBank: String in inputSplit:
		var bank: PackedByteArray = []
		for rawBattery: String in rawBank:
			bank.append(rawBattery.to_int())
		bankSet.append(bank)
	return bankSet

func find_biggest_voltage(bank: Array) -> int:
	var tensPlaceMax: int = bank.slice(0, bank.size()-1).max()
	var onesPlaceMax: int = bank.slice(bank.find(tensPlaceMax)+1).max()
	return tensPlaceMax * 10 + onesPlaceMax

func find_biggest_voltage_p2(bank: Array, digits: int) -> int:
	var batteryAssemble: String = ""
	var currentChosenNumberInd: int = 0
	var bankSlice: Array = bank.duplicate()
	for digitInd: int in range(digits):
		bankSlice = bank.slice(currentChosenNumberInd, bank.size()-(digits-(digitInd+1)))
		print_log(bankSlice)
		var foundDigit: int = bankSlice.max()
		currentChosenNumberInd += bankSlice.find(foundDigit)+1
		batteryAssemble += str(foundDigit)
	print_log(batteryAssemble)
	return batteryAssemble.to_int()

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var bankSet: Array = parse_input(input)
	
	for bank: Array in bankSet:
		solution += find_biggest_voltage(bank)
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var bankSet: Array = parse_input(input)
	
	for bank: Array in bankSet:
		solution += find_biggest_voltage_p2(bank, 12)
	
	return solution
