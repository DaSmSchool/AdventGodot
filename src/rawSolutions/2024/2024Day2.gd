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
	
	var reports: Array = []
	var safeReports: int = 0
	
	for line in inputSplit:
		if line == "": continue
		var report: Array[int] = []
		var rawReportSplit: PackedStringArray = line.split(" ")
		for val: String in rawReportSplit:
			report.append(val.to_int())
		reports.append(report)
	
	for report: Array[int] in reports:
		var direction: int = sign(report[0]-report[1])
		if direction == 0: continue
		var safeReport: bool = true
		for valInd: int in report.size()-1:
			var currDiff: int = report[valInd]-report[valInd+1]
			if abs(currDiff)>0 and abs(currDiff)<=3 and sign(currDiff) == direction:
				pass
			else:
				safeReport = false
				break
		if safeReport:
			safeReports += 1
	
	solution = safeReports
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	var reports: Array = []
	var safeReports: int = 0
	
	for line in inputSplit:
		if line == "": continue
		var report: Array[int] = []
		var rawReportSplit: PackedStringArray = line.split(" ")
		for val: String in rawReportSplit:
			report.append(val.to_int())
		reports.append(report)
	
	for report: Array[int] in reports:
		var direction: int = sign(report[0]-report[1])
		if direction == 0: continue
		var safeReport: bool = true
		var badCount: int = 0
		for valInd: int in report.size()-1:
			var currDiff: int = report[valInd]-report[valInd+1]
			if abs(currDiff)>0 and abs(currDiff)<=3 and sign(currDiff) == direction:
				pass
			else:
				if valInd < report.size()-2:
					currDiff = report[valInd]-report[valInd+2]
					if abs(currDiff)>0 and abs(currDiff)<=3 and sign(currDiff) == direction:
						pass
					else:
						safeReport = false
						break
		if safeReport:
			safeReports += 1
	
	solution = safeReports
	
	return solution
