extends Node
class_name Helper

static func print_fail(message: String) -> void:
	print_rich("[color=red][shake rate=20.0 level=5 connected=1]%d[/shake][/color]" % message)

static func load_advent_input(year: int, day: int) -> String:
	var fileContent: String = FileAccess.get_file_as_string("res://input/%d/D%d.txt" % [year, day])
	var fileError: int = FileAccess.get_open_error()
	print_rich("[rainbow freq=0.2 sat=1.0 val=1.0][wave amp=50.0 freq=5.0 connected=1][color=green]YEAR %d | DAY %d[/color][/wave][/rainbow]" % [year, day])
	if fileError != 0:
		if fileError == 7:
			print_fail("ERROR: INPUT NOT FOUND!")
		else:
			print_fail("FAILED TO LOAD INPUT: ERROR" + str(fileError))
	return fileContent
