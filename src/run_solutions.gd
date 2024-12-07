extends Node

@export var focusYear: int = 2020
@export var focusDay: int = 4

func _ready():
	run_solution(focusYear, focusDay)

func run_solution(year: int, day: int) -> void:
	var adventInput = Helper.load_advent_input(year, day)
	
	var microTime: int
	var postMicroTime: int
	var p1Sol: int
	var p2Sol: int
	var solNode: Solution = get_node("%d" % focusYear).get_node("Day%d" % focusDay)
	if solNode == null:
		Helper.print_fail("NODE FOR YEAR%d DAY%d NOT FOUND" % [year, day])
		return
	
	# p1 run
	microTime = Time.get_ticks_msec()
	p1Sol = solNode.solve1(adventInput)
	postMicroTime = Time.get_ticks_msec()
	
	var p1Elapsed: float = postMicroTime - microTime
	print("PART 1 SOLUTION: %d" % [p1Sol])
	print("TIME TAKEN:")
	print("MILLISECONDS: %dms" % [p1Elapsed])
	print("SECONDS: %d seconds" % [p1Elapsed/1000])
	print()
	
	# p2 run
	microTime = Time.get_ticks_msec()
	p2Sol = solNode.solve2(adventInput)
	postMicroTime = Time.get_ticks_msec()
	
	var p2Elapsed: float = postMicroTime - microTime
	print("PART 2 SOLUTION: %d" % [p2Sol])
	print("TIME TAKEN:")
	print("MILLISECONDS: %dms" % [p2Elapsed])
	print("SECONDS: %d seconds" % [p2Elapsed/1000])
	print()
