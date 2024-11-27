extends Node

var focusYear: int = 2020
var focusDay: int = 1

func _ready():
	run_solution(focusYear, focusDay)

func run_solution(year: int, day: int) -> void:
	var adventInput = Helper.load_advent_input(year, day)
	print(get_node("%d" % focusYear).get_node("Day%d" % focusDay).solve1(adventInput))
	print(get_node("%d" % focusYear).get_node("Day%d" % focusDay).solve2(adventInput))
