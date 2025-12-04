extends Solution

func get_paper_positions(input: String) -> Dictionary:
	var papers: Dictionary = {}
	
	var rows: PackedStringArray = input.split("\n", false)
	for rowInd: int in rows.size():
		for colInd: int in rows[rowInd].length():
			var focusChar: String = rows[rowInd][colInd]
			if focusChar == "@":
				papers[Vector2i(colInd, rowInd)] = true
	
	return papers

func get_pushable_papers(paperPosDict: Dictionary) -> Array:
	var pushablePapers: Array = []
	for paperPos: Vector2i in paperPosDict:
		var adjacentCount: int = 0
		for rowOff: int in range(-1, 2):
			for colOff: int in range(-1, 2):
				if rowOff | colOff != 0:
					var offPos: Vector2i = Vector2i(paperPos.x+colOff, paperPos.y+rowOff)
					if paperPosDict.has(offPos):
						adjacentCount += 1
		if adjacentCount < 4:
			pushablePapers.append(paperPos)
	return pushablePapers

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var paperPositions: Dictionary = get_paper_positions(input)
	var pushablePapers: Array = get_pushable_papers(paperPositions)
	solution = pushablePapers.size()
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var paperPositions: Dictionary = get_paper_positions(input)
	
	var pushablePapers: Array = get_pushable_papers(paperPositions)
	while not pushablePapers.is_empty():
		solution += pushablePapers.size()
		for pushablePaper: Vector2i in pushablePapers:
			paperPositions.erase(pushablePaper)
		pushablePapers = get_pushable_papers(paperPositions)
		
	return solution
