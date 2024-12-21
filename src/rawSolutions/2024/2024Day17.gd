extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_computer(input: String) -> void:
	registerA = 0
	registerB = 0
	registerC = 0
	output = ""
	
	var inputSections: PackedStringArray = input.split("\n\n")
	var regSplit: PackedStringArray = inputSections[0].split("\n")
	registerA = regSplit[0].split(": ")[1].to_int()
	registerB = regSplit[1].split(": ")[1].to_int()
	registerC = regSplit[2].split(": ")[1].to_int()
	
	var instrSplit: Array = Array(Array(inputSections[1].split("\n")[0].split(": ")[1].split(",")), TYPE_STRING, "", null)
	instrList = instrSplit.map(func(instr): return instr.to_int())


func print_computer() -> void:
	print("Register A: " + str(registerA))
	print("Register B: " + str(registerB))
	print("Register C: " + str(registerC))
	
	if instrPointer < instrList.size():
		print("Current opcode: " + str(instrList[instrPointer]))
	else:
		print("Current opcode: NULL")
		
	if instrPointer < instrList.size()-1:
		print("Current opcode: " + str(instrList[instrPointer+1]))
	else:
		print("Current operand: NULL")

	print("Output: " + output)


func joined_output(outputString: String) -> String:
	var assemble: String = ""
	var outputSplit: PackedStringArray = outputString.split(",")
	
	for output: String in outputSplit:
		assemble += output
		#print(assemble)
	
	return assemble


func combo(val: int) -> int:
	if val >= 0 and val <= 3:
		return val
	elif val == 4:
		return registerA
	elif val == 5:
		return registerB
	elif val == 6:
		return registerC
	else:
		assert(true, "Invalid value for combo: " + str(val))
		return -1

# adv
func op0(operand: int) -> void:
	var numerator: int = registerA
	var denominator: int = pow(2, combo(operand))
	var result: int = floor(numerator/denominator)
	registerA = result
	instrPointer += 2


# bxl
func op1(operand: int) -> void:
	registerB = registerB ^ operand
	instrPointer += 2


# bst
func op2(operand: int) -> void:
	registerB = combo(operand) % 8
	instrPointer += 2


# jnz
func op3(operand: int) -> void:
	if registerA == 0: 
		instrPointer += 2
	else:
		instrPointer = operand


# bxc
func op4(operand: int) -> void:
	registerB = registerB ^ registerC
	instrPointer += 2


# out
func op5(operand: int) -> void:
	output = (output + "," + str(combo(operand) % 8))
	if output[0] == ",":
		output = output.substr(1)
	instrPointer += 2


# bdv
func op6(operand: int) -> void:
	var numerator: int = registerA
	var denominator: int = pow(2, combo(operand))
	var result: int = floor(numerator/denominator)
	registerB = result
	instrPointer += 2
	

# cdv
func op7(operand: int) -> void:
	var numerator: int = registerA
	var denominator: int = pow(2, combo(operand))
	var result: int = floor(numerator/denominator)
	registerC = result
	instrPointer += 2


var instrPointer: int = 0
var instrList: Array = []
var registerA: int = 0
var registerB: int = 0
var registerC: int = 0
var output: String = ""


func solve1(input: String) -> int:
	var solution: int = 0
	reset_computer(input)
	
	while instrPointer < instrList.size():
		print_computer()
		var opMethod: Callable = Callable.create(self, "op"+str(instrList[instrPointer]))
		opMethod.call(instrList[instrPointer+1])
	
	print_computer()
	
	var joinOutput: String = joined_output(output)
	
	print("Real Solution: " + output)
	solution = joined_output(output).to_int()
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	reset_computer(input)
	
	return solution
