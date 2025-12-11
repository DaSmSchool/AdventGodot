extends Solution

# a few one liner map parsers. as a treat.
func parse_input(input: String, lightArray: Array, buttonArray: Array, joltageArray: Array) -> void:
	var lineSplit: PackedStringArray = input.split("\n", false)
	for line: String in lineSplit:
		var fieldSplit: PackedStringArray = line.split(" ")
		lightArray.append(Array(fieldSplit[0].substr(1, fieldSplit[0].length()-2).split("")).map(func(l): return true if l == "#" else false))
		fieldSplit.remove_at(0)
		joltageArray.append(Array(fieldSplit[fieldSplit.size()-1].substr(1, fieldSplit[fieldSplit.size()-1].length()-2).split(",")).map(func(j): return int(j)))
		fieldSplit.remove_at(fieldSplit.size()-1)
		buttonArray.append(Array(fieldSplit).map(func(b): return Array(b.substr(1, b.length()-1).split(",")).map(func(n): return int(n)))) 

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	return solution


func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var lightArray: Array = []
	var buttonArray: Array = []
	var joltageArray: Array = []
	parse_input(input, lightArray, buttonArray, joltageArray)
	
	var jDict: Dictionary = {
		"lightArray": lightArray,
		"buttonArray": buttonArray,
		"joltageArray": joltageArray,
	}
	
	#Helper.print_dict(jDict)
	#print(JSON.stringify(jDict))
	
	var output: Array = []
	#OS.execute("python", ["-c", "'from z3solve import *; print let_z3_do_the_work(\"%s\")'" % JSON.stringify(jDict)], output)
	#OS.execute("python", ["-c", '"from z3solve import *; print(let_z3_do_the_work(\'%s\'))"' % JSON.stringify(jDict)], output)
	OS.execute("python", ["-c", 'import sys; sys.path.append(\'F:/godot/projects/AdventGodot/scenes/Solutions/2025/Day10/RawSolution3/\'); from z3solve import *; print(let_z3_do_the_work(\'%s\'))' % JSON.stringify(jDict).c_escape()], output, true)

	print(output)
	solution = output[0].substr(0, output[0].length()-2).to_int()
	print(solution)
	
	return solution
