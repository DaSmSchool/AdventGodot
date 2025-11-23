extends Solution

func initialize_tile(tile: String) -> Dictionary:
	var newTile: Dictionary = {}
	var tileId: int = 0
	for row: String in tile.split("\n"):
		if row.is_empty(): continue
		#print(row)
		if row.contains("Tile"):
			tileId = row.substr(row.find(" ")+1, row.length()-6).to_int()
			newTile["tileId"] = tileId
			newTile["rawImage"] = []
			newTile["sharedEdgeTiles"] = []
			newTile["edgeData"] = ["", "", "", ""]
		else:
			newTile["rawImage"].append(row)
	
	# initialize edge data
	var focusTile: Array = newTile["rawImage"]
	newTile["edgeData"][0] = focusTile.front()
	newTile["edgeData"][2] = focusTile.back()
	
	var assembleLeftColumn: String = ""
	var assembleRightColumn: String = ""
	for row: String in focusTile:
		assembleLeftColumn += row.left(1)
		assembleRightColumn += row.right(1)
	
	newTile["edgeData"][1] = assembleRightColumn
	newTile["edgeData"][3] = assembleLeftColumn
	
	return newTile

func parse_raw_tile_string(input: String) -> Dictionary:
	var tileDict: Dictionary = {}
	
	var tileDictSplit: PackedStringArray = input.split("\n\n")
	for tile: String in tileDictSplit:
		var newTile: Dictionary = initialize_tile(tile)
		tileDict[newTile["tileId"]] = newTile
		
	return tileDict

func link_tiles(tile1: Dictionary, tile2: Dictionary) -> void:
	var isShared: bool = false
	for shareEdge: Array in tile1["sharedEdgeTiles"]:
		if isShared: continue
		if shareEdge[0] == tile2["tileId"]:
			isShared = true
	if tile1 == tile2 or isShared: return
	
	for tileEdgeInd: int in tile1["edgeData"].size():
		var tileEdge: String = tile1["edgeData"][tileEdgeInd]
		for focusTileEdgeInd: int in tile2["edgeData"].size():
			var focusTileEdge: String = tile2["edgeData"][focusTileEdgeInd]
			if tileEdge == focusTileEdge or tileEdge == focusTileEdge.reverse():
				#print(str(tileId) + "/" + str(focusTileId))
				#print(tileEdge)
				tile1["sharedEdgeTiles"].append([tile2["tileId"], tileEdge, tileEdgeInd])
				tile2["sharedEdgeTiles"].append([tile1["tileId"], focusTileEdge, focusTileEdgeInd])

func link_tiles_in_tile_dict(rawTileDict: Dictionary) -> void:
	for tileId: int in rawTileDict:
		var tile: Dictionary = rawTileDict[tileId]
		for focusTileId: int in rawTileDict:
			var focusTile: Dictionary = rawTileDict[focusTileId]
			link_tiles(tile, focusTile)

func solve1(input: String) -> Variant:
	var solution: int = 1
	
	var rawTileDict: Dictionary = parse_raw_tile_string(input)
	
	link_tiles_in_tile_dict(rawTileDict)
	
	for tileId: int in rawTileDict:
		if rawTileDict[tileId]["sharedEdgeTiles"].size() == 2:
			solution *= tileId
	
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

func get_actual_surrounding_tile_ids(tileGrid: Array, rowInd: int, tileInd: int) -> Array:
	var surroundingArray: Array = []
	surroundingArray.resize(4)
	for rowOff: int in range(-1, 2):
		for colOff: int in range(-1, 2):
			# odd spot check
			if abs(rowOff + colOff) % 2 == 0: continue
			
			var absRow: int = rowInd + rowOff
			var absCol: int = tileInd + colOff
			if not Helper.valid_pos_at_grid(absRow, absCol, tileGrid): continue
			
			var addTile: Dictionary = tileGrid[absRow][absCol]
			var offVector: Vector2i = Vector2i(colOff, rowOff)
			if offVector == Vector2i(0, -1):
				surroundingArray[0] = addTile["tileId"]
			elif offVector == Vector2i(1, 0):
				surroundingArray[1] = addTile["tileId"]
			elif offVector == Vector2i(0, 1):
				surroundingArray[2] = addTile["tileId"]
			elif offVector == Vector2i(-1, 0):
				surroundingArray[3] = addTile["tileId"]
					
	return surroundingArray

func get_tile_orientation_edge_order(tile: Dictionary) -> Array:
	var surroundingArray: Array = []
	surroundingArray.resize(4)
	for edge: Array in tile["sharedEdgeTiles"]:
		surroundingArray[edge[2]] = edge[0]
	return surroundingArray

