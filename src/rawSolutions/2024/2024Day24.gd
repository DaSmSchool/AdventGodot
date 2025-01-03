extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func perform_instr(instr: Dictionary, registers: Dictionary) -> void:
	registers.get_or_add(instr.outputReg, -1)
	match instr.operation:
		"AND":
			registers[instr.outputReg] = registers[instr.reg1] & registers[instr.reg2]
		"OR":
			registers[instr.outputReg] = registers[instr.reg1] | registers[instr.reg2]
		"XOR":
			registers[instr.outputReg] = registers[instr.reg1] ^ registers[instr.reg2]


func solve1(input: String) -> int:
	var solution: int = 0
	
	var registers: Dictionary = {}
	var instrs: Array[Dictionary] = []
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var rawInit: PackedStringArray = inputSplit[0].split("\n")
	var rawInstr: PackedStringArray = inputSplit[1].split("\n")
	
	for register: String in rawInit:
		var regSplit: PackedStringArray = register.split(": ")
		registers.get_or_add(regSplit[0], regSplit[1].to_int())
	
	for instr: String in rawInstr:
		if instr == "": continue
		var instrSplit: PackedStringArray = instr.split(" ")
		
		instrs.append({
			"reg1" : instrSplit[0], 
			"reg2" : instrSplit[2], 
			"outputReg" : instrSplit[4], 
			"operation" : instrSplit[1], 
			})
		
		
	
	while instrs.size() != 0:
		var processedInstrs: Array[Dictionary] = []
		
		for instr: Dictionary in instrs:
			var registersMet: int = 0
			if registers.get(instr.reg1, -1) != -1:
				registersMet += 1
			if registers.get(instr.reg2, -1) != -1:
				registersMet += 1
			if registersMet < 2: continue
			
			perform_instr(instr, registers)
			processedInstrs.append(instr)
		
		for processed: Dictionary in processedInstrs:
			instrs.erase(processed)
	
	var zAssemble: String = ""
	var zRegInd: int = 0
	print()
	while registers.has("z"+str(zRegInd).lpad(2, "0")) and zRegInd < 100:
		zAssemble = str(registers["z"+str(zRegInd).lpad(2, "0")]) + zAssemble
		zRegInd += 1
	
	solution = zAssemble.bin_to_int()
	
	return solution

# This will NOT work if the output values swap over to another gate of the same type/register use type
func solve2(input: String) -> int:
	var solution: int = 0
	
	var registers: Dictionary = {}
	var instrs: Array[Dictionary] = []
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	var rawInit: PackedStringArray = inputSplit[0].split("\n")
	var rawInstr: PackedStringArray = inputSplit[1].split("\n")
	
	for register: String in rawInit:
		var regSplit: PackedStringArray = register.split(": ")
		registers.get_or_add(regSplit[0], regSplit[1].to_int())
	
	for instr: String in rawInstr:
		if instr == "": continue
		var instrSplit: PackedStringArray = instr.split(" ")
		
		instrs.append({
			"reg1" : instrSplit[0], 
			"reg2" : instrSplit[2], 
			"outputReg" : instrSplit[4], 
			"operation" : instrSplit[1], 
			})
	
	var instrTypes: Array = [[], [], [], [], [], []]
	
	for instr: Dictionary in instrs:
		match instr.operation:
			"AND":
				if instr.reg1[2].is_valid_int():
					instrTypes[0].append(instr)
				else:
					instrTypes[1].append(instr)
			"OR":
				if instr.reg1[2].is_valid_int():
					instrTypes[2].append(instr)
				else:
					instrTypes[3].append(instr)
			"XOR":
				if instr.reg1[2].is_valid_int():
					instrTypes[4].append(instr)
				else:
					instrTypes[5].append(instr)
	
	#for type: Array in instrTypes:
		#for instr: Dictionary in type:
			#print("%s %s %s -> %s" % [instr.reg1, instr.operation, instr.reg2, instr.outputReg])
		#print()
	
	var misplacedRegs: Array = []
	
	# check AND gates that process the predetermined registers
	for andNum: Dictionary in instrTypes[0]:
		var isIncorrect: bool = false
		
		# this is just a "i dont want to check for 0" deal, it will give a wrong result if anything that affects z00 is swapped
		if andNum["reg1"] in ["x00", "y00"]: continue
		
		var inOrList: bool = false
		for searchInstr: Dictionary in instrTypes[3]:
			if andNum["outputReg"] in [searchInstr["reg1"], searchInstr["reg2"]]:
				inOrList = true
				break
		if not inOrList: isIncorrect = true
		if isIncorrect: misplacedRegs.append(andNum.outputReg)
	
	# check AND gates that use calculated registers
	for andReg: Dictionary in instrTypes[1]:
		var isIncorrect: bool = false
		
		var inOrList: bool = false
		for searchInstr: Dictionary in instrTypes[3]:
			if andReg["outputReg"] in [searchInstr["reg1"], searchInstr["reg2"]]:
				inOrList = true
				break
		
		if not inOrList: isIncorrect = true
		if isIncorrect: misplacedRegs.append(andReg.outputReg)
	
	# check OR gates with calculated registers
	for orReg: Dictionary in instrTypes[3]:
		var isIncorrect: bool = false
		
		# the last bit is a special case, leave it alone in calculation
		if orReg["outputReg"] == "z45": continue
		
		var inOrList: bool = false
		for searchInstr: Dictionary in instrTypes[5]:
			if orReg["outputReg"] in [searchInstr["reg1"], searchInstr["reg2"]]:
				for searchInstr2: Dictionary in instrTypes[1]:
					if orReg["outputReg"] in [searchInstr2["reg1"], searchInstr2["reg2"]]:
						inOrList = true
						break
			if inOrList: break
		
		if not inOrList: isIncorrect = true
		if isIncorrect: misplacedRegs.append(orReg.outputReg)
	
	# check XOR gates that use predetermined values
	for xorNum: Dictionary in instrTypes[4]:
		var isIncorrect: bool = false
		
		# this is just a "i dont want to check for 0" deal, it will give a wrong result if anything that affects z00 is swapped
		if xorNum["outputReg"] == "z00": continue
		
		var inOrList: bool = false
		for searchInstr: Dictionary in instrTypes[5]:
			if xorNum["outputReg"] in [searchInstr["reg1"], searchInstr["reg2"]]:
				for searchInstr2: Dictionary in instrTypes[1]:
					if xorNum["outputReg"] in [searchInstr2["reg1"], searchInstr2["reg2"]]:
						inOrList = true
						break
			if inOrList: break
		
		if not inOrList: isIncorrect = true
		if isIncorrect: misplacedRegs.append(xorNum.outputReg)
	
	# check XOR gates that use calculated values
	for xorReg: Dictionary in instrTypes[5]:
		if not xorReg["outputReg"].substr(1, 2).is_valid_int():
			misplacedRegs.append(xorReg.outputReg)
	
	misplacedRegs.sort()
	
	var solutionAssemble: String = ""
	
	for reg: String in misplacedRegs:
		solutionAssemble += reg + ","
	solutionAssemble = solutionAssemble.substr(0, solutionAssemble.length()-1)
	print(solutionAssemble)
	
	return solution
