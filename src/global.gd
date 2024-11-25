func load_advent_input(year: int, day: int) -> String:
	var fileContent = FileAccess.get_file_as_string("res://input/Y%dD%d" % [year, day])
	return fileContent
