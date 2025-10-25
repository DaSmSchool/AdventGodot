extends Solution

func get_grid(input: String) -> Array[PackedStringArray]:
	input.replace("\t", "    ")
	
	var inputLines: PackedStringArray = input.split("\n")
	var grid: Array[PackedStringArray] = []
	for line: String in inputLines:
		if line == "": continue
		var assemble: String = ""
		for char: String in line:
			if char == "\t":
				for time in range(0, 4):
					assemble += " "
			else:
				assemble += char
		grid.append(assemble.split())
	return grid

func solve1(input: String) -> int:
	var solution: int = 0
	var grid: Array[PackedStringArray] = get_grid(input)
	
	var playerX: int = 0
	var playerY: int = 0
	
	while playerY < grid.size():
		if grid[playerY][playerX] == "💩":
			solution += 1
		
		playerX += 2
		playerX %= grid[playerY].size()
		playerY += 1
	
	return solution
