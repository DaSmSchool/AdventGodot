extends Solution

signal got_request

var httpJSON

func solve1(input: String) -> int:
	var solution: int = 0
	
	%HTTPRequest.request_completed.connect(_on_request_completed)
	#%HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest")
	
	#var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone=America/Chicago"
	var apiBase: String = "http://api.timezonedb.com/v2.1/get-time-zone?key=" + Helper.get_timezonedb_key() + "&format=json&by=zone&zone="
	print(apiBase)
		
	
	var inputSplit: PackedStringArray = input.split("\n\n")
	
	for section: String in inputSplit:
		var fromTicketStr: String = section.split("\n")[0]
		var toTicketStr: String = section.split("\n")[1]
		var fromTicket: PackedStringArray = fromTicketStr.split(" ", false)
		var toTicket: PackedStringArray = toTicketStr.split(" ", false)
		
		await request_tzdb(apiBase + fromTicket[1])
		await _on_request_completed
	
	return solution

func request_tzdb(str: String) -> void:
	await get_tree().create_timer(1).timeout
	%HTTPRequest.request(str)

func _on_request_completed(result, response_code, headers, body):
	#print(result)
	#print(response_code)
	#print(headers)
	#print(body)
	httpJSON = JSON.parse_string(body.get_string_from_utf8())
	print(httpJSON)
