extends Solution

signal on_request_done

var httpJSON
var isCached: bool = false

var monthToInt: Dictionary[String, int] = {
	"Jan": 1,
	"Feb": 2,
	"Mar": 3
}

var apiResponses: Array = []

func check_and_use_cache():
	if FileAccess.file_exists("res://input/18/D4cache.txt"):
		var file = FileAccess.open("res://input/18/D4cache.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var json_string: String = file.get_line()

			var json = JSON.new()

			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
			apiResponses.append(json.data)
			
		isCached = true
		file.close()

func solve1(input: String) -> int:
	var solution: int = 0
	
	check_and_use_cache()
	
	%HTTPRequest.request_completed.connect(_on_request_completed)
	#%HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest")
	
	#var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone=America/Chicago"
	var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone="
	#print(apiBase)
	#print(Time.get_datetime_dict_from_unix_time(0))
		
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	print(inputSplit.size())
	
	for section: String in inputSplit:
		#print()
		#print(section)
		#print()
		var fromTicketStr: String = section.split("\n")[0]
		var toTicketStr: String = section.split("\n")[1]
		var fromTicket: PackedStringArray = fromTicketStr.split(" ", false)
		var toTicket: PackedStringArray = toTicketStr.split(" ", false)
		
		var fromUnix: int = getUnixFromTicket(fromTicket)
		var toUnix: int = getUnixFromTicket(toTicket)
		
		if not isCached:
			#print("A")
			await request_tzdb(apiBase + fromTicket[1] + "&time=" + str(fromUnix))
			#print("B")
			await on_request_done
			#print("C")
			await get_tree().create_timer(1).timeout
			#print("D")
			await request_tzdb(apiBase + toTicket[1] + "&time=" + str(toUnix))
			#print("E")
			await on_request_done
			#print("F")
		
	
	await apiResponses.size()==inputSplit.size()-1
	for resp in apiResponses:
		if not isCached:
			await get_tree().create_timer(0.2).timeout
			print(JSON.stringify(resp))
	
	solution = get_ticket_differences()
	
	return solution

func getUnixFromTicket(ticket: PackedStringArray) -> int:
	var assembleDict: Dictionary = {
		"year": ticket[4].substr(0, 4).to_int(),
		"month": monthToInt[ticket[2]],
		"day": ticket[3].substr(0, 2).to_int(),
		"hour": ticket[5].split(":")[0].to_int(),
		"minute": ticket[5].split(":")[1].to_int()
	}
	#print(assembleDict)
	return Time.get_unix_time_from_datetime_dict(assembleDict)

func get_ticket_differences() -> int:
	var sumDiff: int = 0
	
	for ticketSetInd: int in range(0, apiResponses.size(), 2):
		var fromTicket: Dictionary = apiResponses[ticketSetInd]
		var toTicket: Dictionary = apiResponses[ticketSetInd+1]
		var time1: int = fromTicket.timestamp - fromTicket.gmtOffset * 2
		var time2: int = toTicket.timestamp - toTicket.gmtOffset * 2
		var timeDiff: int = time2 - time1
		sumDiff += timeDiff
		#print(Time.get_datetime_string_from_unix_time(time1))
		#print(Time.get_datetime_string_from_unix_time(time2))
		print(timeDiff/60)
	print(sumDiff/60)
	return sumDiff/60

func request_tzdb(str: String) -> void:
	await get_tree().create_timer(1.5).timeout
	%HTTPRequest.request(str)

func _on_request_completed(result, response_code, headers, body):
	print(result)
	print(response_code)
	print(headers)
	#print(body)
	httpJSON = JSON.parse_string(body.get_string_from_utf8())
	apiResponses.append(httpJSON)
	on_request_done.emit()