func fix_tile_orientation(tile: Dictionary, tileGrid: Array, rowInd: int, tileInd: int) -> void:
	var surroundingTileIds: Array = get_actual_surrounding_tile_ids(tileGrid, rowInd, tileInd)
	var imageSurroundingTileIds: Array = get_tile_orientation_edge_order(tile)
	
	if tile["tileId"] == 2953:
		pass
	
	#print(surroundingTileIds)
	#print(imageSurroundingTileIds)
	#print()
	
	# first pass, either rotation or flipping happens
	var firstTestElement: int = -1
	var firstTestElementInd: int
	for elementInd in imageSurroundingTileIds.size():
		if firstTestElement != -1: continue
		if imageSurroundingTileIds[elementInd] != null:
			firstTestElement = imageSurroundingTileIds[elementInd]
			firstTestElementInd = elementInd
	
	var firstCompareInd: int = surroundingTileIds.find(imageSurroundingTileIds[firstTestElementInd])
	
	var firstElementDistance = firstTestElementInd - firstCompareInd
	
	# if the two improperly placed objects are 2 spots over, that means they can be flipped
	# if they are an odd amount of spaces over, that can be fixed with a rotation
	match firstElementDistance:
		0:
			pass
		1, -3:
			imageSurroundingTileIds = Helper.shift_array(imageSurroundingTileIds, 1)
			tile["rawImage"] = Helper.rotate_2d_string_array(tile["rawImage"], -1)
		2, -2:
			var tempStore = imageSurroundingTileIds[firstCompareInd]
			imageSurroundingTileIds[firstCompareInd] = imageSurroundingTileIds[firstTestElementInd]
			imageSurroundingTileIds[firstTestElementInd] = tempStore
			tile["rawImage"].reverse()
		3, -1:
			imageSurroundingTileIds = Helper.shift_array(imageSurroundingTileIds, -1)
			tile["rawImage"] = Helper.rotate_2d_string_array(tile["rawImage"], 1)
	
	#print(surroundingTileIds)
	#print(imageSurroundingTileIds)
	#print()
	pass
	
	# second pass, only either horizontal or flipping occurs
	var secondTestElementInd: int = -1
	for elementInd in imageSurroundingTileIds.size():
		if imageSurroundingTileIds[elementInd] != null and imageSurroundingTileIds[elementInd] != firstTestElement:
			if imageSurroundingTileIds[elementInd] != surroundingTileIds[elementInd]:
				secondTestElementInd = elementInd
	
	var secondCompareInd: int
	# if no differing elements were found
	if secondTestElementInd != -1:
		secondCompareInd = surroundingTileIds.find(imageSurroundingTileIds[secondTestElementInd])
		if secondTestElementInd != secondCompareInd:
			var tempStore: int = imageSurroundingTileIds[secondTestElementInd]
			imageSurroundingTileIds[secondTestElementInd] = imageSurroundingTileIds[secondCompareInd]
			imageSurroundingTileIds[secondCompareInd] = tempStore
			if secondTestElementInd in [0, 2]:
				tile["rawImage"].reverse()
			else:
				for rawImgRowInd: int in tile["rawImage"].size():
					tile["rawImage"][rawImgRowInd] = tile["rawImage"][rawImgRowInd].reverse()
	
	#Helper.print_grid(tile["rawImage"])
	#
	#print(surroundingTileIds)
	#print(imageSurroundingTileIds)
	#print()
	assert(surroundingTileIds == imageSurroundingTileIds, "not transformed properly")
	pass
	
	#for row: String in tile["rawImage"]:
		#print(row)
	#print("________________")

func orient_tiles_in_grid(tileGrid: Array) -> void:
	for rowInd: int in tileGrid.size():
		for tileInd: int in tileGrid[rowInd].size():
			var tile: Dictionary = tileGrid[rowInd][tileInd]
			fix_tile_orientation(tile, tileGrid, rowInd, tileInd)

func strip_tile_border(tile: Dictionary) -> void:
	var tileImage: Array = tile["rawImage"]
	
	#Helper.print_grid(tileImage)
	#print()
	tileImage = tileImage.slice(1, tileImage.size()-1)
	
	for rowInd: int in tileImage.size():
		tileImage[rowInd] = tileImage[rowInd].substr(1, tileImage[rowInd].length()-2)
	
	#Helper.print_grid(tileImage)
	#print()
	
	tile["rawImage"] = tileImage

