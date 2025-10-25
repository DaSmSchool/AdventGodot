extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var programCounter: int = 0
var accumulator: int = 0
var programFinished: bool = false

func perform_nop(arg: int) -> void:
	pass

func perform_acc(arg: int) -> void:
	accumulator += arg

func perform_jmp(arg: int) -> void:
	programCounter += arg-1

func run_program(instrs: Array[Dictionary]) -> void:
	accumulator = 0
	programCounter = 0
	var visitedInstructions: Dictionary = {}
	
	while !visitedInstructions.has(programCounter):
		if instrs.size() == programCounter: 
			programFinished = true
			break
		visitedInstructions.get_or_add(programCounter, true)
		
		var instrCall: Callable = Callable(self, "perform_"+instrs[programCounter].keys()[0])
		instrCall.call(instrs[programCounter][instrs[programCounter].keys()[0]])
		
		programCounter += 1

func run_program_modded(instrs: Array[Dictionary], flipped: int) -> void:
	accumulator = 0
	programCounter = 0
	var visitedInstructions: Dictionary = {}
	
	while !visitedInstructions.has(programCounter):
		if instrs.size() == programCounter: 
			programFinished = true
			break
		visitedInstructions.get_or_add(programCounter, true)
		
		var operation: String = instrs[programCounter].keys()[0]
		if programCounter == flipped:
			if operation == "jmp": operation = "nop"
			elif operation == "nop": operation = "jmp"
		
		var argument: int = instrs[programCounter][instrs[programCounter].keys()[0]]
		
		var instrCall: Callable = Callable(self, "perform_"+operation)
		instrCall.call(argument)
		
		programCounter += 1

func solve1(input: String) -> int:
	programCounter = 0
	accumulator = 0
	
	var solution: int = 0
	var instructionList: Array[Dictionary] = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	for line in inputSplit:
		if line == "": continue
		var instruction: Dictionary = {}
		var instrSplit: PackedStringArray = line.split(" ")
		var operation: String = instrSplit[0]
		var argument: int = instrSplit[1].substr(1).to_int()
		if instrSplit[1].substr(0, 1) == "-": argument *= -1
		
		instruction.get_or_add(operation, argument)
		instructionList.append(instruction)
	
	var visitedInstructions: Dictionary = {}
	
	run_program(instructionList)
	
	solution = accumulator
	
	return solution

func solve2(input: String) -> int:
	programCounter = 0
	accumulator = 0
	
	var solution: int = 0
	var instructionList: Array[Dictionary] = []
	
	var inputSplit: PackedStringArray = input.split("\n")
	for line in inputSplit:
		if line == "": continue
		var instruction: Dictionary = {}
		var instrSplit: PackedStringArray = line.split(" ")
		var operation: String = instrSplit[0]
		var argument: int = instrSplit[1].substr(1).to_int()
		if instrSplit[1].substr(0, 1) == "-": argument *= -1
		
		instruction.get_or_add(operation, argument)
		instructionList.append(instruction)
	
	var focusedInstrToFlip: int = 0
	while !programFinished:
		while instructionList[focusedInstrToFlip].keys()[0] == "acc":
			focusedInstrToFlip += 1
		run_program_modded(instructionList, focusedInstrToFlip)
		if programFinished:
			solution = accumulator
		else:
			focusedInstrToFlip += 1
	
	return solution
