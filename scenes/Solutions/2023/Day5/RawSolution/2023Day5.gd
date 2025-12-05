extends Solution

func parse_seeds(rawSeeds: String) -> Array:
	return Array(rawSeeds.substr(7).split(" ", false)).map(func(s): return int(s))

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
	print(baseSeeds)
	
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

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n\n", false)
	var baseSeeds: Array = parse_seeds(inputSplit[0])
	print(baseSeeds)
	
	var itemToItem: Dictionary[String, String] = {}
	var itemConversions: Dictionary[String, Array] = {}
	var rawConversions: PackedStringArray = inputSplit.slice(1)
	for rawConvert: String in rawConversions:
		add_to_almanac(rawConvert, itemToItem, itemConversions)
	
	var associatedLocations: Array = []
	for seed: int in baseSeeds:
		associatedLocations.append(find_associated_land(seed, itemToItem, itemConversions))
	
	
	
	return associatedLocations.min()
