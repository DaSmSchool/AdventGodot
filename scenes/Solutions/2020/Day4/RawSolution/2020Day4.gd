extends Solution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var requiredProperties = [
	"byr",
	"iyr",
	"eyr",
	"hgt",
	"hcl",
	"ecl",
	"pid"
]

var validEyeColors = [
	"amb",
	"blu",
	"brn",
	"gry",
	"grn",
	"hzl",
	"oth"
]

func verify_byr(input: String) -> bool:
	var len: int = input.length()
	if len != 4: return false
	var inpNum: int = input.to_int()
	if inpNum >= 1920 and inpNum <= 2002: return true
	return false
	
	
func verify_iyr(input: String) -> bool:
	var len: int = input.length()
	if len != 4: return false
	var inpNum: int = input.to_int()
	if inpNum >= 2010 and inpNum <= 2020: return true
	return false

func verify_eyr(input: String) -> bool:
	var len: int = input.length()
	if len != 4: return false
	var inpNum: int = input.to_int()
	if inpNum >= 2020 and inpNum <= 2030: return true
	return false

func verify_hgt(input: String) -> bool:
	var len: int = input.length()
	var hgtUnit: String = input.substr(len-2, len)
	var hgtInt: int = input.substr(0, len-2).to_int()
	
	if hgtUnit == "cm":
		return (hgtInt >= 150 and hgtInt <= 193)
	elif hgtUnit == "in":
		return (hgtInt >= 59 and hgtInt <= 76)
	else:
		return false

func verify_hcl(input: String) -> bool:
	if input.length() != 7: return false
	return Color.html_is_valid(input)

func verify_ecl(input: String) -> bool:
	return validEyeColors.has(input)

func verify_pid(input: String) -> bool:
	var len: int = input.length()
	if len != 9: return false
	
	for char in input:
		if char.to_int() == -1: return false
	return true


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var entryList: Array[Dictionary] = []
	var assembleEntry: Dictionary = {}
	
	for line in inputLines:
		if line == "": 
			entryList.push_front(assembleEntry)
			assembleEntry = {}
			continue
		
		var properties: PackedStringArray = line.split(" ")
		for prop in properties:
			var propVals: PackedStringArray = prop.split(":")
			assembleEntry.get_or_add(propVals[0], propVals[1])
	
	for entry in entryList:
		var goodEntry = true
		for prop in requiredProperties:
			if !entry.has(prop): 
				goodEntry = false
				break
		if goodEntry: solution += 1
		
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputLines: PackedStringArray = input.split("\n")
	
	var entryList: Array[Dictionary] = []
	var assembleEntry: Dictionary = {}
	
	for line in inputLines:
		if line == "": 
			entryList.push_front(assembleEntry)
			assembleEntry = {}
			continue
		
		var properties: PackedStringArray = line.split(" ")
		for prop in properties:
			var propVals: PackedStringArray = prop.split(":")
			assembleEntry.get_or_add(propVals[0], propVals[1])
	
	for entry in entryList:
		var goodEntry = true
		for prop in requiredProperties:
			if !entry.has(prop): 
				goodEntry = false
				break
			else:
				var check = Callable(self, "verify_" + prop)
				if !check.call(entry.get(prop)): 
					print(prop)
					goodEntry = false
		if goodEntry: solution += 1
		
	
	return solution
