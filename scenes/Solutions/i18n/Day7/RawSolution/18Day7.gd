extends Solution

var cacheDict: Dictionary[int, Object]
var isCached: bool = false

func check_and_use_cache():
	if FileAccess.file_exists("res://input/18/D7cache.txt"):
		var file = FileAccess.open("res://input/18/D7cache.txt", FileAccess.READ)

		var json_string: String = file.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			assert(false)
		cacheDict = json.data
			
		isCached = true
		file.close()
	else:
		save_cache("hi", "res://input/18/D7cache.txt")

func save_cache(str: String, path: String):
	if FileAccess.file_exists("res://input/18/D7cache.txt"):
		var file = FileAccess.open("res://input/18/D7cache.txt", FileAccess.WRITE_READ)
		
		file.store_string(str)
		
		file.close()
		
func solve1(input: String) -> int:
	var solution: int = 0
	
	%HTTPRequest.request_completed.connect(_on_request_completed)
	var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone="
	isCached = check_and_use_cache()

	
	var inputSplit: PackedStringArray = input.split("\n")
	
	for lineInd: int in inputSplit.size():
		var line: String = inputSplit[lineInd]
		if line == "": continue
		var auditSplit: PackedStringArray = line.split("\t")
		var timestampDict: Dictionary = Time.get_datetime_dict_from_datetime_string(auditSplit[0], false)
		
		# "America/Halifax", "America/Santiago", or "both"
		var assumedTimezone: String
		var apiCallObject
		
		if timestamp_needs_checking(timestampDict):
			if isCached:
				apiCallObject = cacheDict[lineInd]
		else:
			assumedTimezone = get_timezone_no_api(timestampDict)
		print(auditSplit)
		print(timestampDict)
	
	
	return solution

func timestamp_needs_checking(tsDict: Dictionary) -> bool:
	return false

func get_timezone_no_api(dict: Dictionary) -> String:
	return "both"

func request_tzdb(str: String) -> void:
	await get_tree().create_timer(1.5).timeout
	%HTTPRequest.request(str)

func _on_request_completed():
	pass
