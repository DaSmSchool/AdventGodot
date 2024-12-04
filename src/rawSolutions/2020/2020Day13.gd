extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var timestamp: int = inputSplit[0].to_int()
	var buses: PackedStringArray = inputSplit[1].split(",")
	var validBuses: Array[int] = []
	
	for bus: String in buses:
		if bus != "x":
			validBuses.append(bus.to_int())
	
	var busTimeRemainders: Array[int] = []
	
	for bus: int in validBuses:
		busTimeRemainders.append(bus - (timestamp % bus))
	
	var leastBusTime: int = busTimeRemainders.min()
	var smallestTimeBusID: int = validBuses[busTimeRemainders.find(leastBusTime)]
	
	solution = leastBusTime * smallestTimeBusID
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	var timestamp: int = inputSplit[0].to_int()
	var buses: PackedStringArray = inputSplit[1].split(",")
	var validBuses: Array[int] = []
	var busGaps: Array[int] = []
	var firstIndsFound: Array[int] = []
	
	for bus: String in buses:
		if bus != "x":
			validBuses.append(bus.to_int())
	
	for busInd: int in validBuses.size():
		if busInd != 0:
			# difference of amount of xs, defining gaps
			busGaps.append(
				buses.find( str(validBuses[busInd]) ) - buses.find( str(validBuses[busInd-1]) )
				)
	#print(busGaps)
	
	var focusInd: int = 0
	var consecutiveFound: bool = false
	var incrAmounts: Array = []
	incrAmounts.append(validBuses[0])
	var currentBusToFindInd: int = 1
	var firstIndOfCurrentPattern: int = -1
	var searchIndOffset: int = busGaps[currentBusToFindInd-1]
	
	while !consecutiveFound:
		focusInd += incrAmounts.back()
		
		if (focusInd+searchIndOffset) % validBuses[currentBusToFindInd] == 0:
			if firstIndOfCurrentPattern == -1:
				if currentBusToFindInd == validBuses.size()-1:
					solution = focusInd
					break
				firstIndOfCurrentPattern = focusInd
			else:
				incrAmounts.append(focusInd-firstIndOfCurrentPattern)
				focusInd = firstIndOfCurrentPattern-incrAmounts.back()
				currentBusToFindInd += 1
				searchIndOffset += busGaps[currentBusToFindInd-1]
				firstIndOfCurrentPattern = -1
	print(incrAmounts)
	return solution
