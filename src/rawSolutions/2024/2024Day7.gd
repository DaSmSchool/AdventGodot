extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func recur_find_valid1(product: int, numList: Array) -> bool:
	if numList.size() == 1:
		return product == numList[0]
	
	if product % numList.back() == 0:
		var multReturn: bool = recur_find_valid1(product/numList.back(), numList.slice(0, numList.size()-1))
		if multReturn: return multReturn
	var addReturn: bool = recur_find_valid1(product-numList.back(), numList.slice(0, numList.size()-1))
	if addReturn: return addReturn
	else: return false


func recur_find_valid2(product: int, numList: Array) -> bool:
	if numList.size() == 1:
		return product == numList[0]
	
	if product % numList.back() == 0:
		var multReturn: bool = recur_find_valid2(product/numList.back(), numList.slice(0, numList.size()-1))
		if multReturn: return multReturn
		
	var productStr: String = str(product)
	var numStr: String = str(numList.back())
	if productStr.ends_with(numStr):
		var concatenateReturn: bool = recur_find_valid2(productStr.trim_suffix(numStr).to_int(), numList.slice(0, numList.size()-1))
		if concatenateReturn: return concatenateReturn
		
	var addReturn: bool = recur_find_valid2(product-numList.back(), numList.slice(0, numList.size()-1))
	if addReturn: return addReturn
	else: return false
	

func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var equations: Array = []
	
	for line: String in inputSplit:
		if line == "": continue
		var sections: PackedStringArray = line.split(": ")
		var numbers: Array = sections[1].split(" ")
		var intNums: Array[int] = []
		for num: String in numbers:
			intNums.append(num.to_int())
		
		equations.append([sections[0].to_int(), intNums])
	
	var validEquations: Array = []
	
	for eq: Array in equations:
		if recur_find_valid1(eq[0], eq[1]):
			validEquations.append(eq)
	
	for eq: Array in validEquations:
		solution += eq[0]
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var equations: Array = []
	
	for line: String in inputSplit:
		if line == "": continue
		var sections: PackedStringArray = line.split(": ")
		var numbers: Array = sections[1].split(" ")
		var intNums: Array[int] = []
		for num: String in numbers:
			intNums.append(num.to_int())
		
		equations.append([sections[0].to_int(), intNums])
	
	var validEquations: Array = []
	
	for eq: Array in equations:
		if recur_find_valid2(eq[0], eq[1]):
			validEquations.append(eq)
	
	for eq: Array in validEquations:
		solution += eq[0]
	
	return solution