func get_picture(tileArray: Array) -> PackedStringArray:
	var manipTileArray: Array = tileArray.duplicate_deep()
	for row: Array in manipTileArray:
		for tile: Dictionary in row:
			strip_tile_border(tile)
	
	var assemblePicture: PackedStringArray = []
	for row: Array in manipTileArray:
		var tileHeight: int = row[0]["rawImage"].size()
		for tileRow: int in tileHeight:
			var rowStr: String = ""
			for tile: Dictionary in row:
				rowStr += tile["rawImage"][tileRow]
			assemblePicture.append(rowStr)
	
	return assemblePicture

func get_monster_check_spots(monsterStrings: PackedStringArray) -> Array:
	var checkSpotArray: Array = []
	for rowInd: int in monsterStrings.size():
		for colInd: int in monsterStrings[rowInd].length():
			if monsterStrings[rowInd][colInd] == "#":
				checkSpotArray.append(Vector2i(colInd, rowInd))
	return checkSpotArray

func find_monster_areas_in_picture(picture: PackedStringArray, monster: Array, monsterWidth: int, monsterLength: int) -> Dictionary:
	var monsterSpotDict: Dictionary[Vector2i, int] = {}
	for rowInd: int in range(0, picture.size()-monsterLength):
		for colInd: int in range(0, picture[0].length()-monsterWidth):
			var monsterSpotList: Array[Vector2i] = []
			var canHaveMonster: bool = true
			for spot: Vector2i in monster:
				if not canHaveMonster: continue
				var spotAbsX: int = colInd + spot.x
				var spotAbsY: int = rowInd + spot.y
				if picture[spotAbsY][spotAbsX] != "#":
					canHaveMonster = false
				else:
					monsterSpotList.append(Vector2i(spotAbsX, spotAbsY))
			if canHaveMonster:
				for spot: Vector2i in monsterSpotList:
					monsterSpotDict[spot] = 1
	return monsterSpotDict

func print_monstered_grid(picture: PackedStringArray, spots: Array) -> void:
	for rowInd: int in picture.size():
		var printRow: String = ""
		for colInd: int in picture[0].length():
			if spots.has(Vector2i(colInd, rowInd)):
				printRow += "O"
			else:
				printRow += picture[rowInd][colInd]
		print(printRow)

func get_hash_count(picture: PackedStringArray) -> int:
	var hashCount: int = 0
	for row: String in picture:
		for char: String in row:
			if char == "#":
				hashCount += 1
	return hashCount

func first_row_cleanup(tileGrid: Array) -> void:
	for tileInd: int in tileGrid.size():
		var tile: Dictionary = tileGrid[0][tileInd]
		var focusTile: Dictionary = tileGrid[1][tileInd]
		if tile["rawImage"].back() != focusTile["rawImage"].front():
			tile["rawImage"] = Helper.rotate_2d_string_array(tile["rawImage"], 2)

func solve2(input: String) -> Variant:
	
	var rawTileDict: Dictionary = parse_raw_tile_string(input)
	
	link_tiles_in_tile_dict(rawTileDict)
	
	var tileGrid: Array = make_grid_from_tile_dict(rawTileDict)
	
	orient_tiles_in_grid(tileGrid)
	
	first_row_cleanup(tileGrid)
	
	var compactBorderlessArray: PackedStringArray = get_picture(tileGrid)
	
	var length: int = get_tile_dict_width(rawTileDict)
	
	for row: Array in tileGrid:
		var tileHeight: int = row[0]["rawImage"].size()
		
		var tileIdRow: String = ""
		for tile: Dictionary in row:
			tileIdRow += str(tile["tileId"]) + "       "
		print(tileIdRow)
		
		for tileRow: int in tileHeight:
			var rowStr: String = ""
			for tile: Dictionary in row:
				rowStr += tile["rawImage"][tileRow] + " "
			print(rowStr)
		print()
	
	#Helper.print_grid(compactBorderlessArray)
	
	var monsterArray: PackedStringArray = [
		"                  # ",
		"#    ##    ##    ###",
		" #  #  #  #  #  #   "
	]
	
	var monsterWidth: int = monsterArray[0].length()
	var monsterLength: int = monsterArray.size()
	
	var monsterCheckspots: Array = get_monster_check_spots(monsterArray)
	var monsterSpots: Dictionary
	
	var hashCount: int = get_hash_count(compactBorderlessArray)
	
	for flip in range(2):
		for i in range(4):
			monsterSpots = find_monster_areas_in_picture(compactBorderlessArray, monsterCheckspots, monsterWidth, monsterLength)
			if monsterSpots.keys().size() != 0:
				print_monstered_grid(compactBorderlessArray, monsterSpots.keys())
				return hashCount - monsterSpots.keys().size()
			else:
				compactBorderlessArray = Helper.rotate_2d_string_array(compactBorderlessArray, 1)
		compactBorderlessArray.reverse()
	
	return hashCount - monsterSpots.keys().size()
