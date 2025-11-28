extends Solution

var lookupDirectionsToGrid: Dictionary = {
	"ne": Vector2i(-1, -1),
	"nw": Vector2i(0, -1),
	"e": Vector2i(-1, 0),
	"w": Vector2i(1, 0),
	"se": Vector2i(0, 1),
	"sw": Vector2i(1, 1),
}

func flip_tile_with_direction(lookupTiles: Dictionary, tileDirections: String) -> void:
	var position: Vector2i = Vector2i(0, 0)
	while tileDirections.length() > 0:
		for lookupKey: String in lookupDirectionsToGrid:
			if tileDirections.find(lookupKey) == 0:
				position += lookupDirectionsToGrid[lookupKey]
				tileDirections = tileDirections.substr(lookupKey.length())
				break
	if not lookupTiles.keys().has(position):
		lookupTiles[position] = true
	else:
		if lookupTiles[position] == true:
			lookupTiles.erase(position)
		else:
			lookupTiles[position] = true

func solve1(input: String) -> int:
	var solution: int = 0
	
	var lookupTiles: Dictionary[Vector2i, bool] = {}
	
	for tileDir: String in input.split("\n", false):
		flip_tile_with_direction(lookupTiles, tileDir)
	
	for key: Vector2i in lookupTiles:
		if lookupTiles[key] == true:
			solution += 1
	
	return solution

func day_pass(lookupTiles: Dictionary) -> Dictionary:
	var newDict: Dictionary = {}
	var checkTiles: Dictionary = {}
	
	for tile: Vector2i in lookupTiles:
		checkTiles[tile] = 1
		for directionOffestKey: String in lookupDirectionsToGrid:
			checkTiles[tile+lookupDirectionsToGrid[directionOffestKey]] = 1
	
	for checkTile: Vector2i in checkTiles:
		var surroundingTileCount: int = 0
		for surroundingOffset: String in lookupDirectionsToGrid:
			var offTile: Vector2i = checkTile + lookupDirectionsToGrid[surroundingOffset]
			if lookupTiles.has(offTile) and lookupTiles[offTile] == true:
				surroundingTileCount += 1
		if lookupTiles.has(checkTile):
			if not (surroundingTileCount == 0 or surroundingTileCount > 2):
				newDict[checkTile] = true
		else:
			if surroundingTileCount == 2:
				newDict[checkTile] = true
	return newDict

func solve2(input: String) -> int:
	var solution: int = 0
	
	var lookupTiles: Dictionary = {}
	
	for tileDir: String in input.split("\n", false):
		flip_tile_with_direction(lookupTiles, tileDir)
	
	var days: int = 100
	
	for day: int in range(days):
		lookupTiles = day_pass(lookupTiles)
		print(str(day) + " : " + str(lookupTiles.size()))
	
	solution = lookupTiles.size()
	
	return solution
