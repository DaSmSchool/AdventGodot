extends Solution

signal on_request_done

var httpJSON

var monthToInt: Dictionary[String, int] = {
	"Jan": 1,
	"Feb": 2,
	"Mar": 3
}

var apiResponses: Array = []

func solve1(input: String) -> int:
	var solution: int = 0
	
	%HTTPRequest.request_completed.connect(_on_request_completed)
	#%HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest")
	
	#var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone=America/Chicago"
	var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone="
	#print(apiBase)
	#print(Time.get_datetime_dict_from_unix_time(0))
		
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	print(inputSplit.size())
	
	for section: String in inputSplit:
		print()
		print(section)
		print()
		var fromTicketStr: String = section.split("\n")[0]
		var toTicketStr: String = section.split("\n")[1]
		var fromTicket: PackedStringArray = fromTicketStr.split(" ", false)
		var toTicket: PackedStringArray = toTicketStr.split(" ", false)
		
		var fromUnix: int = getUnixFromTicket(fromTicket)
		
		var toUnix: int = getUnixFromTicket(toTicket)
		
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
		print(resp)
	return solution

func getUnixFromTicket(ticket: PackedStringArray) -> int:
	var assembleDict: Dictionary = {
		"year": ticket[4].substr(0, 4).to_int(),
		"month": monthToInt[ticket[2]],
		"day": ticket[3].substr(0, 2).to_int(),
		"hour": ticket[5].split(":")[0].to_int(),
		"minute": ticket[5].split(":")[1].to_int()
	}
	print(assembleDict)
	return Time.get_unix_time_from_datetime_dict(assembleDict)

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
