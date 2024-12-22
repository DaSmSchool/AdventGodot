extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_computer(input: String) -> void:
	instrPointer = 0
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
	#print("Register A: " + str(registerA))
	#print("Register B: " + str(registerB))
	#print("Register C: " + str(registerC))
	#
	#if instrPointer < instrList.size():
		#print("Current opcode: " + str(instrList[instrPointer]))
	#else:
		#print("Current opcode: NULL")
		#
	#if instrPointer < instrList.size()-1:
		#print("Current operand: " + str(instrList[instrPointer+1]))
	#else:
		#print("Current operand: NULL")

	print("Output: " + output)


func joined_output(outputString: String) -> String:
	var assemble: String = ""
	var outputSplit: PackedStringArray = outputString.split(",")
	
	for output: String in outputSplit:
		assemble += output
		#print(assemble)
	
	return assemble


func list_to_string(arr: Array) -> String:
	var assemble: String = ""
	for el: int in arr:
		assemble += str(el)
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
var aOverride: int = -1
var output: String = ""
var inp: String
var triedAs: Dictionary = {}

func solve1(input: String) -> int:
	var solution: int = 0
	inp = input
	reset_computer(input)
	
	if aOverride != -1:
		registerA = aOverride
	
	while instrPointer < instrList.size():
		#print_computer()
		var opMethod: Callable = Callable.create(self, "op"+str(instrList[instrPointer]))
		opMethod.call(instrList[instrPointer+1])
	
	print_computer()
	
	var joinOutput: String = joined_output(output)
	
	print("Real Solution: " + output)
	solution = joined_output(output).to_int()
	
	return solution


func get_lowest_reg_num(reg: Dictionary) -> int:
	#print(reg)
	if reg["currentInstr"] == reg["jumpFrom"] - 2:
		if reg["goingToWin"] == true: return reg["regA"]
		var dupDict: Dictionary = reg.duplicate(true)
		dupDict["currentInstr"] = reg["jumpTo"]
		return get_lowest_reg_num(dupDict)
	
	var currOpcode: int = instrList[reg["currentInstr"]]
	var currOperand: int = instrList[reg["currentInstr"]+1]
	
	
	
	match currOpcode:
		0:
			#print("BRANCH")
			for i in range(8):
				#print(i)
				var dupDict: Dictionary = reg.duplicate(true)
				var baseResult: int = reg["regA"] * pow(2, combo(currOperand))
				dupDict["regA"] = baseResult+i
				dupDict["currentInstr"] -= 2
				var depthResult = get_lowest_reg_num(dupDict)
				if depthResult != -1: return depthResult
		1:
			var dupDict: Dictionary = reg.duplicate(true)
			dupDict["regB"] = dupDict["regB"] ^ currOperand
			dupDict["currentInstr"] -= 2
			return get_lowest_reg_num(dupDict)
		2:
			var dupDict: Dictionary = reg.duplicate(true)
			var focusReg: String = "reg"
			if currOperand >= 0 and currOperand <= 3:
				if reg["regB"] != currOperand: return -1
			elif currOperand == 4:
				focusReg += "A"
			elif currOperand == 5:
				focusReg += "B"
			elif currOperand == 6:
				focusReg += "C"
			
			if reg["regB"] != reg[focusReg] % 8:
				#print("Go back!")
				return -1
			else:
				pass
				#print("!")
			
			var cOff: int = 0
			while cOff != 9:
				dupDict = reg.duplicate(true)
				dupDict["regB"] = dupDict["regC"] + cOff
				dupDict["currentInstr"] -= 2
				var bstResult: int = get_lowest_reg_num(dupDict)
				if bstResult != -1:
					if !triedAs.has(bstResult):
						triedAs.get_or_add(bstResult)
						aOverride = bstResult
						if solve1(inp) == list_to_string(instrList).to_int():
							return bstResult
				
				if cOff != 0:
					dupDict = reg.duplicate(true)
					dupDict["regB"] = dupDict["regC"] - cOff
					dupDict["currentInstr"] -= 2
					bstResult = get_lowest_reg_num(dupDict)
					if bstResult != -1:
						if !triedAs.has(bstResult):
							triedAs.get_or_add(bstResult)
							aOverride = bstResult
							if solve1(inp) == list_to_string(instrList).to_int():
								return bstResult
							
				cOff += 1
		
		3:
			var dupDict: Dictionary = reg.duplicate(true)
			dupDict["jumpFrom"] = currOperand
			dupDict["jumpTo"] = reg["currentInstr"]
			dupDict["currentInstr"] -= 2
			return get_lowest_reg_num(dupDict)
		4:
			var dupDict: Dictionary = reg.duplicate(true)
			dupDict["regB"] = dupDict["regB"] ^ dupDict["regC"]
			dupDict["currentInstr"] -= 2
			return get_lowest_reg_num(dupDict)
			
		5:
			if reg["regB"] % 8 == reg["output"].back():
				reg["output"].pop_back()
				var dupDict: Dictionary = reg.duplicate(true)
				if reg["output"].size() == 0:
					dupDict["goingToWin"] = true
				
				
				dupDict["currentInstr"] -= 2
				var tryGet: int = get_lowest_reg_num(dupDict)
				if tryGet != -1: return tryGet 
		6:
			#print("BRANCH")
			for i in range(8):
				#print(i)
				var dupDict: Dictionary = reg.duplicate(true)
				var baseResult: int = reg["regA"] * pow(2, combo(currOperand))
				dupDict["regB"] = baseResult+i
				dupDict["currentInstr"] -= 2
				var depthResult = get_lowest_reg_num(dupDict)
				if depthResult != -1: return depthResult
		7:
			#print("BRANCH")
			for i in range(8):
				#print(i)
				var dupDict: Dictionary = reg.duplicate(true)
				var baseResult: int = reg["regA"] * pow(2, combo(currOperand))
				dupDict["regC"] = baseResult+i
				dupDict["currentInstr"] -= 2
				var depthResult = get_lowest_reg_num(dupDict)
				if depthResult != -1: return depthResult
	#print("FAIL!")
	
	#print()
	return -1


func solve2(input: String) -> int:
	var solution: int = 0
	reset_computer(input)
	
	var regInfo: Dictionary = {
		"regA" : 0,
		"regB" : 0,
		"regC" : 0,
		"currentInstr" : instrList.size()-2,
		"output" : instrList,
		"jumpFrom" : 0,
		"jumpTo": instrList.size()-2,
		"goingToWin" : false
	}
	
	solution = get_lowest_reg_num(regInfo)
	
	print(triedAs)
	
	return solution
