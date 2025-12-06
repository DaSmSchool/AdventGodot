extends Node
class_name Helper

static func print_fail(message: String) -> void:
	print_rich("[color=red][shake rate=20.0 level=5 connected=1]%s[/shake][/color]" % message)

static func load_advent_input(year: int, day: int) -> String:
	var fileContent: String = FileAccess.get_file_as_string("res://input/%d/D%d.txt" % [year, day])
	var fileError: int = FileAccess.get_open_error()
	print_rich("[rainbow freq=0.2 sat=1.0 val=1.0][wave amp=50.0 freq=5.0 connected=1][color=green]YEAR %d | DAY %d[/color][/wave][/rainbow]" % [year, day])
	if fileError != 0:
		print_fail("FAILED TO LOAD INPUT: (" + str(fileError) + ") " + str(error_string(fileError)))
	return fileContent

static func get_timezonedb_key() -> String:
	var fileContent: String = FileAccess.get_file_as_string("res://api/timezonedb.txt")
	var fileError: int = FileAccess.get_open_error()
	#print_rich("[rainbow freq=0.2 sat=1.0 val=1.0][wave amp=50.0 freq=5.0 connected=1][color=green] [/color][/wave][/rainbow]")
	if fileError != 0:
		print_fail("FAILED TO LOAD API KEY: (" + str(fileError) + ") " + str(error_string(fileError)))
	#print(fileContent.split("\n")[0])
	return fileContent.split("\n")[0]

static func valid_pos_at_grid(yInd: int, xInd: int, grid: Array) -> bool:
	return 0 <= yInd and yInd < grid.size() and 0 <= xInd and xInd < grid[0].size()

static func valid_pos_at_packed_string_array(yInd: int, xInd: int, grid: PackedStringArray) -> bool:
	return 0 <= yInd and yInd < grid.size() and 0 <= xInd and xInd < grid[0].length()

static func print_grid(grid: Array):
	for line in grid:
		var lineAssemble: String = ""
		for sub in line:
			lineAssemble += str(sub)
		print(lineAssemble)

static func shift_array(array: Array, n: int) -> Array:
	var size: int = array.size()
	var steps: int = abs(n) % size
	if size * steps == 0:
		return array
	
	var rotated_array: Array = array.duplicate()
	
	for i in range(steps):
		if sign(n) == 1:
			var front_element = rotated_array.pop_front()
			rotated_array.push_back(front_element)
		elif sign(n) == -1:
			var back_element = rotated_array.pop_back()
			rotated_array.push_front(back_element)
	
	return rotated_array

static func rotate_2d_array(arr: Array, n: int) -> Array:
	var height: int = arr.size()
	if height == 0: return []
	var width: int = arr[0].size()

	var new_arr = []
	for i: int in range(width):
		new_arr.append([])
		new_arr[i].resize(height)
	
	for i: int in range(height):
		for j: int in range(width):
			if sign(n) == 1:
				new_arr[j][height - 1 - i] = arr[i][j]
			elif sign(n) == -1:
				new_arr[width-1-j][i] = arr[i][j]
			
	return new_arr

static func rotate_2d_string_array(arr: Array, n: int) -> Array:
	var height: int = arr.size()
	if height == 0: return []
	var width: int = arr[0].length()

	var newArr = []
	for i: int in range(width):
		newArr.append("")
		for emptyCharInt: int in range(height):
			newArr[newArr.size()-1] += " "
	
	for i: int in range(height):
		for j: int in range(width):
			if sign(n) == 1:
				newArr[j][height-1-i] = arr[i][j]
			elif sign(n) == -1:
				newArr[width-1-j][i] = arr[i][j]
			
	return newArr

static func shared_elements(array1: Array, array2: Array) -> Array:
	var assembleArray: Array = []
	for element: Variant in array1:
		if element in array2:
			assembleArray.append(element)
	return assembleArray

static func is_prime(number: int) -> bool:
	if number <= 1:
		return false
	if number <= 3:
		return true
	if number % 2 == 0 or number % 3 == 0:
		return false
	var i = 5
	while i * i <= number:
		if number % i == 0 or number % (i+2) == 0:
			return false
		i += 6
	return true

static func get_positive_factors(number: int) -> Array:
	var factors: Array = []
	if number < 1:
		return []
	for i: int in range(1, sqrt(number)):
		if number/float(i) == number/i:
			factors.append(i)
			factors.append(number/i)
	factors.sort()
	return factors
