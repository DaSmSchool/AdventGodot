extends Solution

func parse_raw_tile_string(input: String) -> Dictionary:
	var tileDict: Dictionary = {}
	
	
	var tileDictSplit: PackedStringArray = input.split("\n\n")
	for tile: String in tileDictSplit:
		var tileId: int = 0
		for row: String in tile.split("\n"):
			if row.is_empty(): continue
			print(row)
			if row.contains("Tile"):
				tileId = row.substr(row.find(" ")+1, row.length()-6).to_int()
				tileDict[tileId] = {}
				tileDict[tileId]["rawImage"] = []
				tileDict[tileId]["sharedEdgeTiles"] = []
				tileDict[tileId]["edgeData"] = ["", "", "", ""]
			else:
				tileDict[tileId]["rawImage"].append(row)
		print()
		
		var focusTile: Array = tileDict[tileId]["rawImage"]
		tileDict[tileId]["edgeData"][0] = focusTile.front()
		tileDict[tileId]["edgeData"][2] = focusTile.back()
		
		var assembleLeftColumn: String = ""
		var assembleRightColumn: String = ""
		
		for row: String in focusTile:
			assembleLeftColumn += row.left(1)
			assembleRightColumn += row.right(1)
		
		tileDict[tileId]["edgeData"][1] = assembleRightColumn
		tileDict[tileId]["edgeData"][3] = assembleLeftColumn
		
		for edge: String in tileDict[tileId]["edgeData"]:
			print(edge)
		
	return tileDict

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var rawTileDict: Dictionary = parse_raw_tile_string(input)
	
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		for focusTileId: int in rawTileDict:
			var focusTile: Dictionary = rawTileDict[focusTileId]
			if tile != focusTile and not tile["sharedEdgeTiles"].has(focusTileId):
				for tileEdge: String in tile["edgeData"]:
					for focusTileEdge: String in focusTile["edgeData"]:
						if tileEdge == focusTileEdge or tileEdge == focusTileEdge.reverse():
							print(str(tileId) + "/" + str(focusTileId))
							print(tileEdge)
							tile["sharedEdgeTiles"].append(focusTileId)
							focusTile["sharedEdgeTiles"].append(tileId)
							
		if tile["sharedEdgeTiles"].size() == 2:
			print(tileId)
			solution *= tileId
	
	for tileId: int in rawTileDict:
		print(str(tileId) + " : " + str(rawTileDict[tileId]["sharedEdgeTiles"].size()) + " : " + str(rawTileDict[tileId]["sharedEdgeTiles"]))
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	
	
	return solution
