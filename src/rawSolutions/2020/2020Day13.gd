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
			busGaps.append(buses.find(str(validBuses[busInd]))-buses.find(str(validBuses[busInd-1])))
	#print(busGaps)
	
	var focusInd: int = 0
	var consecutiveFound: bool = false
	var incrAmounts: Array = []
	incrAmounts.append(validBuses[0])
	var currentBusToFindInd: int = 1
	var lastIndOfCurrentPattern: int = -1
	var searchIndOffset: int = busGaps[currentBusToFindInd]
	
	while !consecutiveFound:
		focusInd += incrAmounts.back()
		
		var busModulos: Array = []
		busModulos.append(focusInd % validBuses[0])
		var indOff: int = 1
		for bus: int in range(1, validBuses.size()):
			var sOff: int = busGaps[bus-1]
			busModulos.append((focusInd+sOff) % validBuses[bus])
			
		print(focusInd)
		print(busModulos)
		
		if (focusInd+searchIndOffset) % validBuses[currentBusToFindInd] == 0:
			if lastIndOfCurrentPattern == -1:
				lastIndOfCurrentPattern = focusInd
				firstIndsFound.append(lastIndOfCurrentPattern)
			else:
				currentBusToFindInd += 1
				if currentBusToFindInd == validBuses.size():
					consecutiveFound = true
					break
				var incrementAmount = focusInd-lastIndOfCurrentPattern
				incrAmounts.append(incrementAmount)
				lastIndOfCurrentPattern = -1
				searchIndOffset += busGaps[currentBusToFindInd-1]
				
		
	solution = firstIndsFound.back()
	
	return solution
