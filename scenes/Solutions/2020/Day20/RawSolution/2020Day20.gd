extends Solution

func parse_raw_tile_string(input: String) -> Dictionary:
	var tileDict: Dictionary = {}
	
	
	var tileDictSplit: PackedStringArray = input.split("\n\n")
	for tile: String in tileDictSplit:
		var tileId: int = 0
		for row: String in tile.split("\n"):
			if row.is_empty(): continue
			#print(row)
			if row.contains("Tile"):
				tileId = row.substr(row.find(" ")+1, row.length()-6).to_int()
				tileDict[tileId] = {}
				tileDict[tileId]["tileId"] = tileId
				tileDict[tileId]["rawImage"] = []
				tileDict[tileId]["sharedEdgeTiles"] = []
				tileDict[tileId]["edgeData"] = ["", "", "", ""]
			else:
				tileDict[tileId]["rawImage"].append(row)
		#print()
		
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
		
		#for edge: String in tileDict[tileId]["edgeData"]:
			#print(edge)
		
	return tileDict

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var rawTileDict: Dictionary = parse_raw_tile_string(input)
	
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		for focusTileId: int in rawTileDict:
			var focusTile: Dictionary = rawTileDict[focusTileId]
			
			var isShared: bool = false
			for shareEdge: Array in tile["sharedEdgeTiles"]:
				if isShared: continue
				if shareEdge[0] == focusTileId:
					isShared = true
			
			if tile != focusTile and not isShared:
				for tileEdge: String in tile["edgeData"]:
					for focusTileEdge: String in focusTile["edgeData"]:
						if tileEdge == focusTileEdge or tileEdge == focusTileEdge.reverse():
							#print(str(tileId) + "/" + str(focusTileId))
							#print(tileEdge)
							tile["sharedEdgeTiles"].append([focusTileId, tileEdge])
							focusTile["sharedEdgeTiles"].append([tileId, focusTileEdge])
							
		if tile["sharedEdgeTiles"].size() == 2:
			#print(tileId)
			solution *= tileId
	
	#for tileId: int in rawTileDict:
		#print(str(tileId) + " : " + str(rawTileDict[tileId]["sharedEdgeTiles"].size()) + " : " + str(rawTileDict[tileId]["sharedEdgeTiles"]))
	
	return solution

func get_tile_dict_width(rawTileDict: Dictionary) -> int:
	# assuming tile array is a square
	var perimeterTilesAmount: int = 0
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		if tile["sharedEdgeTiles"].size() == 3:
			perimeterTilesAmount += 1
	return (perimeterTilesAmount/4) + 2

func get_first_corner_tile(rawTileDict: Dictionary) -> Dictionary:
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		if tile["sharedEdgeTiles"].size() == 2:
			return tile
	return {}

func build_first_row(tileArray: Array, rawTileDict: Dictionary) -> void:
	var focusedTileInd: int = 0
	while focusedTileInd < tileArray[0].size()-1:
		var buildOnTile: Dictionary = tileArray[0][focusedTileInd]
		var buildOnConnectedIds: Array = buildOnTile["sharedEdgeTiles"]
		
		var smallestConnectionTile: Dictionary = rawTileDict[buildOnConnectedIds[0][0]]
		if smallestConnectionTile in tileArray[0]:
			smallestConnectionTile = rawTileDict[buildOnConnectedIds[1][0]]
		for connectedInd: int in buildOnConnectedIds.size():
			var focusTileId: int = buildOnConnectedIds[connectedInd][0]
			var focusTile: Dictionary = rawTileDict[focusTileId]
			if focusTile["sharedEdgeTiles"].size() < smallestConnectionTile["sharedEdgeTiles"].size():
				if not (focusTile in tileArray[0]):
					smallestConnectionTile = focusTile
				
		
		tileArray[0][focusedTileInd+1] = smallestConnectionTile
		focusedTileInd += 1

