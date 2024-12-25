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
	
	for type: Array in instrTypes:
		for instr: Dictionary in type:
			print("%s %s %s -> %s" % [instr.reg1, instr.operation, instr.reg2, instr.outputReg])
		print()
	
	return solution
