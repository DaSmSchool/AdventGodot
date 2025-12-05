extends Solution

var itemToItem: Dictionary[String, String]
var itemToItemReverse: Dictionary[String, String]
var seedRangesP2: Array

func parse_seeds(rawSeeds: String) -> Array:
	return Array(rawSeeds.substr(7).split(" ", false)).map(func(s): return int(s))

func parse_seeds_p2(rawSeeds: String) -> Array:
	var baseArray: Array = Array(rawSeeds.substr(7).split(" ", false)).map(func(s): return int(s))
	var rangeArray: Array = []
	for i: int in range(0, baseArray.size(), 2):
		# element 1 is 0 to make use of the same function for getting the intersection of comparison arrays.
		rangeArray.append([baseArray[i], 0, baseArray[i+1]])
	return rangeArray


func add_to_almanac(rawConvert: String, iti: Dictionary[String, String], conversions: Dictionary[String, Array]) -> void:
	var convertSplit: PackedStringArray = rawConvert.split("\n", false)
	var nameShortenedString: String = convertSplit[0].substr(0, convertSplit[0].length()-5)
	var linkNames: PackedStringArray = nameShortenedString.split("-to-", false)
	iti[linkNames[0]] = linkNames[1]
	
	conversions[linkNames[0]] = []
	var rawRanges: PackedStringArray = convertSplit.slice(1)
	for rawRange: String in rawRanges:
		var convertedRange: Array = Array(rawRange.split(" ", false)).map(func(s): return int(s))
		conversions[linkNames[0]].append(convertedRange)
	
func find_associated_land(seed: int, iti: Dictionary[String, String], conversions: Dictionary[String, Array]) -> int:
	var focusId: int = seed
	var focusItem: String = "seed"
	while focusItem != "location":
		var itemConversionList: Array = conversions[focusItem]
		for conversion: Array in itemConversionList:
			if focusId >= conversion[1] and focusId <= conversion[1] + conversion[2]:
				var conversionOffset: int = conversion[0] - conversion[1]
				focusId += conversionOffset
				break
		
		focusItem = iti[focusItem]
	return focusId

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var baseSeeds: Array = parse_seeds(inputSplit[0])
	print_log(baseSeeds)
	
	var itemToItem: Dictionary[String, String] = {}
	var itemConversions: Dictionary[String, Array] = {}
	var rawConversions: PackedStringArray = inputSplit.slice(1)
	for rawConvert: String in rawConversions:
		add_to_almanac(rawConvert, itemToItem, itemConversions)
	
	var associatedLocations: Array = []
	for seed: int in baseSeeds:
		associatedLocations.append(find_associated_land(seed, itemToItem, itemConversions))
	
	for type: String in itemConversions:
		print_log(str(type) + " : " + str(itemConversions[type]))
	
	return associatedLocations.min()

func get_overlap_range(rangeArr: Array, focusArr: Array) -> Array:
	var frontRangeStart: int = focusArr[0]
	var frontRangeEnd: int = focusArr[0] + focusArr[2]
	var backRangeStart: int = rangeArr[1]
	var backRangeEnd: int = rangeArr[1] + rangeArr[2]
	
	var biggestStart: int = max(frontRangeStart, backRangeStart)
	var smallestEnd: int = min(frontRangeEnd, backRangeEnd)
	
	if smallestEnd - biggestStart <= 0:
		return [0, 0, 0]
	else:
		return [0, biggestStart, smallestEnd-biggestStart]

# fill in ranges that represent using the same ID if there are gaps in ranges from 0 to maximum ID
func fill_in_range_gaps(conversionArray: Array, maximumId: int) -> void:
	# fill in 0-x range if not present
	if conversionArray[0][0] != 0:
		conversionArray.insert(0, [0, 0, conversionArray[0][0]])
	
	var convInd: int = 0
	while convInd < conversionArray.size()-1:
		var currentConvRange: Array = conversionArray[convInd]
		var conversionRangeEnd: int = currentConvRange[0] + currentConvRange[2]
		var nextRangeStart: int = conversionArray[convInd+1][0]
		if nextRangeStart-conversionRangeEnd > 0:
			var rangeDifference: int = nextRangeStart-conversionRangeEnd
			conversionArray.insert(convInd+1, [conversionRangeEnd, conversionRangeEnd, rangeDifference])
			convInd += 1
		convInd += 1 
	
	var lastConv: Array = conversionArray.back()
	var lastConvLastID: int = lastConv[0] + lastConv[2]
	if lastConvLastID != maximumId:
		conversionArray.append([lastConvLastID, lastConvLastID, maximumId-lastConvLastID])

	

func is_range_in_seeds(rangeArr: Array) -> int:
	var minStart: int = -1
	for seedRange: Array in seedRangesP2:
		var overlap: Array = get_overlap_range(rangeArr, seedRange)
		if overlap != [0, 0, 0]:
			if minStart == -1:
				minStart = overlap[1]
			else:
				minStart = min(minStart, overlap[1])
	return minStart

func dig_for_seed(item: String, rangeArr: Array, itemConversions: Dictionary[String, Array]) -> int:
	if item == "seed":
		return is_range_in_seeds(rangeArr)
		
	var targetItemConversions: Array = itemConversions[itemToItemReverse[item]]
	
	for focusArr: Array in targetItemConversions:
		var overlap: Array = get_overlap_range(rangeArr, focusArr)
		if overlap == [0, 0, 0]: continue
		
		
		
		
		var focusArrOffset: int = focusArr[1]-focusArr[0]
		overlap[1] += focusArrOffset

		var moreDiggingResult: int = dig_for_seed(itemToItemReverse[item], overlap, itemConversions)
		if moreDiggingResult != -1:
			print_log(item)
			print_log(rangeArr)
			print_log(focusArr)
			print_log(overlap)
			print_log()
			return moreDiggingResult
	
	return -1

func get_max_id(itemConversions: Dictionary[String, Array]) -> int:
	var maxNumber: int = 0
	for item: String in itemConversions:
		var convArrList: Array = itemConversions[item]
		for arr: Array in convArrList:
			var maxOfArr: int = arr[0] + arr[2]
			maxNumber = max(maxNumber, maxOfArr)
	return maxNumber

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	seedRangesP2 = parse_seeds_p2(inputSplit[0])
	print_log(seedRangesP2)
	
	itemToItem = {}
	var itemConversions: Dictionary[String, Array] = {}
	var rawConversions: PackedStringArray = inputSplit.slice(1)
	for rawConvert: String in rawConversions:
		add_to_almanac(rawConvert, itemToItem, itemConversions)
	
	itemToItemReverse = {}
	for item: String in itemToItem:
		itemToItemReverse[itemToItem[item]] = item
	
	var maxIdPossible: int = get_max_id(itemConversions)
	print_log("MAX: " + str(maxIdPossible))
	
	for conversionItem: String in itemConversions:
		var conversionArray: Array = itemConversions[conversionItem]
		conversionArray.sort_custom(func(a, b): return a[0] < b[0])
		fill_in_range_gaps(conversionArray, maxIdPossible)
	
	
	var lowestSeed: int = 0
	var locationConvs: Array = itemConversions[itemToItemReverse["location"]]
	for conv: Array in locationConvs:
		var checklowestSeed: int = dig_for_seed(itemToItemReverse["location"], conv, itemConversions)
		if checklowestSeed != -1:
			lowestSeed = checklowestSeed
			break
	
	solution = find_associated_land(lowestSeed, itemToItem, itemConversions)
	
	#for type: String in itemConversions:
		#print_log(str(type) + " : " + str(itemConversions[type]))
	
	return solution