func build_row_betweens(tileArray: Array, rawTileDict: Dictionary, focusRow: int):
	# build columns between the first and last elements
	for betweenTileInd: int in range(1, tileArray[0].size()-1):
		var aboveTile: Dictionary = tileArray[focusRow-1][betweenTileInd]
		
		var arrayDisconnectedId: int = 0
		for connectedIdsInd: int in aboveTile["sharedEdgeTiles"].size():
			if arrayDisconnectedId != 0: continue
			var connectedId: int = aboveTile["sharedEdgeTiles"][connectedIdsInd][0]
			var focusConnectedTile: Dictionary = rawTileDict[connectedId]
			
			var inArrayAlready: bool = false
			for row: Array in tileArray:
				if inArrayAlready: continue
				if focusConnectedTile in row:
					inArrayAlready = true
			
			if not inArrayAlready:
				arrayDisconnectedId = connectedId
		
		tileArray[focusRow][betweenTileInd] = rawTileDict[arrayDisconnectedId]

func get_shared_tile_not_in_array(tile1: Dictionary, tile2: Dictionary, tileArray: Array, rawTileDict: Dictionary) -> Dictionary:
	for connectedId1Ind: int in tile1["sharedEdgeTiles"].size():
		var connectedId1: int = tile1["sharedEdgeTiles"][connectedId1Ind][0]
		for connectedId2Ind: int in tile2["sharedEdgeTiles"].size():
			var connectedId2: int = tile2["sharedEdgeTiles"][connectedId2Ind][0]
			if connectedId1 == connectedId2:
				var testTile: Dictionary = rawTileDict[connectedId1]
				
				var testTileInArray: bool = false
				for row: Array in tileArray:
					if testTileInArray: continue
					if testTile in row:
						testTileInArray = true
				
				if not testTileInArray:
					return testTile
	
	return {}

func build_row(tileArray: Array, rawTileDict: Dictionary, focusRow: int) -> void:
	build_row_betweens(tileArray, rawTileDict, focusRow)
	
	# build first and last columns of row
	for i in range(1, 3):
		var focusX: int
		var xOff: int
		if i == 1:
			focusX = 0
			xOff = 1
		elif i == 2:
			focusX = tileArray[0].size()-1
			xOff = -1
		var edgeTileAbove: Dictionary = tileArray[focusRow-1][focusX]
		var edgeTileRow: Dictionary = tileArray[focusRow][focusX+xOff]
		
		var getInsertTile: Dictionary = get_shared_tile_not_in_array(edgeTileAbove, edgeTileRow, tileArray, rawTileDict)
		tileArray[focusRow][focusX] = getInsertTile
	
	

func make_grid_from_tile_dict(rawTileDict: Dictionary) -> Array:
	var tileArray: Array = []
	
	var dimensionSize: int = get_tile_dict_width(rawTileDict)
	
	tileArray.resize(dimensionSize)
	for tileArrayInd: int in tileArray.size():
		var tileArrayRow: Array = []
		tileArrayRow.resize(dimensionSize)
		tileArray[tileArrayInd] = tileArrayRow
	
	var firstCorner: Dictionary = get_first_corner_tile(rawTileDict)
	tileArray[0][0] = firstCorner
	
	build_first_row(tileArray, rawTileDict)
	
	var focusRow: int = 1
	while focusRow < dimensionSize:
		build_row(tileArray, rawTileDict, focusRow)
		focusRow += 1
	
	return tileArray
	

func solve2(input: String) -> Variant:
	var solution: int = 1
	
	var rawTileDict: Dictionary = parse_raw_tile_string(input)
	
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		for focusTileId: int in rawTileDict:
			var focusTile: Dictionary = rawTileDict[focusTileId]
			
			var isShared: bool = false
			for shareEdge: Array in tile["sharedEdgeTiles"]:
				if isShared: continue
				if shareEdge[0] == focusTileId:
					isShared = true
			
			if tile != focusTile and not isShared:
				for tileEdge: String in tile["edgeData"]:
					for focusTileEdge: String in focusTile["edgeData"]:
						if tileEdge == focusTileEdge or tileEdge == focusTileEdge.reverse():
							#print(str(tileId) + "/" + str(focusTileId))
							#print(tileEdge)
							tile["sharedEdgeTiles"].append([focusTileId, tileEdge])
							focusTile["sharedEdgeTiles"].append([tileId, focusTileEdge])
							
	var tileGrid: Array = make_grid_from_tile_dict(rawTileDict)
	
	var quickPrintArray: Array = []
	
	for rowInd: int in tileGrid.size():
		quickPrintArray.append([])
		for element in tileGrid[rowInd]:
			if element == null: quickPrintArray.back().append(null)
			else: quickPrintArray.back().append(element["tileId"])
		
	for row in quickPrintArray:
		print(row)
	
	return solution
