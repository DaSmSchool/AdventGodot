extends Solution


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
		var reportCheckResult: bool = checkReport(report)
		if reportCheckResult:
			safeReports += 1
	
	solution = safeReports
	
	return solution

func checkReport(report: Array[int]) -> bool:
	var direction: int = sign(report[0]-report[1])
	if direction == 0: return false
	var safeReport: bool = true
	var badCount: int = 0
	for valInd: int in report.size()-1:
		var currDiff: int = report[valInd]-report[valInd+1]
		if abs(currDiff)>0 and abs(currDiff)<=3 and sign(currDiff) == direction:
			pass
		else:
			return false
	if safeReport:
		return true
	else:
		return false


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
		var reportCheckResult: bool = checkReport(report)
		if reportCheckResult:
			safeReports += 1
		else:
			for excludedInd: int in report.size():
				var dupReport: Array[int] = report.duplicate()
				dupReport.pop_at(excludedInd)
				reportCheckResult = checkReport(dupReport)
				if reportCheckResult == true:
					safeReports += 1
					break
			
	
	solution = safeReports
	
	
	return solution
